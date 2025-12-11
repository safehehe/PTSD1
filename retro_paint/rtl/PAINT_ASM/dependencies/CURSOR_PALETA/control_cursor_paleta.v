module control_cursor_paleta (
    clk,
    init,
    rst,
    CB,
    CN,
    C,
    px_data,
    plus,
    paint,
    Change_X,
    Change_Y,
    sum,
    out_rst,
    rst_cont,
    cursor_paleta_done,
    Contar_Blanco_S,
    Contar_Negro_S
);

  input clk;
  input init;
  input rst;
  input CB;
  input CN;
  input [2:0] C;

  output reg Contar_Blanco_S;
  output reg Contar_Negro_S;
  output reg cursor_paleta_done;
  output reg out_rst;
  output reg rst_cont;
  output reg plus;
  output reg paint;
  output reg [7:0] px_data;

  output reg sum;
  output reg Change_X;
  output reg Change_Y;

  parameter START = 5'b00000;
  parameter X_DERECHA = 5'b00001;
  parameter RST_CONT_1 = 5'b00010;
  parameter Y_ABAJO = 5'b00011;
  parameter RST_CONT_2 = 5'b00100;
  parameter X_IZQ = 5'b00101;
  parameter RST_CONT_3 = 5'b00110;
  parameter Y_ARRIBA = 5'b00111;
  parameter RST_CONT_4 = 5'b01000;
  parameter CONTAR_NEGRO = 5'b01001;
  parameter CONTAR_BLANCO = 5'b01010;
  parameter CHANGE_COLOR = 5'b01011;
  parameter CHECK_CONT = 5'b10001;
  parameter DONE = 5'b01100;
  parameter ACC_1 = 5'b01101;
  parameter ACC_2 = 5'b01110;
  parameter ACC_3 = 5'b01111;
  parameter ACC_4 = 5'b10000;

  reg [4:0] state;
  reg cont;

  always @(posedge clk) begin
    if (rst) begin
      cont = 0;
      state = START;
    end else begin
      case (state)
        START: begin
          cont = 0;
          px_data = 8'b11111111;
          state = init ? X_DERECHA : START;
        end
        X_DERECHA: begin
          if (cont) begin
            px_data = 8'b0;
          end
          state = ACC_1;
        end

        ACC_1 : begin
          state = (C == 3'b100) ? RST_CONT_1 : X_DERECHA;
        end

        RST_CONT_1: begin
          state = Y_ABAJO;
        end
        Y_ABAJO: begin
          state = ACC_2;
        end

        ACC_2 : begin
          state = (C == 3'b100) ? RST_CONT_2 : Y_ABAJO;
        end

        RST_CONT_2: begin
          state = X_IZQ;
        end

        X_IZQ: begin
          state = ACC_3;
        end

        ACC_3 : begin
          state = (C == 3'b100) ? RST_CONT_3 : X_IZQ;
        end

        RST_CONT_3: begin
          state = Y_ARRIBA;
        end

        Y_ARRIBA: begin
          state = ACC_4;
        end

        ACC_4 : begin
          state = (C == 3'b100) ? RST_CONT_4 : Y_ARRIBA;
        end

        RST_CONT_4: begin
          state = CB ? CONTAR_NEGRO : CONTAR_BLANCO;
        end
        CONTAR_BLANCO: begin
          state = CB ? CHANGE_COLOR : CONTAR_BLANCO;
        end
        CHANGE_COLOR: begin
          px_data = 8'b0;
          state   = X_DERECHA;
        end
        CONTAR_NEGRO: begin 
          state = CN ? CHECK_CONT : CONTAR_NEGRO;
        end
        CHECK_CONT : begin
          if (cont) begin
            state = DONE;
          end else begin
            cont = 1;
            px_data = 8'b0;
            state = X_DERECHA;
          end
        end
        DONE: begin
          state = START;
        end
        default : state = START;
      endcase
    end
  end

  always @(*) begin
    case (state)
      START: begin
        out_rst = 1;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      X_DERECHA: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 1;
        Change_X = 1;
        Change_Y = 0;
        paint = 1;
      end
      RST_CONT_1: begin
        out_rst = 0;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      ACC_1 : begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 1;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      ACC_2 : begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 1;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      ACC_3 : begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 1;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      ACC_4 : begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 1;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      Y_ABAJO: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 1;
        Change_X = 0;
        Change_Y = 1;
        paint = 1;
      end
      RST_CONT_2: begin
        out_rst = 0;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      X_IZQ: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 1;
        Change_Y = 0;
        paint = 1;
      end
      RST_CONT_3: begin
        out_rst = 0;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      Y_ARRIBA: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 1;
        paint = 1;
      end
      RST_CONT_4: begin
        out_rst = 0;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      CONTAR_BLANCO: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 1;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      CHANGE_COLOR: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      CONTAR_NEGRO: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 1;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      CHECK_CONT : begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      DONE: begin
        out_rst = 0;
        rst_cont = 0;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 1;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
      default: begin
        out_rst = 1;
        rst_cont = 1;
        Contar_Blanco_S = 0;
        Contar_Negro_S = 0;
        cursor_paleta_done = 0;
        plus = 0;
        sum = 0;
        Change_X = 0;
        Change_Y = 0;
        paint = 0;
      end
    endcase

  end
endmodule
