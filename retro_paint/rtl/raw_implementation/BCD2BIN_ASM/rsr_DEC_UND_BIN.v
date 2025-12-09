module rsr_DEC_UND_BIN (
    input clk,
    input rst,
    input [3:0] in_DEC,
    input [3:0] in_UND,
    input in_SHIFT,
    input in_LOAD_UND,
    output reg [3:0] out_UND,
    output reg [7:0] out_BIN
);
  reg [3:0] reg_DEC;
  always @(negedge clk) begin
    if (rst) begin
      reg_DEC = in_DEC;
      out_UND = in_UND;
      out_BIN = 8'b0;
    end else if (in_SHIFT) {reg_DEC, out_UND, out_BIN} = {reg_DEC, out_UND, out_BIN} >> 1;
    else if (in_LOAD_UND) out_UND = in_UND;
    else begin
      reg_DEC = reg_DEC;
      out_UND = out_UND;
      out_BIN = out_BIN;
    end
  end
endmodule
