#include "asm_reg.h"

.macro push_frame frame
        addi \frame, \frame, -140 // 35 * 4

        sw x1, STACK_OFFSET_RA(\frame)
        sw x2, STACK_OFFSET_SP(\frame)
        sw x3, STACK_OFFSET_GP(\frame)
        sw x5, STACK_OFFSET_T0(\frame)
        sw x6, STACK_OFFSET_T1(\frame)
        sw x7, STACK_OFFSET_T2(\frame)
        sw x8, STACK_OFFSET_S0(\frame)
        sw x9, STACK_OFFSET_S1(\frame)
        sw x10, STACK_OFFSET_A0(\frame)
        sw x11, STACK_OFFSET_A1(\frame)
        sw x12, STACK_OFFSET_A2(\frame)
        sw x13, STACK_OFFSET_A3(\frame)
        sw x14, STACK_OFFSET_A4(\frame)
        sw x15, STACK_OFFSET_A5(\frame)
        sw x16, STACK_OFFSET_A6(\frame)
        sw x17, STACK_OFFSET_A7(\frame)
        sw x18, STACK_OFFSET_S2(\frame)
        sw x19, STACK_OFFSET_S3(\frame)
        sw x20, STACK_OFFSET_S4(\frame)
        sw x21, STACK_OFFSET_S5(\frame)
        sw x22, STACK_OFFSET_S6(\frame)
        sw x23, STACK_OFFSET_S7(\frame)
        sw x24, STACK_OFFSET_S8(\frame)
        sw x25, STACK_OFFSET_S9(\frame)
        sw x26, STACK_OFFSET_S10(\frame)
        sw x27, STACK_OFFSET_S11(\frame)
        sw x28, STACK_OFFSET_T3(\frame)
        sw x29, STACK_OFFSET_T4(\frame)
        sw x30, STACK_OFFSET_T5(\frame)
        sw x31, STACK_OFFSET_T6(\frame)
.endm

.macro pop_frame frame
        lw x1, STACK_OFFSET_RA(\frame)
        lw x3, STACK_OFFSET_GP(\frame)
        lw x4, STACK_OFFSET_TP(\frame)
        lw x5, STACK_OFFSET_T0(\frame)
        lw x6, STACK_OFFSET_T1(\frame)
        lw x7, STACK_OFFSET_T2(\frame)
        lw x8, STACK_OFFSET_S0(\frame)
        lw x9, STACK_OFFSET_S1(\frame)
        lw x10, STACK_OFFSET_A0(\frame)
        lw x11, STACK_OFFSET_A1(\frame)
        lw x12, STACK_OFFSET_A2(\frame)
        lw x13, STACK_OFFSET_A3(\frame)
        lw x14, STACK_OFFSET_A4(\frame)
        lw x15, STACK_OFFSET_A5(\frame)
        lw x16, STACK_OFFSET_A6(\frame)
        lw x17, STACK_OFFSET_A7(\frame)
        lw x18, STACK_OFFSET_S2(\frame)
        lw x19, STACK_OFFSET_S3(\frame)
        lw x20, STACK_OFFSET_S4(\frame)
        lw x21, STACK_OFFSET_S5(\frame)
        lw x22, STACK_OFFSET_S6(\frame)
        lw x23, STACK_OFFSET_S7(\frame)
        lw x24, STACK_OFFSET_S8(\frame)
        lw x25, STACK_OFFSET_S9(\frame)
        lw x26, STACK_OFFSET_S10(\frame)
        lw x27, STACK_OFFSET_S11(\frame)
        lw x28, STACK_OFFSET_T3(\frame)
        lw x29, STACK_OFFSET_T4(\frame)
        lw x30, STACK_OFFSET_T5(\frame)
        lw x31, STACK_OFFSET_T6(\frame)
        lw x2, STACK_OFFSET_SP(\frame)

        addi \frame, \frame, 140 // 35 * 4
.endm

/*
 * ecall_handler(): user mode -> machine mode
 */
.type ecall_handler, %function
.global ecall_handler
ecall_handler:
	.cfi_startproc
        /* save user state */
        push_frame sp

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

        pop_frame sp
        csrr a0, sscratch
        mret
        
        .cfi_endproc

/*
 * activate(): supervisor mode -> user mode
 */
.type activate, %function
.global activate
activate:
	.cfi_startproc
        /* save kernel state */
        push_frame sp

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

        pop_frame sp
        sret

        .cfi_endproc

        .end
