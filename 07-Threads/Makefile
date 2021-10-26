CROSS_COMPILE ?= riscv32-unknown-elf-
CC := $(CROSS_COMPILE)gcc
CFLAGS = -fno-common -ffreestanding -O0 \
	 -gdwarf-2 -g3 -Wall -Werror \
	 -march=rv32i -mabi=ilp32 \
	 -Wl,-Tos.ld -nostartfiles \

TARGET = os.bin
all: $(TARGET)

$(TARGET): os.c startup.S malloc.c threads.c riscv.c
	$(CC) $(CFLAGS) $^ -o os.elf
	$(CROSS_COMPILE)objcopy -Obinary os.elf os.bin
	$(CROSS_COMPILE)objdump -S os.elf > os.list

qemu: $(TARGET)
	@qemu-system-riscv32 -M ? | grep virt >/dev/null || exit
	@echo "Press Ctrl-A and then X to exit QEMU"
	@echo
	qemu-system-riscv32 -machine virt -m 128M -bios none -kernel os.bin -nographic

clean:
	rm -f *.o *.bin *.elf *.list
