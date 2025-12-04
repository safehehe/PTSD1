// testbench que envía bytes por la línea rx con tiempos correctos para probar
`timescale 1ns/1ps

module tb_teclado_rx();

    reg clk = 0;
    always #10 clk = ~clk; // 50 MHz equivalente en este TB: periodo 20 ns

    reg rx = 1;

    // señales observables desde el DUT
    wire mode;
    wire [6:0] cursor_x;
    wire [6:0] cursor_y;
    wire [3:0] p_px;
    wire [3:0] p_py;
    wire write_strobe;
    wire [6:0] write_x;
    wire [6:0] write_y;
    wire [7:0] write_color;

    // instancia del DUT
    top_teclado_rx dut (
        .clk(clk),
        .reset(1'b0),
        .rx_bluetooth(rx),

        .mode(mode),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),
        .p_px(p_px),
        .p_py(p_py),
        .write_strobe(write_strobe),
        .write_x(write_x),
        .write_y(write_y),
        .write_color(write_color)
    );

    // tarea que emula el envío UART (LSB first)
    task uart_send_byte(input [7:0] b);
        integer i;
        begin
            // start bit
            rx = 0; #104167;
            // data bits (LSB first)
            for (i = 0; i < 8; i=i+1) begin
                rx = b[i];
                #104167;
            end
            // stop bit
            rx = 1; #104167;
        end
    endtask

    initial begin
        #1_000_000;

        // manda "UP,12,4\n"
        uart_send_byte("U");
        uart_send_byte("P");
        uart_send_byte(",");
        uart_send_byte("1");
        uart_send_byte("2");
        uart_send_byte(",");
        uart_send_byte("4");
        uart_send_byte(8'h0A); // LF

        #5_000_000;

        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_teclado_rx);
        $dumpvars(1, tb_teclado_rx.dut);
    end

endmodule
