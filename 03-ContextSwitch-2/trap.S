#include "linkage.h"
#include "asm_reg.S"

ENTRY(do_trap_ecall_u)
        // get kernel stack
        csrrw t6, sscratch, t6

        // epc
	lw t0, STACK_OFFSET_EPC(t6)
        csrw mepc, t0

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

        pop_ctx t6
        csrr a0, mscratch
        mret
ENDPROC(do_trap_ecall_u)
