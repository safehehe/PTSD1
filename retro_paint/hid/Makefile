SRC = \
    tb_teclado_rx.sv \
    top_teclado_rx.v \
    uart_rx.v \
    command_decoder.v \
    line_buffer.v

sim:
	iverilog -g2012 -o sim.out $(SRC)

run:
	vvp sim.out

view:
	gtkwave dump.vcd &
