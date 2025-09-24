DESIGN = BCD
BUILD_DIR = build
SIM_DIR = simulation
TESTBENCH_DIR = test_benches

TOP = BCD
TARGET = BCD
OBJS = $(wildcard *.v)

.PHONY : all sim clean

all : sim

sim : $(SIM_DIR) #Crea la carpeta, los archivos de simulación y lanza GTKwave
	rm -f $(SIM_DIR)/*.vcd
	iverilog -o $(SIM_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TESTBENCH_DIR)/$(TARGET)_TB.v $(OBJS)
	vvp $(SIM_DIR)/$(TARGET)_TB.vvp
	mv $(TARGET)_TB.vcd $(SIM_DIR)/
	gtkwave $(SIM_DIR)/$(TARGET)_TB.vcd &
resim : $(SIM_DIR) #Crea la carpeta y los archivos de simulación
	rm -f $(SIM_DIR)/*.vcd
	iverilog -o $(SIM_DIR)/$(TARGET)_TB.vvp -DBENCH -DSIM -DPASSTHROUGH_PLL -DBOARD_FREQ=27 -DCPU_FREQ=27 $(TESTBENCH_DIR)/$(TARGET)_TB.v $(OBJS)
	vvp $(SIM_DIR)/$(TARGET)_TB.vvp
	mv $(TARGET)_TB.vcd $(SIM_DIR)/
$(SIM_DIR) : 
	mkdir -p $(SIM_DIR)

clean :
	rm -rf $(SIM_DIR)