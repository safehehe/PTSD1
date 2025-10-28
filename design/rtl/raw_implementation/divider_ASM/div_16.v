module div_16 (
    clk,
    rst,
    init_in,
    A,
    B,
    Result,
    done
);

  input rst;
  input clk;
  input init_in;
  input [15:0] A;
  input [15:0] B;
  output [15:0] Result;
  output done;


  wire w_INIT, w_SH, w_LDA;

  wire w_MSB;
  wire [16:0] Result_Sub;
  wire [16:0] Reg_A;

  wire w_DEC, w_K, w_DV0;


  lsr_div lsr_d (
      .clk(clk),
      .rst(w_INIT),
      .DV_in(A),
      .IN_A(Result_Sub),
      .INIT(w_INIT),
      .SH(w_SH),
      .LDA(w_LDA),
      .A(Reg_A),
      .DV0(w_DV0),
      .OUT_R(Result)
  );

  sumador #(
      .N_BITS(17),
      .CP2(1)
  ) sb (
      .A(Reg_A),
      .B(B),
      .out_SUM(Result_Sub)
  );

  acumulador_restando #(
      .REG_WIDTH (5),
      .RST_VALUE (16),
      .LESS_VALUE(1)
  ) ctr_vd (
      .rst  (w_INIT),
      .clk  (clk),
      .less (w_DEC),
      .out_K(w_K)
  );

  control_div ctl_dv (
      .clk(clk),
      .rst(rst),
      .init_in(init_in),
      .MSB(Result_Sub[16]),
      .in_K(w_K),
      .INIT(w_INIT),
      .SH(w_SH),
      .DEC(w_DEC),
      .LDA(w_LDA),
      .DONE(done),
      .DV0(w_DV0)
  );



endmodule


