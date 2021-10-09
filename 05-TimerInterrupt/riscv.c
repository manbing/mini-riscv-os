#include "reg.h"

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

void systick_init(void)
{
        uint32_t hart_id, value = 0;
        uint64_t time = 10000000; // 1 second

        hart_id = r_mhartid();
        *(VIRT_CLINT_MTIMECMP(hart_id)) = *VIRT_CLINT_MTIME + time;

        value = r_mstatus();
        value |= (1 << MSTATUS_MIE_BIT);
        w_mstatus(value);
        
        value = r_mie();
        value |= (1 << MIE_MTIE_BIT);
        w_mie(value);
}
