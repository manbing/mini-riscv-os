	.section    .text.crt0,"ax",@progbits
	.global _start
        .type   _start, @function
        .align 2

_start:
	.cfi_startproc
        .cfi_undefined ra

	lui sp, 0x80001
	jal main

        .cfi_endproc

finish:
	beq t1, t1, finish


        .end
