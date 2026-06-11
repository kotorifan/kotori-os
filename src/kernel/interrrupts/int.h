// int.h
#pragma once

#include <stdint.h>

typedef struct {
	uint16_t base_low;
	uint16_t selector;
	uint8_t reserved;
	uint8_t flags;
	uint16_t base_high;
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

void idt_set_gate(uint32_t n, uint32_t handler);
void interrupt_handler(void);
void exception_handler(void);
