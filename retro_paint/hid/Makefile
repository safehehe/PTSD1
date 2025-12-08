# Makefile actualizado para el sistema Binario

# Lista de archivos nuevos
SRC = \
    tb_sistema.sv \
    top_fpga.v \
    bt_decoder.v \
    uart_rx.v

# Nombre del archivo de salida de la simulación
OUT = sim.out

# Regla para compilar
sim:
	iverilog -g2012 -o $(OUT) $(SRC)

# Regla para ejecutar
run: sim
	vvp $(OUT)

# Regla para ver las ondas (asume que tu testbench genera simulacion.vcd)
view:
	gtkwave simulacion.vcd &

# Limpieza
clean:
	rm -f $(OUT) simulacion.vcd *.o