#include "linkage.h"

.section    .text.crt0,"ax",@progbits
.global _start
.type   _start, @function
.align 4
_start:
	.cfi_startproc
        .cfi_undefined ra

	// machine stack pointer
	lui sp, 0x80005
	csrw mscratch, sp

        // mtvec
        la t0, isr_vectors
        csrw mtvec, t0
        
	// stvec
        la t0, s_isr_vectors
        csrw stvec, t0

        // mepc
        la t1, main
        csrw mepc, t1

        // mstatus
        csrr t4, mstatus
        li t1, 1
        slli t2, t1, 11 // supervisor mode
        or t4, t4, t2
        csrw mstatus, t4

	//medeleg
        csrr t4,medeleg
        li t1, 1
        slli t2, t1, 8 // ecall from u-mode
        or t4, t4, t2
        csrw medeleg, t4

	/* SysTick configuration */
        jal systick_init

	/* s-mode & u-mode access memory */
	li t0, 0x1f
	csrw    pmpcfg0, t0
	li t0, -1
	csrw    pmpaddr0, t0

        // supervisor stack pointer
	lui sp, 0x8000a
	mret

        .cfi_endproc

finish:
	beq t1, t1, finish


        .end
