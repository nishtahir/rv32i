BUILD = ../build
RTL = ../rtl

SIMULATOR_COMPILER ?= iverilog
SIMULATOR_COMPILER_FLAGS ?= -g2012 -DSIMULATION -Y .sv -y $(RTL)

SIMULATOR ?= vvp
SIMULATOR_FLAGS ?= -v -N

SOURCES = $(wildcard $(RTL)/*.sv)
SIM_SOURCES = $(wildcard *.sv)
VVPS = $(patsubst %.sv, %.vvp, $(SIM_SOURCES))
VCDS = $(patsubst %.sv, %.vcd, $(SIM_SOURCES))

default: all

.PHONY:all
all: $(VVPS)

$(VVPS): %.vvp: %.sv $(SOURCES)
	$(SIMULATOR_COMPILER) $(SIMULATOR_COMPILER_FLAGS) -o $(BUILD)/$@ $^ 
	$(SIMULATOR) $(SIMULATOR_FLAGS) $(BUILD)/$@