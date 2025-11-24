module BCD2BIN (
    input clk,
    input rst,
    input [3:0] in_DEC,
    input [3:0] in_UND,
    input in_INIT,
    output [7:0] out_BIN,
    output out_DONE
);
  wire w_RST, w_SHIFT, w_LOAD, w_LESS, w_K, w_UND;
  wire w_mux_n, w_sum_und, w_mux_und;

  multiplexor2x1 #(
      .IN_WIDTH(4)
  ) u_mux_und (
      .IN1    (w_sum_und),
      .IN0    (in_UND),
      .SELECT (w_LOAD),
      .MUX_OUT(w_mux_und)
  );

  multiplexor2x1 #(
      .IN_WIDTH(4)
  ) u_mux_n (
      .IN1    (4'd4),
      .IN0    (4'd3),
      .SELECT (w_LOAD),
      .MUX_OUT(w_mux_n)
  );

  sumador #(
      .N_BITS(4),
      .CP2(1)
  ) u_sumador (
      .A      (w_UND),
      .B      (w_mux_n),
      .out_SUM(w_sum_und)
  );

  control_BCD2BIN u_control_BCD2BIN (
      .clk      (clk),
      .rst      (rst),
      .in_init  (in_init),
      .in_K     (w_K),
      .in_UND   (w_sum_und),
      .out_RST  (w_RST),
      .out_LOAD (w_LOAD),
      .out_SHIFT(w_SHIFT),
      .out_LESS (w_LESS),
      .out_DONE (out_DONE)
  );

  rsr_DEC_UND_BIN u_rsr_DEC_UND_BIN (
      .clk        (clk),
      .rst        (w_RST),
      .in_DEC     (in_DEC),
      .in_UND     (w_mux_und),
      .in_SHIFT   (w_SHIFT),
      .in_LOAD_UND(w_LOAD),
      .out_UND    (w_UND),
      .out_BIN    (out_BIN)
  );


endmodule
