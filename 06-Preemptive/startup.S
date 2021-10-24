#include "asm_reg.S"
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

        // supervisor stack pointer
	lui sp, 0x8000a
	mret

        .cfi_endproc

finish:
	beq t1, t1, finish

ENTRY(int_vect_table)
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word do_mach_timer_intrrupt
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
END(int_vect_table)

ENTRY(excep_vect_table)
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word do_trap_ecall_u
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
END(excep_vect_table)

.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 2
isr_vectors:
	.cfi_startproc
        mv t6, sp
        push_ctx t6
        csrw   mscratch, t6

        csrr a0, mcause
        csrr t1, mepc
        csrr t2, mtval

        // dispatch trap
        li t1, MCAUSE_INT_MASK
        and t2, a0, t1

        li t3, MCAUSE_EXCEP_CODE_MASK 
        and t4, a0, t3

	beqz t2, 2f
1: // interrput, async_handler
        // epc
        csrr t0, mepc
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, int_vect_table
        slli t3, t4, 2
        add t0, t0, t3
        lw t1, 0(t0)
        jalr t1
        j 3f
2: // exception, sync_handler
        // epc
        csrr t0, mepc
        addi t0, t0, 4 // TODO: get following command of ecall.
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, excep_vect_table
        slli t3, t4, 2
        add t0, t0, t3
        lw t1, 0(t0)
        jalr t1
3:
        csrr   t6, mscratch
        pop_ctx t6
        mret
        .cfi_endproc

        .end
