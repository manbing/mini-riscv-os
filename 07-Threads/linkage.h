#ifndef _LINKAGE_H
#define _LINKAGE_H

#define ENTRY(name) \
    .globl name;    \
    .align 4;	    \
    name:

#define END(name) .size name, .- name

#define ENDPROC(name)		\
    .type name, % function;	\
    END(name)

#endif /* !_LINKAGE_H */
