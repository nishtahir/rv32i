CSRCS := $(wildcard *.c)
COBJS := $(CSRCS:%.c=%.c.o)

SSRCS := $(wildcard *.s)
SOBJS := $(SSRCS:%.s=%.s.o)

LDSRC := main.ld

default: all


LINK_DEPENDENCIES = $(COBJS) $(SOBJS)

all : $(LINK_DEPENDENCIES)
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -nostartfiles -T $(LDSRC) $^ -o $@.elf

%.c.o: %.c
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -nostartfiles -I ./ -c $< -o $@ -std=c99


%.s.o: %.s
	riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 $< -o $@

clean:
	rm -f $(COBJS) $(SOBJS) $(TARGET).elf $(TARGET).{bin,mif,v,coe,asmdump}