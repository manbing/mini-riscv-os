#include <stdint.h>
#include "threads.h"
#include "os.h"
#include "malloc.h"
#include "reg.h"

#define THREAD_PSP	0xFFFFFFFD

/* Thread Control Block */
typedef struct {
	void *stack;
	void *orig_stack;
	uint8_t in_use;
} tcb_t;

static tcb_t tasks[MAX_TASKS];
static int lastTask;

void __attribute__((naked)) do_mach_timer_intrrupt()
{
        /* To get the task pointer address from result mscratch */
        asm volatile("csrr  t0, mscratch\n");
        asm volatile("mv   %0, t0\n" : "=r" (tasks[lastTask].stack));

        /* SysTick configuration */
        asm volatile("jal systick_init\n");

	/* Find a new task to run */
	while (1) {
		lastTask++;
		if (lastTask == MAX_TASKS)
			lastTask = 0;
		if (tasks[lastTask].in_use) {
			/* Move the task's stack pointer address into t6 */
                        asm volatile("mv t6, %0\n" : : "r" (tasks[lastTask].stack));

                        /* Restore the new task's context and jump to the task */
                        asm volatile("lw t0, 128(t6)\n"
                                     "csrw mstatus, t0\n"
                                     "lw t0, 0(t6)\n"
                                     "csrw mepc, t0\n"
                                     "\n"
                                     "lw x1, 4(t6)\n"
                                     "lw x2, 8(t6)\n"
                                     "lw x3, 12(t6)\n"
                                     "lw x4, 16(t6)\n"
                                     "lw x5, 20(t6)\n"
                                     "lw x6, 24(t6)\n"
                                     "lw x7, 28(t6)\n"
                                     "lw x8, 32(t6)\n"
                                     "lw x9, 36(t6)\n"
                                     "lw x10, 40(t6)\n"
                                     "lw x11, 44(t6)\n"
                                     "lw x12, 48(t6)\n"
                                     "lw x13, 52(t6)\n"
                                     "lw x14, 56(t6)\n"
                                     "lw x15, 60(t6)\n"
                                     "lw x16, 64(t6)\n"
                                     "lw x17, 68(t6)\n"
                                     "lw x18, 72(t6)\n"
                                     "lw x19, 76(t6)\n"
                                     "lw x20, 80(t6)\n"
                                     "lw x21, 84(t6)\n"
                                     "lw x22, 88(t6)\n"
                                     "lw x23, 92(t6)\n"
                                     "lw x24, 96(t6)\n"
                                     "lw x25, 100(t6)\n"
                                     "lw x26, 104(t6)\n"
                                     "lw x27, 108(t6)\n"
                                     "lw x28, 112(t6)\n"
                                     "lw x29, 116(t6)\n"
                                     "lw x30, 120(t6)\n"
                                     "lw x31, 124(t6)\n"
                                     "mret\n");
		}
	}
}

void __attribute__((naked)) thread_start()
{
        lastTask = 0;

        /* Move the task's stack pointer address into t6 */
        asm volatile("mv t6, %0\n" : : "r" (tasks[lastTask].stack));

        /* Restore the new task's context and jump to the task */
        asm volatile("lw t0, 128(t6)\n"
                        "csrw sstatus, t0\n"
                        "lw t0, 0(t6)\n"
                        "csrw sepc, t0\n"
                        "\n"
                        "lw x1, 4(t6)\n"
                        "lw x2, 8(t6)\n"
                        "lw x3, 12(t6)\n"
                        "lw x4, 16(t6)\n"
                        "lw x5, 20(t6)\n"
                        "lw x6, 24(t6)\n"
                        "lw x7, 28(t6)\n"
                        "lw x8, 32(t6)\n"
                        "lw x9, 36(t6)\n"
                        "lw x10, 40(t6)\n"
                        "lw x11, 44(t6)\n"
                        "lw x12, 48(t6)\n"
                        "lw x13, 52(t6)\n"
                        "lw x14, 56(t6)\n"
                        "lw x15, 60(t6)\n"
                        "lw x16, 64(t6)\n"
                        "lw x17, 68(t6)\n"
                        "lw x18, 72(t6)\n"
                        "lw x19, 76(t6)\n"
                        "lw x20, 80(t6)\n"
                        "lw x21, 84(t6)\n"
                        "lw x22, 88(t6)\n"
                        "lw x23, 92(t6)\n"
                        "lw x24, 96(t6)\n"
                        "lw x25, 100(t6)\n"
                        "lw x26, 104(t6)\n"
                        "lw x27, 108(t6)\n"
                        "lw x28, 112(t6)\n"
                        "lw x29, 116(t6)\n"
                        "lw x30, 120(t6)\n"
                        "lw x31, 124(t6)\n"
                        "sret\n");

        /* Never reach here */
        while(1);
}

int thread_create(void (*run)(void *), void *userdata)
{
	/* Find a free thing */
	int threadId = 0;
	uint32_t *stack;

	for (threadId = 0; threadId < MAX_TASKS; threadId++) {
		if (tasks[threadId].in_use == 0)
			break;
	}

	if (threadId == MAX_TASKS)
		return -1;

	/* Create the stack */
	stack = (uint32_t *) malloc(STACK_SIZE * sizeof(uint32_t));
	tasks[threadId].orig_stack = stack;
	if (stack == 0)
		return -1;

	stack += STACK_SIZE - 35; /* End of stack, minus what we are about to push */
	stack[0] = (unsigned int) run;
	stack[1] = (unsigned int) &thread_self_terminal;
	stack[2] = (unsigned int) stack;
	stack[10] = (unsigned int) userdata;
	stack[33] = (unsigned int) 0x00000000;

	/* Construct the control block */
	tasks[threadId].stack = stack;
	tasks[threadId].in_use = 1;

	return threadId;
}

void thread_kill(int thread_id)
{
	tasks[thread_id].in_use = 0;

	/* Free the stack */
	free(tasks[thread_id].orig_stack);
}

void thread_self_terminal()
{
	/* This will kill the stack.
	 * For now, disable context switches to save ourselves.
	 */
	//asm volatile("cpsid i\n");
	thread_kill(lastTask);
	//asm volatile("cpsie i\n");

	/* And now wait for death to kick in */
	while (1);
}
