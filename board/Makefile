ROOT = ..
BUILD = $(ROOT)/build
RTL = $(ROOT)/rtl

YOSYS ?= yosys
YOSYS_FLAGS ?= -q

PNR ?= nextpnr-ice40
PNR_FLAGS ?= ""
PROGRAM ?= iceprog
PROGRAM_FLAGS ?= ""

PCF = $(BUILD)/constraints.pcf
NET = $(BUILD)/out.json
ASC = $(BUILD)/out.asc
BIN = $(BUILD)/out.bin
SV = $(RTL)/*.sv
MEM = $(ROOT)/mem/*.mem

# Replace with your top module
TOP = Top

ifdef BOARD
	include $(BOARD)/Config.mk
endif

default: all

.PHONY: all
all: $(PCF) $(NET) $(ASC) $(BIN)

.PHONY: clean
clean:
	rm -rf $(BUILD)/ && mkdir $(BUILD)/

.PHONY: program
program: $(BIN)
	$(PROGRAM) $(BIN)

.PHONY: schematics
schematics:
	../scripts/schematics.sh

$(PCF): 
	cat $(BOARD)/*.pcf > $(BUILD)/constraints.pcf

$(NET): $(SV) $(MEM)
	$(YOSYS) $(YOSYS_FLAGS) -p 'synth_ice40 -top $(TOP) -json $(NET)' $(RTL)/*.sv $(BOARD)/*.sv

$(ASC): $(NET) $(PCF)
	$(PNR) $(PNR_FLAGS) --json $(NET)  --pcf $(PCF)  --asc $(ASC)

$(BIN): $(ASC)
	icepack $(ASC) $(BIN)
