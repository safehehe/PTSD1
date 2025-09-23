module BCD (
    clk,
    rst,
    init,
    in_BIN,
    out_UND,
    out_DEC,
    out_CEN,
    out_K,
    out_DONE
);
  input rst;
  input clk;
  input init;
  input [15:0] in_BIN;
  
  output [15:0] UND;
  output [15:0] DEC;
  output [15:0] CEN;
  output [15:0] K;
  output DONE;
  
  wire w_RST;
  wire w_SS;
  wire w_DEC;
  wire w_DEL;
  wire w_SD;
  wire w_SU;
  
  lsrR lsr_CEN_DEC_UND_BIN(
  	.clk(clk),
  	.rst(rst),
  	.load(in_BIN)
  	.out(out_CEN)
  	.out(out_DEN)
  	.out(out_UND)
  );
  
  rst RST (
  	.clk (clk),
  	.rst (rst),
  	.add (w_SS),
  	.out_K(out_K)
  );
  
  cen CEN (
  	.clk (clk),
  	.out_CEN (out.CEN)
  );
  
  dec DEC (
  	.clk (clk),
  	.out DEC (out.DEC)
  );
  
  und UND (
  	.clk (clk),
  	.out UND (out.UND)
  );
  
  bin BIN (
  	.clk (clk),
  	.load (w_RST),
  	.shift (w_SD),
  	.in_BIN (in_BIN),
  	.out_K (out_K)
  );


endmodule  //BCD

