module BIN_TO_BCD (
    clk,
    rst,
    init,
    in_BIN,
    out_UND,
    out_DEC,
    out_CEN,
    out_DONE
);
  input rst;
  input clk;
  input init;
  input [8:0] in_BIN;
  output [3:0] out_UND;
  output [3:0] out_DEC;
  output [3:0] out_CEN;
  output out_DONE;
  wire w_SHIFT;
  wire w_SELECT_MUX;
  wire w_LOAD_UND;
  wire w_LOAD_DEC;
  wire w_ACC;
  wire w_RST;
  wire w_K;
  wire [3:0] w_sum_UND;
  wire [3:0] w_sum_DEC;
  wire [3:0] w_mux_UND;
  wire [3:0] w_mux_DEC;


  lsr_CEN_DEC_UND_BIN lsr_CEN_DEC_UND_BIN (
      .clk     (clk),
      .load_BIN(w_RST),
      .shift   (w_SHIFT),
      .load_UND(w_LOAD_UND),
      .load_DEC(w_LOAD_DEC),
      .in_BIN  (in_BIN),
      .in_UND  (w_sum_UND),
      .in_DEC  (w_sum_DEC),
      .out_UND (out_UND),
      .out_DEC (out_DEC),
      .out_CEN (out_CEN)
  );

  multiplexor2x1 #(
      .IN_WIDTH(4)
  ) mux_UND (
      .IN1    (4'b0011),
      .IN0    (4'b1011),
      .SELECT (w_SELECT_MUX),
      .MUX_OUT(w_mux_UND)
  );

  multiplexor2x1 #(
      .IN_WIDTH(4)
  ) mux_DEC (
      .IN1    (4'b0011),
      .IN0    (4'b1011),
      .SELECT (w_SELECT_MUX),
      .MUX_OUT(w_mux_DEC)
  );

  sumador #(
      .N_BITS(4)
  ) sum_UND (
      .A  (out_UND),
      .B  (w_mux_UND),
      .out_SUM(w_sum_UND)
  );

  sumador #(
      .N_BITS(4)
  ) sum_DEC (
      .A(out_DEC),
      .B(w_mux_DEC),
      .out_SUM(w_sum_DEC)
  );

  acumulador_restando #(
      .REG_WIDTH (4),
      .RST_VALUE (8),
      .LESS_VALUE(1)
  ) acc (
      .rst  (rst),
      .clk  (clk),
      .less (w_ACC),
      .out_K(w_K)
  );

  control_BCD control_BCD (
      .clk           (clk),
      .rst           (rst),
      .in_init       (init),
      .in_K          (w_K),
      .in_sum_UND    (w_sum_UND),
      .in_sum_DEC    (w_sum_DEC),
      .out_SHIFT     (w_SHIFT),
      .out_SELECT_MUX(w_SELECT_MUX),
      .out_LOAD_UND  (w_LOAD_UND),
      .out_LOAD_DEC  (w_LOAD_DEC),
      .out_ACC       (w_ACC),
      .out_RST       (w_RST),
      .out_DONE      (out_DONE)
  );




endmodule

