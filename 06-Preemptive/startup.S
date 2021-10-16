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
       
	lui sp, 0x80005
	jal main

        .cfi_endproc

finish:
	beq t1, t1, finish

        .end
