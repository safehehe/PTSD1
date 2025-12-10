module paint (
    clk,
    rst,
    init,
    in_button,
    in_x,
    in_y,
    out_x,
    out_y,
    paint,
    px_data,
    paleta,
    selector
);
  input clk;
  input rst;
  input init;
  input [5:0] in_x;
  input [5:0] in_y;
  input [2:0] in_button;
  output wire out_x;
  output wire out_y;
  output wire paint;
  output wire paleta;
  output wire selector;
  output wire [5:0] px_data;
  assign paint = |s_paint;
  wire [2:0] s_paint;
  reg [7:0] color;
  reg [23:0] cont_cursor;
  reg [5:0] x;
  reg [5:0] y;
  reg [7:0] button;

  wire w_C;
  wire w_Enter;
  wire [7:0] px_data_cursor;
  wire [7:0] px_data_cursor_paleta;
  wire w_Enter_Paleta;
  wire rst_check;
  wire out_rst;
  wire compC;
  wire compEnt;
  wire compPal;
  wire cursor_done;
  wire cursor_paleta_done;
  wire Cursor_S;
  wire Cursor_Paleta_S;


  check #(
      .WIDTH(8)
  ) checkC (
      .data_in(in_button),
      .rst(rst_check),
      .comparar(1),
      .comparador(3'b100),
      .checkout(w_C)
  );


  check #(
      .WIDTH(8)
  ) checkEnter (
      .data_in(in_button),
      .rst(rst_check),
      .comparar(1),
      .comparador(3'b010),
      .checkout(w_Enter)
  );

  check #(
      .WIDTH(8)
  ) checkEnterPaleta (
      .data_in(in_button),
      .rst(rst_check),
      .comparar(1),
      .comparador(3'b011),
      .checkout(w_Enter_Paleta)
  );

  DRAW_CURSOR DRAW_CURSOR (
      .clk(clk),
      .rst(out_rst),
      .init(Cursor_S),
      .in_x(in_x),
      .in_y(in_y),
      .out_x(out_x),
      .out_y(out_y),
      .paint(s_paint[0]),
      .px_data(px_data_cursor),
      .cursor_done(cursor_done)
  );

  cursor_paleta cursor_paleta (
      .clk(clk),
      .rst(out_rst),
      .init(Cursor_Paleta_S),
      .cursor_paleta_done(cursor_paleta_done),
      .paint(s_paint[1]),
      .px_data(px_data_cursor_paleta),
      .in_x(in_x),
      .in_y(in_y),
      .out_x(out_x),
      .out_y(out_y)
  );




  control_paint control_paint (
      .clk(clk),
      .rst(rst),
      .init(init),
      .in_x(in_x),
      .in_y(in_y),
      .out_x(out_x),
      .out_y(out_y),
      .w_C(w_C),
      .w_Enter(w_Enter),
      .w_Enter_Paleta(w_Enter_Paleta),
      .out_rst(out_rst),
      .rst_check(rst_check),
      .px_data(px_data),
      .px_data_cursor(px_data_cursor),
      .px_data_cursor_paleta(px_data_cursor_paleta),
      .cursor_done(cursor_done),
      .cursor_paleta_done(cursor_paleta_done),
      .Cursor_S(Cursor_S),
      .Cursor_Paleta_S(Cursor_Paleta_S),
      .compEnt(compEnt),
      .compC(compC),
      .compPal(compPal),
      .paint(s_paint[2]),
      .selector(selector),
      .paleta(paleta)
  );



























endmodule
