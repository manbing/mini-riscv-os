.section    .text.crt0,"ax",@progbits
.global _start
.type   _start, @function
.align 4
_start:
	.cfi_startproc
        .cfi_undefined ra

        // tvec
        la t0, isr_vectors
        csrw mtvec, t0

	lui sp, 0x80001
	jal main

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
