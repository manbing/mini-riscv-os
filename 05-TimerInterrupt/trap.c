#include <stdint.h>

#include "riscv.h"
#include "trap.h"
#include "hello.h"

void async_handler(uint32_t cause)
{
        uint32_t code = cause & MCAUSE_EXCEP_CODE_MASK;

        switch (code)
        {
                case MACHINE_TIMER_INTERRUPT:
                        {
                                systick_handler();
                                systick_init();
                        }
                        break;

                default:
                        break;
        }
}

void sync_handletr(uint32_t cause)
{
}
