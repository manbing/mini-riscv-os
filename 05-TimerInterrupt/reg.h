#ifndef __REG_H_
#define __REG_H_
# include <stdint.h>

#define MIE_MTIE_BIT 7
#define MSTATUS_MIE_BIT 3

#define SIE_STIE_BIT 5
#define SSTATUS_SIE_BIT 1

#define __REG_TYPE      volatile uint32_t
#define __REG           __REG_TYPE *

/* Memory Map */
/** USART0 Memory Map **/
#define VIRT_UART0			((__REG_TYPE) 0x10000000)
#define VIRT_UART0_THR			((__REG) (VIRT_UART0 + 0x00))

/** Core Local Interrupter **/
#define VIRT_CLINT                      ((__REG_TYPE) 0x2000000)
#define VIRT_CLINT_MTIMECMP(hartid)	((__REG) (VIRT_CLINT + 0x4000 + 4 * (hartid)))
#define VIRT_CLINT_MTIME		((__REG) (VIRT_CLINT + 0xBFF8))

#endif
