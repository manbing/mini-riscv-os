#include <stdint.h>
#include "reg.h"
#include "asm.h"

static inline uint32_t r_mhartid(void)
{
        uint32_t value = 0;

        asm volatile("csrr %0, mhartid" : "=r"(value));
        return value;
}

static inline uint32_t r_mstatus(void)
{
        uint32_t value = 0;

        asm volatile("csrr %0, mstatus" : "=r"(value));
        return value;
}

static inline void w_mstatus(uint32_t value)
{
        asm volatile("csrw mstatus, %0" : : "r" (value));
}

static inline uint32_t r_mie(void)
{
        uint32_t value = 0;

        asm volatile("csrr %0, mie" : "=r"(value));
        return value;
}

static inline void w_mie(uint32_t value)
{
        asm volatile("csrw mie, %0" : : "r" (value));
}

void print_str(const char *str)
{
        while (*str) {
                *(VIRT_UART0_THR) = *str & 0xFF;
                str++;
        }
}
