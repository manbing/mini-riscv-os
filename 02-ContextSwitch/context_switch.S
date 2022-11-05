#include "asm_reg.h"

.macro thread_save frame
        addi \frame, \frame, -140 // 35 * 4

        sw x1, STACK_OFFSET_RA(\frame)
        sw x2, STACK_OFFSET_SP(\frame)
        sw x8, STACK_OFFSET_S0(\frame)
        sw x9, STACK_OFFSET_S1(\frame)
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
.endm

.macro thread_restore frame
        lw x1, STACK_OFFSET_RA(\frame)
        lw x8, STACK_OFFSET_S0(\frame)
        lw x9, STACK_OFFSET_S1(\frame)
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
        lw x2, STACK_OFFSET_SP(\frame)

        addi \frame, \frame, 140 // 35 * 4
.endm

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
