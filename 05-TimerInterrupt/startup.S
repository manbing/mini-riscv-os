.section    .text.crt0,"ax",@progbits
.global _start
.type   _start, @function
.align 4
_start:
	.cfi_startproc
        .cfi_undefined ra

        // stack pointer
	lui sp, 0x80001

        // tvec
        la t0, isr_vectors
        csrw mtvec, t0

        // epc
        la t1, main
        csrw mepc, t1
       
        // status
        csrr t4, mstatus
        li t1, 1 // supervisor mode
        slli t2, t1, 11
        or t4, t4, t2
        csrw mstatus, t4

	/* SysTick configuration */
        jal systick_init
	
	li t0, 0x1f
	csrw    pmpcfg0, t0
	li t0, -1
	csrw    pmpaddr0, t0

	mret

        .cfi_endproc

finish:
	beq t1, t1, finish

        .end
