// Top integrado: UART -> line_buffer -> command_decoder -> draw_engine
module top_teclado_rx (
    input  wire        clk,
    input  wire        reset,
    input  wire        rx_bluetooth,

    // Salidas observables / conexión con la lógica de pantalla
    output wire        mode,
    output wire [6:0]  cursor_x,
    output wire [6:0]  cursor_y,
    output wire [3:0]  p_px,
    output wire [3:0]  p_py,
    output wire        write_strobe,
    output wire [6:0]  write_x,
    output wire [6:0]  write_y,
    output wire [7:0]  write_color
);

    // Señales internas
    wire        rx_valid;
    wire [7:0]  rx_byte;

    wire [127:0] line;
    wire         line_ready;

    wire        cmd_valid;
    wire [3:0]  cmd_id;
    wire [6:0]  x_coord;
    wire [6:0]  y_coord;

    // UART receiver (con puertos rx_valid, rx_byte)
    uart_rx #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(115200)
    ) uart0 (
        .clk(clk),
        .reset(reset),
        .rx(rx_bluetooth),

        .rx_valid(rx_valid),
        .rx_byte(rx_byte)
    );

    // buffer de línea (arma line[127:0] hasta LF)
    line_buffer buf0 (
        .clk(clk),
        .rx_char(rx_byte),
        .rx_valid(rx_valid),
        .line(line),
        .line_ready(line_ready)
    );

    // decodificador que produce cmd_valid / cmd_id / x / y
    command_decoder dec0 (
        .clk(clk),
        .line(line),
        .line_ready(line_ready),

        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x(x_coord),
        .y(y_coord)
    );

    // motor de dibujo que actúa según los comandos
    draw_engine eng0 (
        .clk(clk),
        .reset(reset),
        .cmd_valid(cmd_valid),
        .cmd_id(cmd_id),
        .x_in(x_coord),
        .y_in(y_coord),

        .mode(mode),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),

        .p_px(p_px),
        .p_py(p_py),

        .write_strobe(write_strobe),
        .write_x(write_x),
        .write_y(write_y),
        .write_color(write_color),

        .selected_color() // no usado por el top
    );

endmodule
