module raiz_32 (
    clk,
    rst,
    init,
    RR,
    Q,
    R,
    done
);
  input rst;
  input clk;
  input init;
  input RR;

  output [31:0] R;
  output [31:0] Q;
  output done;

  wire w_S1;
  wire w_S2;
  wire w_S3;
  wire w_RST;
  wire w_Z;
  wire w_K;
  wire [31:0] w_R;
  wire [31:0] w_Q;
  wire [31:0] w_AUX;

  lsrR lsrR (
      .clk  (clk),
      .rst  (w_RST),
      .shift(w_S3),
      .lsb  (w_S2),
      .out_R(w_R)
  );
  aux aux (
      .clk    (clk),
      .load   (w_S1),
      .in_R   (w_R),
      .out_AUX(w_AUX)
  );

  comp comp (
      .in_AUX(w_AUX),
      .in_Q  (w_Q),
      .z     (w_Z)
  );

endmodule

