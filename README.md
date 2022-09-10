# open-ice40-template
A template repository to quickly create projects targetting open FPGA platforms

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