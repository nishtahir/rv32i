riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -c ./start.s
riscv64-unknown-elf-objcopy --dump-section .text=start.bin start.o
hexdump -ve '1/4 "%08x\n"' start.bin > rom.mem
