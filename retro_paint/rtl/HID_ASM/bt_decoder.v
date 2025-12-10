module bt_decoder (
    input wire clk,
    input wire reset,
    // Entrada desde UART_RX
    input wire rx_valid,
    input wire [7:0] rx_byte,

    // Salidas hacia el módulo de Pantalla
    output reg [2:0] command_id,  // 1=Move, 2=Draw, 3=PickColor
    output reg [5:0] x_out,       // 0-63
    output reg [5:0] y_out,       // 0-63
    output reg       data_ready   // Pulso de 1 ciclo cuando los datos son nuevos
);

  // Estados de recepción
  localparam S_WAIT_HEADER = 0;
  localparam S_WAIT_X = 1;
  localparam S_WAIT_Y = 2;

  reg [1:0] state;

  // Registros temporales
  reg [2:0] temp_cmd;
  reg [5:0] temp_x;

  always @(posedge clk) begin
    if (reset) begin
      state <= S_WAIT_HEADER;
      command_id <= 0;
      x_out <= 0;
      y_out <= 0;
      data_ready <= 0;
    end else begin
      data_ready <= 0;  // Pulso por defecto en 0

      if (rx_valid) begin
        case (state)
          S_WAIT_HEADER: begin
            // Buscamos byte que empiece con 11 (0xC0 mask)
            if (rx_byte[7:6] == 2'b11) begin
              temp_cmd <= rx_byte[2:0];  // Guardamos comando
              state <= S_WAIT_X;
            end
          end

          S_WAIT_X: begin
            // Seguridad: Si recibimos otro Header por error, reiniciamos
            if (rx_byte[7:6] == 2'b11) begin
              temp_cmd <= rx_byte[2:0];
              state <= S_WAIT_X;  // Nos quedamos esperando X del nuevo header
            end else begin
              temp_x <= rx_byte[5:0];  // Guardamos X (6 bits)
              state  <= S_WAIT_Y;
            end
          end

          S_WAIT_Y: begin
            if (rx_byte[7:6] == 2'b11) begin
              temp_cmd <= rx_byte[2:0];
              state <= S_WAIT_X;
            end else begin
              // Tenemos el paquete completo!
              command_id <= temp_cmd;
              x_out      <= temp_x;
              y_out      <= rx_byte[5:0];
              data_ready <= 1;  // Avisamos al siguiente módulo
              state      <= S_WAIT_HEADER;
            end
          end
          default : begin
            // Buscamos byte que empiece con 11 (0xC0 mask)
            if (rx_byte[7:6] == 2'b11) begin
              temp_cmd <= rx_byte[2:0];  // Guardamos comando
              state <= S_WAIT_X;
            end
          end
          endcase
      end
    end
  end
`ifdef BENCH
  reg [8*40:1] state_name;
  reg [8*40:1] command_name;
  always @(*) begin
    case (state)
      S_WAIT_HEADER:      state_name = "S_WAIT_HEADER";
      S_WAIT_X: state_name = "S_WAIT_X";
      S_WAIT_Y:       state_name = "S_WAIT_Y";
    endcase
    case (command_id)
      3'b001 :   command_name = "MOVE";
      3'b010 : command_name = "DRAW";
      3'b011 : command_name = "PICK COLOR";
      default: command_name = "NO CMD";
    endcase
  end
`endif
endmodule
