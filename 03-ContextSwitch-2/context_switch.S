#include "asm_reg.S"

/*
 * activate(): supervisor mode -> user mode
 */
.type activate, %function
.global activate
activate:
	.cfi_startproc
        /* save kernel state */
        push_ctx

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
        
        pop_ctx
        sret

        .cfi_endproc

        .end
