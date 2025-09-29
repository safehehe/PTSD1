DESIGN = raiz_16
BUILD_DIR = build
SIM_DIR = simulation
SIMPLE_SIM_DIR = $(SIM_DIR)/simple
POST_SYNTH_SIM_DIR = $(SIM_DIR)/post_synth
POST_ROUTE_SIM_DIR = $(SIM_DIR)/post_route
TESTBENCH_DIR = test_benches
DIAGRAMS_DIR = diagrams
ECP5_SIM_CELLS=$(shell yosys-config --datdir/ecp5/cells_sim.v)



TOP = raiz_16
TARGET = raiz_16
OBJS = $(wildcard *.v)
SIM_OBJS = ../../verilog_model/sky130_fd_sc_hd.v
SIM_OBJS += ../../verilog_model/primitives.v


.PHONY : all simple_sim re_simple_sim sim_post_synth re_sim_post_synth clean

all : simple_sim

simple_sim : $(SIMPLE_SIM_DIR) #Crea la carpeta, los archivos de simulación y lanza GTKwave
	rm -f $(SIMPLE_SIM_DIR)/*.vcd
	iverilog -o $(SIMPLE_SIM_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TESTBENCH_DIR)/$(TARGET)_TB.v $(OBJS)
	vvp $(SIMPLE_SIM_DIR)/$(TARGET)_TB.vvp
	mv $(TARGET)_TB.vcd $(SIMPLE_SIM_DIR)/
	gtkwave $(SIMPLE_SIM_DIR)/$(TARGET)_TB.vcd &
re_simple_sim : $(SIMPLE_SIM_DIR) #Crea la carpeta y los archivos de simulación
	rm -f $(SIMPLE_SIM_DIR)/*.vcd
	iverilog -o $(SIMPLE_SIM_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TESTBENCH_DIR)/$(TARGET)_TB.v $(OBJS)
	vvp $(SIMPLE_SIM_DIR)/$(TARGET)_TB.vvp
	mv $(TARGET)_TB.vcd $(SIMPLE_SIM_DIR)/

build/$(TOP).json : $(BUILD_DIR)
	yosys -v3 -l $(BUILD_DIR)/synth.log -p "synth_ecp5 -top $(TOP) -json $(BUILD_DIR)/$(TOP).json ; write_verilog -attr2comment $(BUILD_DIR)/$(TOP)_synth.v" $(OBJS)
	#yosys -p "read_verilog $(BUILD_DIR)/$(TOP)_synth.v; read_verilog -lib $(ECP5_SIM_CELLS); prep -top $(TOP); opt; show -format pdf -prefix $(DIAGRAMS_DIR)/circuit"

sim_post_synth : clean build/$(TOP).json $(OBJS) $(POST_SYNTH_SIM_DIR)
	iverilog -o $(POST_SYNTH_SIM_DIR)/$@_PS.vvp -s $(TOP)_TB $(TESTBENCH_DIR)/$(TARGET)_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
	vvp $(POST_SYNTH_SIM_DIR)/$@_PS.vvp
	mv $(TOP)_TB.vcd $(POST_SYNTH_SIM_DIR)/
	gtkwave $(POST_SYNTH_SIM_DIR)/$(TOP)_TB.vcd &

re_sim_post_synth : build/$(TOP).json $(OBJS) $(POST_SYNTH_SIM_DIR)
	iverilog -o $(POST_SYNTH_SIM_DIR)/$@_PS.vvp -s $(TOP)_TB $(TESTBENCH_DIR)/$(TARGET)_TB.v $(BUILD_DIR)/$(TOP)_synth.v $(ECP5_SIM_CELLS)
	vvp $(POST_SYNTH_SIM_DIR)/$@_PS.vvp
	mv $(TOP)_TB.vcd $(POST_SYNTH_SIM_DIR)/


$(SIMPLE_SIM_DIR) :
	mkdir -p $(SIMPLE_SIM_DIR)
$(POST_SYNTH_SIM_DIR) :
	mkdir -p $(POST_SYNTH_SIM_DIR)
$(BUILD_DIR) :
	mkdir -p $(BUILD_DIR)
clean :
	rm -rf $(SIM_DIR)
	rm -rf $(BUILD_DIR)
	rm -rf $(DIAGRAMS_DIR)/circuit.*
