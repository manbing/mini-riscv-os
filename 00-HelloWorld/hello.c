#include <stdint.h>
#include "reg.h"

void puts(char *input)
{
        while (*input) {
                *(VIRT_UART0_THR) = *input & 0xFF;
                input++;
        }
}

void main(void)
{
        puts("Hello World!\n");

        while(1);
}
