#include "context_switch.S"
#include "linkage.h"

ENTRY(do_trap_ecall_u)
        csrrw t6, sscratch, t6
	
	lw t0, STACK_OFFSET_EPC(t6)
	csrw sepc, t0
       
	csrr t4, sstatus
	lw t0, STACK_OFFSET_STATUS(t6)
        li t1, 1
        slli t2, t1, 8 // supervisor mode
        or t4, t4, t2
        csrw sstatus, t4

	register_restore t6
	csrr a0, sscratch
        sret
ENDPROC(do_trap_ecall_u)

ENTRY(do_mach_timer_intrrupt)
        jal systick_init

        csrrw t6, sscratch, t6
	
        // epc
	lw t0, STACK_OFFSET_EPC(t6)
        csrw mepc, t0

        csrr t4, mstatus
        li t1, 1
        slli t2, t1, 11 // supervisor mode
        or t4, t4, t2
        csrw mstatus, t4

        register_restore t6
	csrr a0, sscratch
        mret
ENDPROC(do_mach_timer_intrrupt)

ENTRY(int_vect_table)
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word do_mach_timer_intrrupt
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
END(int_vect_table)

ENTRY(excep_vect_table)
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word do_trap_ecall_u
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0
END(excep_vect_table)

.section .text.metal.init.trapvec
.global s_isr_vectors
.type s_isr_vectors, @function
.align 4
s_isr_vectors:
	.cfi_startproc
        mv t6, sp
        register_save t6

        csrr a0, scause
        csrr t1, sepc
        csrr t2, stval

        // dispatch trap
        li t1, MCAUSE_INT_MASK
        and t2, a0, t1

        li t3, MCAUSE_EXCEP_CODE_MASK 
        and t4, a0, t3

	beqz t2, 2f
1: // interrput, async_handler
        // epc
        csrr t0, sepc
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, int_vect_table
        slli t3, t4, 2
        add t0, t0, t3
        lw t1, 0(t0)
        jalr t1
        j 3f
2: // exception, sync_handler
        // epc
        csrr t0, sepc
        addi t0, t0, 4 // TODO: get following command of ecall.
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, excep_vect_table
        slli t3, t4, 2
        add t0, t0, t3
	lw t1, 0(t0)
        jalr t1
3:
        register_restore t6
        sret
        .cfi_endproc


.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 2
isr_vectors:
	.cfi_startproc
        mv t6, sp
        register_save t6
        csrw   mscratch, t6

        csrr a0, mcause
        csrr t1, mepc
        csrr t2, mtval

        // dispatch trap
        li t1, MCAUSE_INT_MASK
        and t2, a0, t1

        li t3, MCAUSE_EXCEP_CODE_MASK 
        and t4, a0, t3

	beqz t2, 2f
1: // interrput, async_handler
        // epc
        csrr t0, mepc
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, int_vect_table
        slli t3, t4, 2
        add t0, t0, t3
        lw t1, 0(t0)
        jalr t1
        j 3f
2: // exception, sync_handler
        // epc
        csrr t0, mepc
        addi t0, t0, 4 // TODO: get following command of ecall.
        sw t0, STACK_OFFSET_EPC(t6)

	la t0, excep_vect_table
        slli t3, t4, 2
        add t0, t0, t3
        lw t1, 0(t0)
        jalr t1
3:
        register_restore t6
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
        mv t6, sp
        register_save t6
        mv sp, t6

        // epc
        sw ra, STACK_OFFSET_EPC(t6)
        
        csrr t0, sstatus
	lw t0, STACK_OFFSET_STATUS(t6)

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
        
        register_restore t6
        sret

        .cfi_endproc

        .end
