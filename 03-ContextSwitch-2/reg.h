#ifndef __REG_H_
#define __REG_H_

#define __REG_TYPE      volatile uint32_t
#define __REG           __REG_TYPE *

/* USART0 Memory Map */
#define VIRT_UART0			((__REG_TYPE) 0x10000000)
#define VIRT_UART0_THR			((__REG) (VIRT_UART0 + 0x00)) //Transmitter Holding Register
#define VIRT_UART0_LSR			((__REG) (VIRT_UART0 + 0x05)) // Line Status Register
#define VIRT_UART0_LSR_EMPTY_MASK	0x40 // LSR Bit 6: Transmitter empty; both the THR and LSR are empty

#define SSTATUS_SPP_BIT			8
#define SSTATUS_SPIE_BIT		5

#define reg_read_csr(reg, value)	\
	__asm__ volatile("csrr %0, " #reg : "=r"(value));

#define reg_set_csr(reg, value)	\
	__asm__ volatile("csrw " #reg ", %0" : : "r"(value));

#define reg_update_value(value, bit, bit_value)	\
        ((value & ~(1 << bit)) | (bit_value << bit))

struct register_file;

#define STACK_OFFSET_EPC	((size_t)&((struct register_file *)0)->epc)
#define STACK_OFFSET_RA		((size_t)&((struct register_file *)0)->ra)
#define STACK_OFFSET_SP		((size_t)&((struct register_file *)0)->sp)
#define STACK_OFFSET_GP		((size_t)&((struct register_file *)0)->gp)
#define STACK_OFFSET_TP		((size_t)&((struct register_file *)0)->tp)
#define STACK_OFFSET_T0		((size_t)&((struct register_file *)0)->t0)
#define STACK_OFFSET_T1		((size_t)&((struct register_file *)0)->t1)
#define STACK_OFFSET_T2		((size_t)&((struct register_file *)0)->t2)
#define STACK_OFFSET_S0		((size_t)&((struct register_file *)0)->s0)
#define STACK_OFFSET_S1		((size_t)&((struct register_file *)0)->s1)
#define STACK_OFFSET_A0		((size_t)&((struct register_file *)0)->a0)
#define STACK_OFFSET_A1		((size_t)&((struct register_file *)0)->a1)
#define STACK_OFFSET_A2		((size_t)&((struct register_file *)0)->a2)
#define STACK_OFFSET_A3		((size_t)&((struct register_file *)0)->a3)
#define STACK_OFFSET_A4		((size_t)&((struct register_file *)0)->a4)
#define STACK_OFFSET_A5		((size_t)&((struct register_file *)0)->a5)
#define STACK_OFFSET_A6		((size_t)&((struct register_file *)0)->a6)
#define STACK_OFFSET_A7		((size_t)&((struct register_file *)0)->a7)
#define STACK_OFFSET_S2		((size_t)&((struct register_file *)0)->s2)
#define STACK_OFFSET_S3		((size_t)&((struct register_file *)0)->s3)
#define STACK_OFFSET_S4		((size_t)&((struct register_file *)0)->s4)
#define STACK_OFFSET_S5		((size_t)&((struct register_file *)0)->s5)
#define STACK_OFFSET_S6		((size_t)&((struct register_file *)0)->s6)
#define STACK_OFFSET_S7		((size_t)&((struct register_file *)0)->s7)
#define STACK_OFFSET_S8		((size_t)&((struct register_file *)0)->s8)
#define STACK_OFFSET_S9		((size_t)&((struct register_file *)0)->s9)
#define STACK_OFFSET_S10	((size_t)&((struct register_file *)0)->s10)
#define STACK_OFFSET_S11	((size_t)&((struct register_file *)0)->s11)
#define STACK_OFFSET_T3		((size_t)&((struct register_file *)0)->t3)
#define STACK_OFFSET_T4		((size_t)&((struct register_file *)0)->t4)
#define STACK_OFFSET_T5		((size_t)&((struct register_file *)0)->t5)
#define STACK_OFFSET_T6		((size_t)&((struct register_file *)0)->t6)
#define STACK_OFFSET_STATUS	((size_t)&((struct register_file *)0)->status)
#define STACK_OFFSET_BADADDR	((size_t)&((struct register_file *)0)->badaddr)
#define STACK_OFFSET_CAUSE	((size_t)&((struct register_file *)0)->cause)

enum privilege_mode {
        p_user_mode = 0,
        p_supervisor_mode = 1,
        p_machine_mode = 3,
};

struct register_file {
        uint32_t epc;
        
        uint32_t ra;
        uint32_t sp;
        uint32_t gp;
        uint32_t tp;

        uint32_t t0;
        uint32_t t1;
        uint32_t t2;

        uint32_t s0;
        uint32_t s1;

        uint32_t a0;
        uint32_t a1;
        uint32_t a2;
        uint32_t a3;
        uint32_t a4;
        uint32_t a5;
        uint32_t a6;
        uint32_t a7;

        uint32_t s2;
        uint32_t s3;
        uint32_t s4;
        uint32_t s5;
        uint32_t s6;
        uint32_t s7;
        uint32_t s8;
        uint32_t s9;
        uint32_t s10;
        uint32_t s11;

        uint32_t t3;
        uint32_t t4;
        uint32_t t5;
        uint32_t t6;

        uint32_t status;
        uint32_t badaddr;
        uint32_t cause;
};

#endif /* !__REG_H_ */
