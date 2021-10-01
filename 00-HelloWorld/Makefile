CROSS_COMPILE ?= riscv32-unknown-elf-
CC := $(CROSS_COMPILE)gcc
CFLAGS = -fno-common -ffreestanding -O0 \
         -gdwarf-2 -g3 -Wall -Werror \
	 -march=rv32i -mabi=ilp32 \
	 -Wl,-Thello.ld -nostartfiles \

TARGET = hello.bin
all: $(TARGET)

$(TARGET): hello.c startup.S
	$(CC) $(CFLAGS) $^ -o hello.elf
	$(CROSS_COMPILE)objcopy -Obinary hello.elf hello.bin
	$(CROSS_COMPILE)objdump -S hello.elf > hello.list

qemu: $(TARGET)
	@qemu-system-riscv32 -M ? | grep opentitan >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo
	qemu-system-riscv32 -machine virt -m 128M -bios none -kernel hello.bin -nographic

clean:
	rm -f *.o *.bin *.elf *.list
