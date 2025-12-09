module control_paint (
    clk,
    rst,
    init,
    in_x,
    in_y,
    out_x,
    out_y,
    w_C,
    w_Enter,
    w_Enter_Paleta,
    out_rst,
    rst_check,
    px_data,
    cursor_done,
    cursor_paleta_done,
    Cursor_S,
    Cursor_Paleta_S,
    compEnt,
    compC,
    compPal,
    paint,
    selector,
    paleta
);

  input clk;
  input rst;
  input init;
  input w_C;
  input w_Enter;
  input w_Enter_Paleta;
  input [7:0] in_x;
  input [7:0] in_y;
  input cursor_done;
  input cursor_paleta_done;

  output reg [7:0] out_x;
  output reg [7:0] out_y;
  output reg [7:0] px_data;
  output reg rst_check;
  output reg out_rst;
  output reg Cursor_Paleta_S;
  output reg Cursor_S;
  output reg paint;
  output reg selector;
  output reg paleta;
  output reg compC;
  output reg compEnt;
  output reg compPal;

  reg [7:0] color;


  parameter START = 4'b0000;
  parameter INICIALIZACION = 4'b0001;
  parameter CHECK_C = 4'b0010;
  parameter CHECK_ENTER = 4'b0011;
  parameter CURSOR_PALETA = 4'b0100;
  parameter CHECK_ENTER_PALETA = 4'b0101;
  parameter CHANGE_COLOR = 4'b0110;
  parameter DRAW_CURSOR = 4'b0111;
  parameter PAINT = 4'b1000;

  reg [3:0] state;

  always @(negedge clk) begin
    if (rst) begin
      px_data = 8'b0;
      color   = 8'b0;
      out_x   = 8'b0;
      out_y   = 8'b0;
      state   = START;
    end else begin
      case (state)

        START: begin
          px_data = 8'b0;
          color   = 8'b0;
          state   = init ? INICIALIZACION : START;
        end

        INICIALIZACION: begin
          out_x = in_x;
          out_y = in_y;
          state = CHECK_C;
        end

        CHECK_C: begin
          state = w_C ? CURSOR_PALETA : CHECK_ENTER;
        end

        CHECK_ENTER: begin
          state = w_Enter ? PAINT : DRAW_CURSOR;
        end

        PAINT: begin
          out_x   = in_x;
          out_y   = in_y;
          px_data = color;
          state   = INICIALIZACION;
        end

        DRAW_CURSOR: begin
          state = cursor_done ? INICIALIZACION : DRAW_CURSOR;
        end

        CURSOR_PALETA: begin
          state = cursor_paleta_done ? CHECK_ENTER_PALETA : CURSOR_PALETA;
        end

        CHECK_ENTER_PALETA: begin
          state = w_Enter_Paleta ? CHANGE_COLOR : CURSOR_PALETA;
        end

        CHANGE_COLOR: begin
          color = {in_x[3:0], in_y[3:0]};
          state = INICIALIZACION;
        end
      endcase
    end
  end

  always @(*) begin
    case (state)
      START: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 1;
        out_rst = 1;
        paleta = 0;
      end

      INICIALIZACION: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 0;
        paleta = 0;
      end

      CHECK_C: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 1;
        compEnt = 0;
        compPal = 0;
        rst_check = 1;
        paleta = 0;
      end

      CHECK_ENTER: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 1;
        compPal = 0;
        rst_check = 1;
        paleta = 0;
      end

      CURSOR_PALETA: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 1;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 0;
        paleta = 1;
      end

      CHECK_ENTER_PALETA: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 1;
        rst_check = 0;
        paleta = 0;
      end

      PAINT: begin
        paint = 1;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 1;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 1;
        paleta = 0;
      end

      DRAW_CURSOR: begin
        paint = 0;
        Cursor_S = 1;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 0;
        paleta = 0;
      end

      CHANGE_COLOR: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 0;
        paleta = 0;
        out_rst = 1;
      end
      default: begin
        paint = 0;
        Cursor_S = 0;
        Cursor_Paleta_S = 0;
        selector = 0;
        compC = 0;
        compEnt = 0;
        compPal = 0;
        rst_check = 1;
        paleta = 0;
        out_rst = 1;
      end
    endcase
  end



endmodule
