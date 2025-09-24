module BCD (
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
  wire w_S1;
  wire w_S2;
  wire w_S3;
  wire w_S4;
  wire w_S5;
  wire w_RST;
  wire w_K;
  wire [3:0] w_sum_UND;
  wire [3:0] w_sum_DEC;
  wire [3:0] w_mux_UND;
  wire [3:0] w_mux_DEC;


  lsr_CEN_DEC_UND_BIN lsr_CEN_DEC_UND_BIN (
      .clk     (clk),
      .load_BIN(w_RST),
      .shift   (w_S1),
      .load_UND(w_S3),
      .load_DEC(w_S4),
      .in_BIN  (in_BIN),
      .in_UND  (w_sum_UND),
      .in_DEC  (w_sum_DEC),
      .out_UND (out_UND),
      .out_DEC (out_DEC),
      .out_CEN (out_CEN)
  );

  mux mux_UND (
      .SELECT(w_S2),
      .out   (w_mux_UND)
  );
  mux mux_DEV (
      .SELECT(w_S2),
      .out   (w_mux_DEC)
  );

  sum sum_UND (
      .A  (out_UND),
      .B  (w_mux_UND),
      .out(w_sum_UND)
  );
  sum sum_DEC (
      .A  (out_DEC),
      .B  (w_mux_DEC),
      .out(w_sum_DEC)
  );

  acc acc (
      .rst  (w_RST),
      .clk  (clk),
      .add  (w_S5),
      .out_K(w_K)
  );

  control_BCD control_BCD (
      .clk       (clk),
      .rst       (rst),
      .in_init   (init),
      .in_K      (w_K),
      .in_sum_UND(w_sum_UND),
      .in_sum_DEC(w_sum_DEC),
      .out_S1    (w_S1),
      .out_S2    (w_S2),
      .out_S3    (w_S3),
      .out_S4    (w_S4),
      .out_S5    (w_S5),
      .out_RST   (w_RST),
      .out_DONE  (out_DONE)
  );




endmodule

