module BCD_TO_7SEG (
    input  [3:0] in_BCD,
    output reg [7:0] out_7SEG
);

  always @(*) begin
    case (in_BCD)           //abcd efg.
      4'b0000 : out_7SEG = 8'b1111_1100;
      4'b0001 : out_7SEG = 8'b0110_0000;
      4'b0010 : out_7SEG = 8'b1101_1010;
      4'b0011 : out_7SEG = 8'b1111_0010;
      4'b0100 : out_7SEG = 8'b0110_0110;
      4'b0101 : out_7SEG = 8'b1011_0110;
      4'b0110 : out_7SEG = 8'b1011_1110;
      4'b0111 : out_7SEG = 8'b1110_0000;
      4'b1000 : out_7SEG = 8'b1111_1110;
      4'b1001 : out_7SEG = 8'b1110_0110;
      default: out_7SEG = 8'b0110_1101;
    endcase
  end
endmodule
