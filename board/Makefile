BUILD = ../build
RTL = ../rtl

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

# Replace with your top module
TOP = Top

ifdef BOARD
	include $(BOARD)/Config.mk
endif

default: all

.PHONY:all
all: $(PCF) $(NET) $(ASC) $(BIN)

.PHONY: clean
clean:
	rm -rf $(BUILD)/ && mkdir $(BUILD)/

.PHONY: program
program: $(BIN)
	$(PROGRAM) $(PROGRAM_FLAGS) $(BIN)

$(PCF): 
	cat $(BOARD)/*.pcf > $(BUILD)/constraints.pcf

$(NET): $(SV)
	$(YOSYS) $(YOSYS_FLAGS) -p 'synth_ice40 -top $(TOP) -json $(NET)' $(RTL)/*.sv

$(ASC): $(NET) $(PCF)
	$(PNR) $(PNR_FLAGS) --json $(NET)  --pcf $(PCF)  --asc $(ASC)

$(BIN): $(ASC)
	icepack $(ASC) $(BIN)