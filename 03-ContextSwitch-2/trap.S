#include "linkage.h"
#include "asm_reg.S"

ENTRY(do_trap_ecall_u)
        csrrw sp, sscratch, sp
        pop_ctx
        csrr a0, sscratch
        ret
ENDPROC(do_trap_ecall_u)
