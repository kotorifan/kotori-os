// int.h
#pragma once

#include <stdint.h>

typedef struct {
	uint16_t offset_low;
	uint16_t segment;
	uint8_t ist;
	uint8_t attributes;
	uint16_t offset_mid;
	uint32_t offset_high;
	uint32_t reserved;
} __attribute__((packed)) idt_gate_t;

typedef struct {
	uint16_t limit;
	uint64_t base;
} __attribute__((packed)) idt_ptr_t;

typedef struct {
	uint64_t rax;
    uint64_t rbx;
    uint64_t rcx;
    uint64_t rdx;
    uint64_t rsi;
    uint64_t rdi;
    uint64_t rbp;
	uint64_t r8;
	uint64_t r9;
	uint64_t r10;
	uint64_t r11;
	uint64_t r12;
	uint64_t r13;
	uint64_t r14;
	uint64_t r15;

    uint64_t inter;
    uint64_t err;

    // Von der CPU gesichert
    uint64_t rip;
    uint64_t cs;
    uint64_t eflags;
    uint64_t rsp;
    uint64_t ss;
} cpu_state_t;

void idt_init(void);
void idt_set_gate(const uint8_t n, void* handler);
void isr_handler(const cpu_state_t* cpu_state);
void exception_handler(const cpu_state_t* cpu_state);

extern void isr_stub_0(void);
extern void isr_stub_1(void);
extern void isr_stub_2(void);
extern void isr_stub_3(void);
extern void isr_stub_4(void);
extern void isr_stub_5(void);
extern void isr_stub_6(void);
extern void isr_stub_7(void);
extern void isr_stub_8(void);
extern void isr_stub_9(void);
extern void isr_stub_10(void);
extern void isr_stub_11(void);
extern void isr_stub_12(void);
extern void isr_stub_13(void);
extern void isr_stub_14(void);
extern void isr_stub_15(void);
extern void isr_stub_16(void);
extern void isr_stub_17(void);
extern void isr_stub_18(void);
extern void isr_stub_19(void);
extern void isr_stub_20(void);
extern void isr_stub_21(void);
extern void isr_stub_22(void);
extern void isr_stub_23(void);
extern void isr_stub_24(void);
extern void isr_stub_25(void);
extern void isr_stub_26(void);
extern void isr_stub_27(void);
extern void isr_stub_28(void);
extern void isr_stub_29(void);
extern void isr_stub_30(void);
extern void isr_stub_31(void);
extern void irq_stub_32(void);
extern void irq_stub_33(void);
extern void irq_stub_34(void);
extern void irq_stub_35(void);
extern void irq_stub_36(void);
extern void irq_stub_37(void);
extern void irq_stub_38(void);
extern void irq_stub_39(void);
extern void irq_stub_40(void);
extern void irq_stub_41(void);
extern void irq_stub_42(void);
extern void irq_stub_43(void);
extern void irq_stub_44(void);
extern void irq_stub_45(void);
extern void irq_stub_46(void);
extern void irq_stub_47(void);