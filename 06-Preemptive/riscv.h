#ifndef _RISCV_H
#define _RISCV_H

void print_str(const char *str);
unsigned int *create_task(unsigned int *stack, void (*start)(void));
void systick_init(void);

#endif /* !_RISCV_H */
