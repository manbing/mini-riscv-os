#include "linkage.h"
#include "asm_reg.S"

ENTRY(do_trap_ecall_u)
        /* load kernel state */

        // get kernel stack
        csrrw sp, mscratch, sp
        
        pop_ctx
        csrr a0, mscratch
        ret
ENDPROC(do_trap_ecall_u)
