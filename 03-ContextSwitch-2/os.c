#include <stdint.h>
#include "reg.h"
#include "asm.h"
#include "riscv.h"

void usertask(void)
{
        print_str("usertask: 1st call of usertask!\n");
        print_str("usertask: Now, return to kernel mode\n");
        syscall();
        print_str("usertask: 2nd call of usertask!\n");
        print_str("usertask: Now, return to kernel mode\n");
        syscall();
        while (1); /* Never terminate the task */
}

void main(void)
{
        /* 
         * Initialization of process stack
         * epc, ra, sp, gp, tp, t0 ~ t2, s0 ~ s1, a0 ~ a7, s2 ~ s11, t3 ~ t6,
         * status, badaddr, cause
         */
	unsigned int usertask_stack [256];
        unsigned int *usertask_stack_start = usertask_stack + 256 - 35;
        usertask_stack_start [0] = (unsigned int) &usertask; // epc
        usertask_stack_start [2] = (unsigned int) usertask_stack_start; // sp
        usertask_stack_start [33] = 0; // sstatus: SPP = 0, SPIE = 0

	print_str("OS: Starting...\n");
	print_str("OS: Calling the usertask (1st time)\n");
	usertask_stack_start = activate(usertask_stack_start);
	print_str("OS: Return to the OS mode !\n");
	print_str("OS: Calling the usertask (2nd time)\n");
	usertask_stack_start = activate(usertask_stack_start);
	print_str("OS: Return to the OS mode !\n");
	print_str("OS: Going to infinite loop...\n");

	while (1); /* We can't exit, there is nowhere to go */

	return;
}
