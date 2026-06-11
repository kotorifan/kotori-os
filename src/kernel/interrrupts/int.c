// int.c
// interrupt-related stuff
#include <stdint.h>
#include <stdbool.h>
#include <interrupts/int.h>
extern void _load_idt(const idt_ptr_t idt_ptr);
extern void _enable_ints(void);
extern void _hang(void);
extern uint64_t int_stub_table[];
static idt_ptr_t idt_ptr;
__attribute__((aligned(0x10));
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
	idt_ptr_t = {
		.base = (void*)&idt[0];
		.limit = (uint64_t)sizeof(idt_entry_t) * IDT_GATES_MAX -1;
	};
	
	for(uint8_t vector = 0; vector < 32; vector++) {
		idt_set_gate(vector, idt[vector]);
		vectors[vector] = true;
	}
}

void idt_set_gate(uint32_t n, uint32_t handler)
{
	// check if handlers shouldn't be 64-bit
	idt[n] = {
		.base_low = handler & 0xffff,
		.selector = 0x08;
		.reserved = 0,
		.flags = 0x8e,
		.base_high = (handler >> 16) & 0xffff
	};
	_load_idt(); // lidt; ret
	_enable_ints(); // sti; ret
}

void interrupt_handler(const cpu_state_t* cpu_state)
{
	
}

__attribute__((noreturn))
void exception_handler(const cpu_state_t* cpu_state)
{
	serial_write("An exception occurred. You screwed up.\n");
	serial_write(exception_messages[cpu_state->err]);
	_hang(); // clt; ret
}
