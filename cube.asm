/*
 * Adapted from LPC1769_asm_basic : asm.s
 * CK Tham, ECE, NUS
 * June 2011
 */

@ Directives
		.thumb                  @ (same as saying '.code 16')
	 	.cpu cortex-m3
		.syntax unified
	 	.align 2

@ Equates
        .equ STACKINIT,   0x10008000

@ Vectors
vectors:
        .word STACKINIT         @ stack pointer value when stack is empty
        .word _start + 1        @ reset vector (manually adjust to odd for thumb)
        .word _nmi_handler + 1  @
        .word _hard_fault  + 1  @
        .word _memory_fault + 1 @
        .word _bus_fault + 1    @
        .word _usage_fault + 1  @
	    .word 0            		@ checksum

		.global _start

@ Start of executable code
.section .text

_start:

@ code starts
@ Calculate cube 
	MOV R0, #2 
	MUL R1, R0, R0
	MUL R1, R0
	LDR R2, =ANSWER
	STR R1, [R2]

@ Loop at the end to allow inspection of registers and memory
loop:
	b loop

@ Loop if any exception gets triggered
_exception:
_nmi_handler:
_hard_fault:
_memory_fault:
_bus_fault:
_usage_fault:
        b _exception

@ Store result in SRAM (4 bytes)
	.lcomm	ANSWER	4
	.end
