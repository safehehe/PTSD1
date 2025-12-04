// integra los tres módulos y expone las salidas paralelas (lo que se conectará a la lógica de pantalla)
module top_teclado_rx(
    input wire clk,
    input wire rx_bluetooth,

    output wire       cmd_valid,
    output wire [3:0] cmd_id,
    output wire [6:0] x,
    output wire [6:0] y
);

    wire [7:0] byte_rx;
    wire       byte_valid;

    uart_rx uart0(
        .clk(clk),
        .rx(rx_bluetooth),
        .data_out(byte_rx),
        .data_valid(byte_valid)
    );

    wire [127:0] line;
    wire         line_ready;

    line_buffer buf0(
        .clk(clk),
        .rx_char(byte_rx),
        .rx_valid(byte_valid),
        .line(line),
        .line_ready(line_ready)
    );

    command_decoder dec0(
        .clk(clk),
        .line(line),
        .line_ready(line_ready),
        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x(x),
        .y(y)
    );

endmodule

