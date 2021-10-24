#include "asm_reg.S"

/*
 * activate(): supervisor mode -> user mode
 */
.type activate, %function
.global activate
activate:
	.cfi_startproc
        /* save kernel state */
        mv t6, sp
        push_ctx t6
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
        
        pop_ctx t6
        sret

        .cfi_endproc

        .end
