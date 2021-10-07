#include <stdint.h>
#include <stddef.h>
#include "reg.h"
#include "asm.h"

/* Size of our user task stacks in words */
#define STACK_SIZE 256

/* Number of user task */
#define TASK_LIMIT 2

void print_str(const char *str)
{
        while (*str) {
                *(VIRT_UART0_THR) = *str & 0xFF;
                str++;
        }
}

unsigned int *create_task(unsigned int *stack, void (*start)(void))
{
	stack += STACK_SIZE - 35; /* End of stack, minus what we are about to push */
	stack[0] = (unsigned int) start;
	stack[2] = (unsigned int) stack;
	stack[33] = (unsigned int) 0x00000000;
	stack = activate(stack);

	return stack;
}

void task1_func(void)
{
	print_str("task1: Created!\n");
	print_str("task1: Now, return to kernel mode\n");
	syscall();
	while (1) {
		print_str("task1: Executed!\n");
		print_str("task1: Now, return to kernel mode\n");
		syscall(); /* return to kernel mode */
	}
}

void task2_func(void)
{
	print_str("task2: Created!\n");
	print_str("task2: Now, return to kernel mode\n");
	syscall();
	while (1) {
		print_str("task2: Executed!\n");
		print_str("task2: Now, return to kernel mode\n");
		syscall(); /* return to kernel mode */
	}
}

int main(void)
{
	unsigned int user_stacks [TASK_LIMIT][STACK_SIZE];
	unsigned int *usertasks [TASK_LIMIT];
	size_t task_count = 0;
	size_t current_task;

	print_str("OS: Starting...\n");
	print_str("OS: First create task 1\n");
	usertasks[0] = create_task(user_stacks[0], &task1_func);
	task_count += 1;
	print_str("OS: Back to OS, create task 2\n");
	usertasks[1] = create_task(user_stacks[1], &task2_func);
	task_count += 1;

	print_str("\nOS: Start multitasking, back to OS till task yield!\n");
	current_task = 0;

	while (1) {
		print_str("OS: Activate next task\n");
		usertasks[current_task] = activate(usertasks[current_task]);
		print_str("OS: Back to OS\n");

		current_task = current_task == (task_count - 1) ? 0 : current_task + 1;
	}

	return 0;
}
