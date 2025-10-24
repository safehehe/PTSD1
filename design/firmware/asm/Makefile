# *************************************************
# IMPORTANTE PARA PODER COMPILAR ESTE EJEMPLO:
# En el archivo:litex/litex/soc/software/common.mak
# cambiar de:
# ifeq ($(LTO), 1)
# COMMONFLAGS += -flto
# endif
# a:
# COMMONFLAGS += -flto
# *************************************************
BUILD_DIR = build
MEMORY_DIR = memory_image
CHIP_MEMORY_DIR = ../../rtl/system_on_chip/memory_image

MAIN = calculator.o# Cambiar por el main del proyecto
SOURCES = $(wildcard *.S)#Wildcard solo ve los archivos existentes
OBJECTS = $(patsubst %.S,$(BUILD_DIR)/%.o,$(SOURCES))#Indica los objetos que necesita a partir de los archivos existentes
LINKER_SCRIPT = $(BUILD_DIR)/bram.ld


TOOLCHAIN_DIR = ../../../toolchain#El toolchain debe estar en la raiz de el repositorio
CROSS   = $(TOOLCHAIN_DIR)/bin/riscv32-unknown-elf
CC      = $(CROSS)-gcc
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump
AFLAGS  = -march=rv32i -mabi=ilp32
LDFLAGS = 

.PHONY: clean

all: $(MEMORY_DIR)/firmware.hex

#-------------Compilación
$(BUILD_DIR)/%.o: %.S
	mkdir -p $(BUILD_DIR)
	$(AS) $(AFLAGS) -c $< -o $@

#-------------Link
$(BUILD_DIR)/firmware.elf : $(LINKER_SCRIPT) $(OBJECTS) 
	$(LD) $(LDFLAGS) -T $< -m elf32lriscv -nostdlib -Map $(BUILD_DIR)/firmware.map -N -o $@ $(OBJECTS)
	chmod -x $@

$(BUILD_DIR)/firmware.lst : $(BUILD_DIR)/firmware.elf
	$(OBJDUMP) -h -S $< > $@

$(BUILD_DIR)/firmware.bin : $(BUILD_DIR)/firmware.elf
	$(OBJCOPY) -O verilog $< $(BUILD_DIR)/firmware_flash.hex
	$(OBJCOPY) -O ihex $< $(BUILD_DIR)/firmware_flash_intel.hex
	$(OBJCOPY) -O binary $< $@
	chmod -x $@
#-------------Imagen de memoria
$(MEMORY_DIR)/firmware.hex: $(BUILD_DIR)/firmware.elf $(BUILD_DIR)/firmware.lst $(BUILD_DIR)/firmware.bin
	mkdir -p $(MEMORY_DIR)
	../firmware_words_src/firmware_words $< -ram 16384 -max_addr 16384  -out $@
	cp $@ $(CHIP_MEMORY_DIR)/
	cp $(BUILD_DIR)/firmware_flash.hex $(MEMORY_DIR)/
	cp $(MEMORY_DIR)/firmware_flash.hex $(CHIP_MEMORY_DIR)/

#-------------bram.ld
$(LINKER_SCRIPT):
	@mkdir -p $(BUILD_DIR)
	@echo "MEMORY {"                         >  $@
	@echo "   BRAM (RWX) : ORIGIN = 0x0000, LENGTH = 0x4000  /* 6kB RAM */" >> $@
	@echo "}"                                >> $@
	@echo "SECTIONS"                         >> $@
	@echo "{"                                >> $@
	@echo "    everything :"                 >> $@
	@echo "    {"                            >> $@
	@echo "        . = ALIGN(4);"            >> $@
	@echo "        *$(MAIN)(.text)"           >> $@
	@echo "        *(.*)"                    >> $@
	@echo "    } >BRAM"                      >> $@
	@echo "}"                                >> $@

clean:
	rm -rf $(BUILD_DIR) $(MEMORY_DIR)
	rm -f $(CHIP_MEMORY_DIR)/*


#export PATH=$PATH:/home/carlos/Embedded/litex_work/learn-fpga/FemtoRV/FIRMWARE/TOOLCHAIN/riscv64-unknown-elf-gcc-8.3.0-2020.04.0-x86_64-linux-ubuntu14/bin/
