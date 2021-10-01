#include <stdint.h>
#include "reg.h"
#include "asm.h"

void print_str(const char *str)
{
        while (*str) {
                *(VIRT_UART0_THR) = *str & 0xFF;
                str++;
        }
}

void usertask(void)
{
        print_str("User Task #1\n");
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
        usertask_stack_start [33] = 0; // status: SPP = 0, SPIE = 0

	print_str("OS Starting...\n");
	activate(usertask_stack_start);

	while (1); /* We can't exit, there is nowhere to go */

	return;
}
