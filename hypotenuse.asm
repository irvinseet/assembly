/*
 * LPC1769_asm_hypotenuse : asm.s
 * Adapted from CG2028 LPC1769_asm_basic : asm.s
 * CK Tham, ECE, NUS
 * June 2011
 *
 *
 * Find nearest integer corresponding to hypotenuse given right-angle sides of triangle
 * sides A and B are defined
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
@ Find A*A + B*B
@ Find value of C*C closest to above, starting from 1
	LDR R0, A @ PC-relative load
	LDR R1, B
	MUL R0, R0 @ Square A
	MUL R1, R1 @ Square B
	ADD R2, R1, R0 @sqA + sqB
	MOV R3, #1

sqloop:
	MUL R4, R3, R3
	CMP R4, R2
	ITEE HI @ if square(x) > (R2) ^ 2
	MOVHI R5, R3 @ smallest C^2 greater than R2
	MOVLS R6, R3 @ largest C^2 smaller than R2
	ADDLS R3, #1
	BLS sqloop

	SUB R7, R5, R2; @ find difference of upper bound
	SUB R8, R2, R6; @ find difference of lower bound

	LDR R9, =ANSWER @ prep answer for R9

	CMP R7, R8 @ if R7 - R8 > 0, take R6
	ITE HI
	MOVHI R10, R6
	MOVLS R10, R5

	STR R10, [R9]


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

@ Define constant values
A:
	.word 4
B:
	.word 3
@ Store result in SRAM (4 bytes)
	.lcomm	ANSWER	4
	.end
