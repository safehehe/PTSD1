module top_full (
    input  wire clk,
    input  wire reset,
    input  wire rx_bluetooth,

    // exposed outputs for display/control
    output wire mode,
    output wire [6:0] cursor_x,
    output wire [6:0] cursor_y,
    output wire [3:0] p_px,
    output wire [3:0] p_py,
    output wire write_strobe,
    output wire [6:0] write_x,
    output wire [6:0] write_y,
    output wire [7:0] write_color
);

    wire cmd_valid;
    wire [3:0] cmd_id;
    wire [6:0] x;
    wire [6:0] y;

    // This module is your existing top that contains uart_rx, buffer, decoder
    // It must output cmd_valid/cmd_id/x/y exactly as defined previously.
    top_teclado_rx decoder_top (
        .clk(clk),
        .rx_bluetooth(rx_bluetooth),

        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x(x),
        .y(y)
    );

    // Instantiate draw engine
    draw_engine engine (
        .clk(clk),
        .reset(reset),
        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x_in(x),
        .y_in(y),

        .mode(mode),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),
        .p_px(p_px),
        .p_py(p_py),
        .write_strobe(write_strobe),
        .write_x(write_x),
        .write_y(write_y),
        .write_color(write_color),
        .selected_color() // ignore or connect
    );

endmodule
