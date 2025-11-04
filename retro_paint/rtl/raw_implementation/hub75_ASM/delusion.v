module delusion (
  input clk,
  input rst,
  input shift,
  output reg out_channel
);
  reg [63:0] reg_channel;
  reg next_pixel;
  initial begin
    reg_channel = 64'h0AB8DE7F;
  end
  always @(negedge clk ) begin
    out_channel = next_pixel;
  end
  always @(posedge clk ) begin
    if (rst) reg_channel = 64'h391EABCE0AB8DE7F;
    else begin
      if (shift) reg_channel = reg_channel>>1;
      else next_pixel = reg_channel[0];
    end
  end

endmodule
