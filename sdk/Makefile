CC=riscv64-unknown-elf-gcc
AS=riscv64-unknown-elf-as
LD=riscv64-unknown-elf-ld
OC=riscv64-unknown-elf-objcopy
OD=riscv64-unknown-elf-objdump
HD=hexdump
HD_FLAGS=-ve '1/4 "%08x\n"'

C_FLAGS= -Wall -pedantic -g -ffreestanding -O0 -Wl,--gc-sections -nostartfiles -nostdlib -nodefaultlibs -march=rv32i -mabi=ilp32

default: main.mem

main.mem: main.bin
	$(HD) $(HD_FLAGS) main.bin > main.mem

main.bin: main.o
	$(OC) -O binary main.o main.bin
	$(OD) -S -d main.o -M numeric

main.o : main.c boot.s main.ld
	$(CC) $(C_FLAGS) -Wl,-T,main.ld,-m,elf32lriscv boot.s main.c -o main.o

.PHONY: clean
clean:
	rm -f *.o *.section *.mem *.bin