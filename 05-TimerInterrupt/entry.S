#include "context_switch.S"

.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 4
isr_vectors:
	.cfi_startproc
        mv t6, sp
        register_save t6
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
        register_restore t6
        mret
        .cfi_endproc

        .end
