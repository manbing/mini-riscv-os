.section    .text.crt0,"ax",@progbits
.global _start
.type   _start, @function
.align 4
_start:
	.cfi_startproc
        .cfi_undefined ra

        // stack pointer
	lui sp, 0x8000a

        // tvec
        la t0, isr_vectors
        csrw mtvec, t0

        // epc
        la t1, main
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
	
	li t0, 0x1f
	csrw    pmpcfg0, t0
	li t0, -1
	csrw    pmpaddr0, t0

        mret

        .cfi_endproc

finish:
	beq t1, t1, finish

.section .text.metal.init.trapvec
.global isr_vectors
.type isr_vectors, @function
.align 4
isr_vectors:
	.cfi_startproc
        csrr t0, mcause
        csrr t1, mepc
        csrr t2, mtval
        j ecall_handler
        .cfi_endproc
        .end
