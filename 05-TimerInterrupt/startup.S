#include "asm_reg.S"

.section    .text.crt0,"ax",@progbits
.global _start
.type   _start, @function
.align 4
_start:
	.cfi_startproc
        .cfi_undefined ra

        // stack pointer
	lui sp, 0x80001

        // tvec
        la t0, isr_vectors
        csrw mtvec, t0

        // epc
        la t1, main
        csrw mepc, t1
       
        // status
        csrr t4, mstatus
        li t1, 1 // supervisor mode
        slli t2, t1, 11
        or t4, t4, t2
        csrw mstatus, t4

	/* SysTick configuration */
        jal systick_init
	
	li t0, 0x1f
	csrw    pmpcfg0, t0
	li t0, -1
	csrw    pmpaddr0, t0

	mret

        .cfi_endproc

finish:
	beq t1, t1, finish

.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 4
isr_vectors:
	.cfi_startproc
        mv t6, sp
        push_ctx t6
        csrw   mscratch, t6

        csrr a0, mcause
        csrr t1, mepc
        csrr t2, mtval

        li t1, MCAUSE_INT_MASK
        and t2, a0, t1
	beqz t2, 2f
1: // interrput
	jal async_handler
        j 3f
2: // exception
	jal sync_handletr
3:
	csrr t6, mscratch
        pop_ctx t6
        mret
        .cfi_endproc
        .end
