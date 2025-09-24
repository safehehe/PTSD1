module raiz_16 (
    clk,
    rst,
    init,
    in_RR,
    out_Q,
    out_R,
    out_DONE
);
  input rst;
  input clk;
  input init;
  input [15:0] in_RR;

  output [15:0] out_R;
  output [15:0] out_Q;
  output out_DONE;

  wire w_S1;
  wire w_S2;
  wire w_S3;
  wire w_S4;
  wire w_K;
  wire w_RST;
  wire [15:0] w_Q;
  wire [15:0] w_AUX;

  lsrR lsrR (
      .clk  (clk),
      .rst  (w_RST),
      .shift(w_S4),
      .lsb  (w_S2),
      .out_R(out_R)
  );

  aux aux (
      .clk    (clk),
      .load   (w_S1),
      .in_R   (out_R),
      .out_AUX(w_AUX)
  );

  comp comp (
      .in_AUX(w_AUX),
      .in_Q(out_Q),
      .out_comp_Q(w_Q)
  );

  lsrQA lsrQA (
      .clk  (clk),
      .load (w_RST),
      .shift(w_S1),
      .add  (w_S2),
      .in_Q (w_Q),
      .in_RR(in_RR),
      .out_Q(out_Q)
  );

  acc acc (
      .rst  (w_RST),
      .clk  (clk),
      .add  (w_S3),
      .out_K(w_K)
  );
  control_raiz control_raiz (
      .clk     (clk),
      .rst     (rst),
      .in_init (init),
      .in_Q    (w_Q),
      .in_K    (w_K),
      .out_S1  (w_S1),
      .out_S2  (w_S2),
      .out_S3  (w_S3),
      .out_S4  (w_S4),
      .out_RST (w_RST),
      .out_DONE(out_DONE)
  );

endmodule

