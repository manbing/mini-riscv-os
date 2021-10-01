#ifndef __REG_H_
#define __REG_H_

#define __REG_TYPE      volatile uint32_t
#define __REG           __REG_TYPE *

/* USART0 Memory Map */
#define VIRT_UART0			((__REG_TYPE) 0x10000000)
#define VIRT_UART0_THR			((__REG) (VIRT_UART0 + 0x00))

#endif
