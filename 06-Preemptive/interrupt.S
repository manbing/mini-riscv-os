#include "linkage.h"
#include "asm_reg.S"

ENTRY(do_mach_timer_intrrupt)
        jal systick_init

        /* load kernel state */

        // get kernel stack
        csrrw sp, mscratch, sp
        
        pop_ctx
        csrr a0, mscratch
        ret
ENDPROC(do_mach_timer_intrrupt)
