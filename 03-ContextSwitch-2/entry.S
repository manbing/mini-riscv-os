#include "context_switch.S"
#include "linkage.h"

/*
 * activate(): supervisor mode -> user mode
 */
.type activate, %function
.global activate
activate:
	.cfi_startproc
        /* save kernel state */
        mv t6, sp
        thread_save t6
        mv sp, t6

        // epc
        sw ra, STACK_OFFSET_EPC(t6)

        // save kernel stack
        csrrw t6, sscratch, t6

        /* load user state */
        mv t6, a0

        // status
        lw t0, STACK_OFFSET_STATUS(t6)
        csrw sstatus, t0
        
        // epc
	lw t1, STACK_OFFSET_EPC(t6)
        csrw sepc, t1
        
        thread_restore t6
        sret

        .cfi_endproc

ENTRY(int_vect_table)
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
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
isr_vectors:
	.cfi_startproc
        mv t6, sp
        register_save t6
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
        register_restore t6
        mret
        .cfi_endproc

        .end
