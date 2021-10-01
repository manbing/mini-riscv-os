	.section    .text.crt0,"ax",@progbits
	.global _start
        .type   _start, @function
        .align 2

_start:
	.cfi_startproc
        .cfi_undefined ra

        // epc
        la t1, main
        csrw mepc, t1
       
        // status
        csrr t4, mstatus

        li t1, 3
        slli t2, t1, 11
        not t3, t2
        and t4, t4, t3

        li t1, 1 // supervisor mode
        slli t2, t1, 11
        or t4, t4, t2
        
        csrw mstatus, t4

        // stack pointer
	lui sp, 0x80001

        mret
        
        .cfi_endproc

finish:
	beq t1, t1, finish


        .end
