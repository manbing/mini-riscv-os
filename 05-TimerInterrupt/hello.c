#include <stdint.h>
#include "riscv.h"

void main(void)
{
	print_str("Hello world!\n");

	while (1); /* wait */
}

void systick_handler(void)
{
	print_str("Interrupt from System Timer\n");
}
