module HID (
    input wire clk,       // 50MHz
    input wire rx_pin,    // Pin conectado al TX del módulo BT
    input wire reset_btn, // Botón de reset

    // CABLES HACIA EL MÓDULO DE TU COMPAÑERO
    output wire [2:0] cmd_to_screen,
    output wire [5:0] x_to_screen,
    output wire [5:0] y_to_screen,
    output wire       valid_pulse
);

  wire rx_valid_signal;
  wire [7:0] rx_byte_signal;

  // Invertir reset si el botón es activo bajo
  wire rst = ~reset_btn;

  // 1. Instancia UART RX
  uart_rx #(
      .CLK_FREQ(50000000),
      .BAUD_RATE(9600)     // Igual al ESP32
  ) uart_inst (
      .clk(clk),
      .reset(rst),
      .rx(rx_pin),
      .rx_valid(rx_valid_signal),
      .rx_byte(rx_byte_signal)
  );

  // 2. Instancia Decodificador
  bt_decoder decoder_inst (
      .clk(clk),
      .reset(rst),
      .rx_valid(rx_valid_signal),
      .rx_byte(rx_byte_signal),

      .command_id(cmd_to_screen),
      .x_out(x_to_screen),
      .y_out(y_to_screen),
      .data_ready(valid_pulse)
  );

endmodule
