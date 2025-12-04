# compila y simula con Icarus y abre GTKWave.
SRC = \
    tb_teclado_rx.sv \
    top_teclado_rx.v \
    uart_rx.v \
    line_buffer.v \
    command_decoder.v

sim:
	iverilog -g2012 -o sim.out $(SRC)

run:
	vvp sim.out

view:
	gtkwave dump.vcd &

clean:
	rm -f sim.out dump.vcd
