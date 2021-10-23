#ifndef __CONTEXT_H_
#define __CONTEXT_H_

#define MCAUSE_INT_MASK  		0x80000000        // [31]=1 interrupt, else exception
#define MCAUSE_EXCEP_CODE_MASK		0x7FFFFFFF        // low bits show code

#define STACK_OFFSET_EPC	(0)
#define STACK_OFFSET_RA		(4)
#define STACK_OFFSET_SP		(8)
#define STACK_OFFSET_GP		(12)
#define STACK_OFFSET_TP		(16)
#define STACK_OFFSET_T0		(20)
#define STACK_OFFSET_T1		(24)
#define STACK_OFFSET_T2		(28)
#define STACK_OFFSET_S0		(32)
#define STACK_OFFSET_S1		(36)
#define STACK_OFFSET_A0		(40)
#define STACK_OFFSET_A1		(44)
#define STACK_OFFSET_A2		(48)
#define STACK_OFFSET_A3		(52)
#define STACK_OFFSET_A4		(56)
#define STACK_OFFSET_A5		(60)
#define STACK_OFFSET_A6		(64)
#define STACK_OFFSET_A7		(68)
#define STACK_OFFSET_S2		(72)
#define STACK_OFFSET_S3		(76)
#define STACK_OFFSET_S4		(80)
#define STACK_OFFSET_S5		(84)
#define STACK_OFFSET_S6		(88)
#define STACK_OFFSET_S7		(92)
#define STACK_OFFSET_S8		(96)
#define STACK_OFFSET_S9		(100)
#define STACK_OFFSET_S10	(104)
#define STACK_OFFSET_S11	(108)
#define STACK_OFFSET_T3		(112)
#define STACK_OFFSET_T4		(116)
#define STACK_OFFSET_T5		(120)
#define STACK_OFFSET_T6		(124)
#define STACK_OFFSET_STATUS	(128)
#define STACK_OFFSET_BADADDR	(132)
#define STACK_OFFSET_CAUSE	(136)

#endif /* !__CONTEXT_H_ */
