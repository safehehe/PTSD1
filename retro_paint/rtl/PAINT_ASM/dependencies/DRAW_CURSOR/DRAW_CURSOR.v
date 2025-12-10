module DRAW_CURSOR (
    clk,
    rst,
    init,
    in_x,
    in_y,
    out_x,
    out_y,
    paint,
    px_data,
    cursor_done
);

  input clk;
  input rst;
  input init;
  input [5:0] in_x;
  input [5:0] in_y;
  output wire [5:0] out_x;
  output wire [5:0] out_y;

  output cursor_done;
  output paint;
  output [7:0] px_data;

  wire Contar_Blanco_S;
  wire Contar_Negro_S;
  wire out_rst;
  wire CB;
  wire CN;

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

  control_cursor control_cursor (
      .clk(clk),
      .rst(rst),
      .init(init),
      .px_data(px_data),
      .in_x(in_x),
      .in_y(in_y),
      .out_x(out_x),
      .out_y(out_y),
      .paint(paint),
      .Contar_Blanco_S(Contar_Blanco_S),
      .Contar_Negro_S(Contar_Negro_S),
      .CB(CB),
      .CN(CN),
      .out_rst(out_rst),
      .cursor_done(cursor_done)
  );


endmodule
