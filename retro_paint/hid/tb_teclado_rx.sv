`timescale 1ns/1ps

module tb_teclado_rx();

    reg clk = 0;
    always #10 clk = ~clk;

    reg rx = 1;

    wire cmd_valid;
    wire [3:0] cmd_id;
    wire [6:0] x, y;

    top_teclado_rx dut(
        .clk(clk),
        .rx_bluetooth(rx),
        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x(x),
        .y(y)
    );

    task uart_send_byte(input [7:0] b);
        integer i;
        begin
            rx = 0; #104167;
            for (i = 0; i < 8; i=i+1) begin
                rx = b[i];
                #104167;
            end
            rx = 1; #104167;
        end
    endtask

    initial begin
        #1_000_000;

        uart_send_byte("U");
        uart_send_byte("P");
        uart_send_byte(",");
        uart_send_byte("1");
        uart_send_byte("2");
        uart_send_byte(",");
        uart_send_byte("4");
        uart_send_byte(8'h0A);
        uart_send_byte(8'h0D);   // CR (\r)
        art_send_byte(8'h0A);   // LF (\n)


        #5_000_000;

        $finish;
    end
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_teclado_rx);       // señales del testbench
    $dumpvars(1, tb_teclado_rx.dut);   // señales internas del DUT
end

endmodule
