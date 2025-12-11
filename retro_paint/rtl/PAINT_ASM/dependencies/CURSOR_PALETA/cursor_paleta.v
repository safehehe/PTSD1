module cursor_paleta (
    clk,
    rst,
    init,
    cursor_paleta_done,
    paint,
    px_data,
    in_x,
    in_y,
    out_x,
    out_y
);
  input clk;
  input rst;
  input init;
  input [5:0] in_x;
  input [5:0] in_y;
  output [5:0] out_x;
  output [5:0] out_y;

  output cursor_paleta_done;
  output paint;
  output [7:0] px_data;

  wire Contar_Blanco_S;
  wire Contar_Negro_S;
  wire CB;
  wire CN;
  wire [2:0] C;
  wire Change_X;
  wire Change_Y;
  wire sum;
  wire plus;
  wire out_rst;
  wire rst_cont;

  control_cursor_paleta control_cursor_paleta (
      .clk(clk),
      .init(init),
      .rst(rst),
      .CB(CB),
      .CN(CN),
      .C(C),
      .px_data(px_data),
      .plus(plus),
      .paint(paint),
      .Change_X(Change_X),
      .Change_Y(Change_Y),
      .sum(sum),
      .out_rst(out_rst),
      .rst_cont(rst_cont),
      .cursor_paleta_done(cursor_paleta_done),
      .Contar_Blanco_S(Contar_Blanco_S),
      .Contar_Negro_S(Contar_Negro_S)
  );

  CONTAR_BLANCO CONTAR_BLANCO (
      .clk (clk),
      .rst (out_rst),
      .init(Contar_Blanco_S),
      .CB  (CB)
  );

  CONTAR_NEGRO CONTAR_NEGRO (
      .clk (clk),
      .init(Contar_Negro_S),
      .rst (out_rst),
      .CN  (CN)
  );

  CAMBIAR_X CAMBIAR_X (
      .clk(clk),
      .rst(out_rst),
      .in_x(in_x),
      .out_x(out_x),
      .plus(Change_X),
      .sum(sum),
      .C(C)
  );

  CAMBIAR_Y CAMBIAR_Y (
      .clk(clk),
      .rst(out_rst),
      .in_y(in_y),
      .out_y(out_y),
      .plus(Change_Y),
      .sum(sum),
      .C(C)
  );

  acumulador #(
      .WIDTH(3),
      .RST_VALUE(0),
      .PLUS_VALUE(1),
      .POS_EDGE(0)
  ) acc (
      .clk  (clk),
      .rst  (rst_cont),
      .plus (plus),
      .value(C)
  );



endmodule
