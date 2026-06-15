// int.c
// interrupt-related stuff
#include <interrupts/int.h>
#include <drivers/serial/serial.h>
#include <stdbool.h>
#include <stdint.h>

#define IDT_GATES_MAX 32

typedef void (*interrupt_routine_t)(const cpu_state_t*);

extern void* int_stub_table[];

extern void _load_idt(const idt_ptr_t* idt_ptr);
extern void _enable_ints(void);
extern void _hang(void);

static idt_ptr_t idt_ptr;
__attribute__((aligned(16)))
static idt_gate_t idt[IDT_GATES_MAX];
													
static bool vectors[IDT_GATES_MAX];
uint64_t routine_handlers[IDT_GATES_MAX];
static const char* exception_messages[] = {
	"Division by Zero (0x00)",
	"Debug (0x01)",
	"Non-maskable interrupt (0x02)",
	"Breakpoint (0x03)",
	"Into detected overflow (0x04)",
	"Out of bounds (0x05)",
	"Invalid opcode (0x06)",
	"No coprocessor (0x07)",
	"Double fault (0x08)",
	"Coprocessor segment overrun (0x09)",
	"Bad TSS 0x0a",
	"Segment not present (0x0b)",
	"Stack Fault (0x0c)	",
	"General Protection Fault (0x0d)",
	"Page Fault (0x0e)",
	"Unknown Interrupt (0x0f)",
	"Coprocessor Fault (0x10)",
	"Alignment check (0x11)",
	"Machine check (0x12)",
	"SIMD Floating Exception (0x13)",
	"Virtual Exception (0x14)",
	"Control Protection Exception (0x15)",
	"Reserved (0x16)",
	"Reserved (0x17)",
	"Reserved (0x18)",
	"Reserved (0x19)",
	"Reserved (0x1a)",
	"Reserved (0x1b)",
	"Hypervisor Intrusion Exception (0x1c)",
	"VMM Communications Exception (0x1e)",
	"Security Excpetion (0x1d)",
	"Reserved (0x1f)"
};

void idt_init(void)
{
	idt_ptr = (idt_ptr_t){
		.limit = sizeof(idt) - 1,
		.base = (uint64_t)&idt[0]
	};

	for(uint32_t v = 0; v < IDT_GATES_MAX; v++) {
		vectors[v] = false;
		idt_set_gate(v, (uint64_t)int_stub_table[v]);
	}
	/* idt_setup_gates(); */
	_load_idt(&idt_ptr); // lidt; ret (might change this to idt_ptr->base)
	_enable_ints(); // sti; ret
}

void idt_set_gate(const uint8_t n, uint64_t handler)
{
	// check if handlers shouldn't be 64-bit
	idt[n] = (idt_gate_t){
		.base_low = handler & 0xffff,
		.selector = 0x08,
		.reserved = 0,
		.flags = 0x8e,
		.base_mid = (handler >> 16) & 0xffff,
		.base_high = (handler >> 32) & 0xffffffff,
		.zero = 0
	};
}

/* void idt_setup_gates(void) */
/* { */
/* 	idt_set_gate(0, (uint64_t)int_stub_0); */
/* 	idt_set_gate(1, (uint64_t)int_stub_1); */
/* 	idt_set_gate(2, (uint64_t)int_stub_2); */
/* 	idt_set_gate(3, (uint64_t)int_stub_3); */
/* 	idt_set_gate(4, (uint64_t)int_stub_4); */
/* 	idt_set_gate(5, (uint64_t)int_stub_5); */
/* 	idt_set_gate(6, (uint64_t)int_stub_6); */
/* 	idt_set_gate(7, (uint64_t)int_stub_7); */
/* 	idt_set_gate(8, (uint64_t)int_stub_error_code_8); */
/* 	idt_set_gate(9, (uint64_t)int_stub_9); */
/* 	idt_set_gate(10, (uint64_t)int_stub_error_code_10); */
/* 	idt_set_gate(11, (uint64_t)int_stub_error_code_11); */
/* 	idt_set_gate(12, (uint64_t)int_stub_error_code_12); */
/* 	idt_set_gate(13, (uint64_t)int_stub_error_code_13); */
/* 	idt_set_gate(14, (uint64_t)int_stub_error_code_14); */
/* 	idt_set_gate(15, (uint64_t)int_stub_15); */
/* 	idt_set_gate(16, (uint64_t)int_stub_16); */
/* 	idt_set_gate(17, (uint64_t)int_stub_error_code_17); */
/* 	idt_set_gate(18, (uint64_t)int_stub_18); */
/* 	idt_set_gate(19, (uint64_t)int_stub_19); */
/* 	idt_set_gate(20, (uint64_t)int_stub_20); */
/* 	idt_set_gate(21, (uint64_t)int_stub_21); */
/* 	idt_set_gate(22, (uint64_t)int_stub_22); */
/* 	idt_set_gate(23, (uint64_t)int_stub_23); */
/* 	idt_set_gate(24, (uint64_t)int_stub_24); */
/* 	idt_set_gate(25, (uint64_t)int_stub_25); */
/* 	idt_set_gate(26, (uint64_t)int_stub_26); */
/* 	idt_set_gate(27, (uint64_t)int_stub_27); */
/* 	idt_set_gate(28, (uint64_t)int_stub_28); */
/* 	idt_set_gate(29, (uint64_t)int_stub_29); */
/* 	idt_set_gate(30, (uint64_t)int_stub_30); */
/* 	idt_set_gate(31, (uint64_t)int_stub_31); */
/* 	idt_set_gate(32, (uint64_t)int_stub_32); */

/* } */

void interrupt_handler(const cpu_state_t* cpu_state)
{
	serial_write("INTERRUPT: ");
	if(cpu_state->inter < 32)
		exception_handler(cpu_state);

    interrupt_routine_t handler = (interrupt_routine_t)routine_handlers[cpu_state->inter];

	if(handler)
		handler(cpu_state);

	if(cpu_state->inter >= 40) 
		_outb(0xa0, 0x20);
	_outb(0x20, 0x20);

	serial_write("Interrupt invoked");
}

__attribute__((noreturn))
void exception_handler(const cpu_state_t* cpu_state)
{
	serial_write("An exception occurred. You screwed up.\n");
	if(cpu_state->inter < 32)
		serial_write(exception_messages[cpu_state->inter]);
	else
		serial_write("Unknown exception");
	for(;;) _hang(); // clt; ret
}
