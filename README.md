# RV32I
An RV32I core implementation

# Directories

* `rtl` - HDL sources and RTL level code required to implement the design
* `sdk` - Accompanying software/firmware
* `sim` - Simulation sources used to validate the HDL sources
* `board` - Board supporting configuration files, including constraints and build parameters

# Usage

The toolchain can be installed and activated using [`icicle`](https://github.com/nishtahir/icicle).

```
$ icicle install
$ icicle use
```

The project is built using make. The root `Makefile` has a handy help target which documents commands available

```
$ make help
all                            Run sys, pnr and bitstream generation for the given BOARD
clean                          Deletes and recreates the build folder
help                           Print this help message
program                        Program the given BOARD
```

You can configure the target board by updating the BOARD variable in the `Makefile` 

```
- BOARD ?= icesugar
+ BOARD ?= alchitry_cu
```

or by providing it as a variable when running a target.

```
$ make all BOARD=alchitry_cu 
```

You can add and remove your own board configurations in the `board` folder by adding 

```
make 
```

# Supported Instructions

- [ ] lui 
- [ ] auipc 
- [x] addi 
- [x] slti 
- [x] sltiu 
- [x] xori 
- [x] ori 
- [x] andi 
- [x] slli 
- [ ] srli 
- [ ] srai 
- [x] add 
- [x] sub 
- [x] sll 
- [ ] slt 
- [ ] sltu 
- [x] xor 
- [ ] srl 
- [ ] sra 
- [x] or 
- [ ] and 
- [ ] fence 
- [ ] csrrw 
- [ ] csrrs 
- [ ] csrrc 
- [ ] csrrwi 
- [ ] csrrsi 
- [ ] csrrci 
- [ ] ecall 
- [ ] ebreak 
- [ ] uret 
- [ ] sret 
- [ ] mret 
- [ ] wfi 
- [ ] lb 
- [ ] lh 
- [x] lw 
- [ ] lbu 
- [ ] lhu 
- [ ] sb 
- [ ] sh 
- [x] sw 
- [ ] jal 
- [ ] jalr 
- [ ] beq 
- [ ] bne 
- [ ] blt 
- [ ] bge 
- [ ] bltu 
- [ ] bgeu 

# License
```
Copyright 2022 Nish Tahir

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```