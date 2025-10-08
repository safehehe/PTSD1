BUILD_DIR = build
SIM_DIR = simulation
SIM_QUARK_DIR = $(SIM_DIR)/quark
POST_SYNTH_QUARK_SIM_DIR = $(SIM_DIR)/post_synth_quark
TESTBENCH_DIR = test_benches
ECP5_SIM_CELLS=$(shell yosys-config --datdir/ecp5/cells_sim.v)

TARGET = SOC
TOP = SOC

CPU = cpu/femtorv32_quark.v
BRAM = bram/bram.v
COMM_PERIP = ../peripheral_implementation
COMM_RAW = ../raw_implementation


OBJS = SOC.v $(CPU) $(BRAM) $(wildcard $(COMM_RAW)/*/*.v)
OBJS += $(wildcard $(COMM_PERIP)/*/*.v)
OBJS += $(wildcard $(COMM_RAW)/*/*.v)

.PHONY : all sim_quark clean

all : sim_quark

sim_quark : $(SIM_QUARK_DIR)
	iverilog -o $(SIM_QUARK_DIR)/$@_PS.vvp -DBENCH $(TESTBENCH_DIR)/quark_TB.v $(OBJS)
	vvp $(SIM_QUARK_DIR)/$@_PS.vvp
	mv quark_TB.vcd $(SIM_QUARK_DIR)/
	gtkwave $(SIM_QUARK_DIR)/bench.vcd $(SIM_DIR)/test_cpu_load.gtkw &
	
sim_post_synth_quark : $(OBJS) $(POST_SYNTH_QUARK_SIM_DIR)
	iverilog -o $(POST_SYNTH_SIM_DIR)/$@_PS.vvp -s $quark_TB $(TESTBENCH_DIR)/quark_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
	vvp $(POST_SYNTH_QUARK_SIM_DIR)/$@_PS.vpp
	mv quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/
	gtkwave $(POST_SYNTH_QUARK_SIM_DIR)/quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/signals.gtkw & 

re_sim_post_synth_quark : 
	iverilog -o $(POST_SYNTH_SIM_DIR)/$@_PS.vvp -s $quark_TB $(TESTBENCH_DIR)/quark_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
	vvp $(POST_SYNTH_QUARK_SIM_DIR)/$@_PS.vpp
	mv quark_TB.vcd $(POST_SYNTH_QUARK_SIM_DIR)/

$(SIM_QUARK_DIR) :
	mkdir -p $(SIM_QUARK_DIR)

$(POST_SYNTH_QUARK_SIM_DIR) :
	mkdir -p $(POST_SYNTH_QUARK_SIM_DIR)
