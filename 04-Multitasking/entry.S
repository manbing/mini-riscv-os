#include "context_switch.S"

/*
 * ecall_handler(): user mode -> machine mode
 */
.type ecall_handler, %function
.global ecall_handler
ecall_handler:
	.cfi_startproc
        /* save user state */
        register_save sp

        // epc
        csrr t0, mepc
        addi t0, t0, 4 // TODO: get following command of ecall.
        sw t0, STACK_OFFSET_EPC(sp)

        // status
        csrr t0, sstatus
        sw t0, STACK_OFFSET_STATUS(sp)

        /* load kernel state */

        // get kernel stack
        csrrw sp, sscratch, sp

        // epc
	lw t1, STACK_OFFSET_EPC(sp)
        csrw mepc, t1

        // status
        csrr t4, mstatus
        li t1, 1 // supervisor mode
        slli t2, t1, 11 //MSTATUS_MPP
        or t4, t4, t2

        li t1, 1
        slli t2, t1, 7 //MSTATUS_MPIE
        not t3, t2
        and t4, t4, t3
        csrw mstatus, t4

        register_restore sp
        csrr a0, sscratch
        mret
        
        .cfi_endproc

.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 4
isr_vectors:
	.cfi_startproc
        csrr t0, mcause
        csrr t1, mepc
        csrr t2, mtval
        j ecall_handler
        .cfi_endproc

/*
 * activate(): supervisor mode -> user mode
 */
.type activate, %function
.global activate
activate:
	.cfi_startproc
        /* save kernel state */
        thread_save sp

        // epc
        sw ra, STACK_OFFSET_EPC(sp)

        // status
        csrr t0, sstatus
        sw t0, STACK_OFFSET_STATUS(sp)

        // save kernel stack
        csrrw sp, sscratch, sp

        /* load user state */
        mv sp, a0

        // status
        lw t0, STACK_OFFSET_STATUS(sp)
        csrw sstatus, t0

        // epc
	lw t1, STACK_OFFSET_EPC(sp)
        csrw sepc, t1

        thread_restore sp
        sret

        .cfi_endproc

        .end
