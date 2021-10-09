#ifndef __TRAP_H
#define __TRAP_H

#define MCAUSE_INT_MASK  0x80000000        // [31]=1 interrupt, else exception
#define MCAUSE_EXCEP_CODE_MASK 0x7FFFFFFF        // low bits show code

#define MACHINE_TIMER_INTERRUPT 7

#endif /* !__TRAP_H */
