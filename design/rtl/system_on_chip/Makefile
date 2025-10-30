BUILD_DIR = build
SIM_DIR = simulation
SIM_QUARK_DIR = $(SIM_DIR)/quark
POST_SYNTH_QUARK_SIM_DIR = $(SIM_DIR)/post_synth_quark
TESTBENCH_DIR = test_benches
ECP5_SIM_CELLS=$(shell yosys-config --datdir/ecp5/cells_sim.v)
BIT_DIR = bitstream

TARGET = SOC
TOP = SOC
BIT_NAME=calculator_SOC

CPU = cpu/femtorv32_quark.v
BRAM = bram/bram.v
COMM_PERIP = ../peripheral_implementation
COMM_RAW = ../raw_implementation


OBJS = SOC.v $(CPU) $(BRAM) $(wildcard $(COMM_RAW)/*/*.v)
OBJS += $(wildcard $(COMM_PERIP)/*/*.v)
#OBJS += $(wildcard $(COMM_RAW)/*/*.v)

.PHONY : all sim_quark re_sim_quark sim_post_synth_quark re_sim_post_synth_quark clean
.PHONY : configure_lattice detect

all : sim_quark

sim_quark : $(SIM_QUARK_DIR)
	iverilog -o $(SIM_QUARK_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL $(TESTBENCH_DIR)/quark_TB.v $(OBJS)
	vvp $(SIM_QUARK_DIR)/$(TARGET)_TB.vvp
	mv quark_TB.vcd $(SIM_QUARK_DIR)/
	gtkwave $(SIM_QUARK_DIR)/quark_TB.vcd $(SIM_QUARK_DIR)/test_cpu_load.gtkw &
	
re_sim_quark : $(SIM_QUARK_DIR)
	iverilog -o $(SIM_QUARK_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL $(TESTBENCH_DIR)/quark_TB.v $(OBJS)
	vvp $(SIM_QUARK_DIR)/$(TARGET)_TB.vvp
	mv quark_TB.vcd $(SIM_QUARK_DIR)/

#sim_post_synth_quark : build/$(TOP).json $(OBJS) $(POST_SYNTH_QUARK_SIM_DIR)
#	iverilog -DSYNTH -o $(POST_SYNTH_QUARK_SIM_DIR)/$(TARGET)_TB_PS.vvp -s quark_TB $(TESTBENCH_DIR)/quark_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
#	vvp $(POST_SYNTH_QUARK_SIM_DIR)/$(TARGET)_TB_PS.vvp
#	mv quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/
#	gtkwave $(POST_SYNTH_QUARK_SIM_DIR)/quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/test_cpu_load_post_synth.gtkw & 

#re_sim_post_synth_quark : build/$(TOP).json $(OBJS) $(POST_SYNTH_QUARK_SIM_DIR) 
#	iverilog -o $(POST_SYNTH_QUARK_SIM_DIR)/$(TARGET)_TB_PS.vvp -s quark_TB $(TESTBENCH_DIR)/quark_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
#	vvp $(POST_SYNTH_QUARK_SIM_DIR)/$(TARGET)_TB_PS.vpp
#	mv quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/

#LATTICE COLORLIGHT 5A
$(BUILD_DIR)/$(TOP).json : $(BUILD_DIR)
	yosys -v3 -l $(BUILD_DIR)/synth.log -p 'attrmap -tocase keep -imap keep="true" keep=1; synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$(TOP).json' $(OBJS) -l $(BUILD_DIR)/$(TOP).rpt
$(BUILD_DIR)/$(TARGET)_out.config : build/$(TOP).json
	nextpnr-ecp5 --json build/$(TOP).json --lpf pin_assignment.lpf --textcfg build/$(TARGET)_out.config --25k --package CABGA256 --speed 6 --timing-allow-fail --seed 1 --lpf-allow-unconstrained --log $(BUILD_DIR)/$(TOP)_pnr.log
$(BIT_DIR)/$(BIT_NAME).bit : $(BIT_DIR) build/$(TARGET)_out.config
	ecppack --bootaddr 0 --compress $(BUILD_DIR)/$(TARGET)_out.config --svf $(BUILD_DIR)/$(TARGET).svf --bit $@

bit_gen : $(BIT_DIR)/$(BIT_NAME).bit

configure_lattice : $(BIT_DIR)/$(BIT_NAME).bit
	sudo openFPGALoader -c ft232RL --pins=0:3:4:1 -m $(BIT_DIR)/$(BIT_NAME).bit
#                                    UART=TXD:CTS:DTR:RXD
#                                    JTAG=TDI:TDO:TCK:TMS 
#                                     PDB=J32:J30:J27:J31     
#                                 FT232RL=0:3:4:1

detect :
	openFPGALoader -c ft232RL --pins=0:3:4:1 --verbose 30000000 --detect

$(SIM_QUARK_DIR) :
	mkdir -p $(SIM_QUARK_DIR)

$(POST_SYNTH_QUARK_SIM_DIR) :
	mkdir -p $(POST_SYNTH_QUARK_SIM_DIR)

$(BUILD_DIR) :
	mkdir -p $(BUILD_DIR)

$(BIT_DIR) : 
	mkdir -p $(BIT_DIR)
clean :
	find $(SIM_QUARK_DIR) -depth -mindepth 1 ! -name "*.gtkw" -delete
	find $(POST_SYNTH_QUARK_SIM_DIR) -depth -mindepth 1 ! -name "*.gtkw" -delete
	rm -rf $(BUILD_DIR)
	rm -rf $(BIT_DIR)