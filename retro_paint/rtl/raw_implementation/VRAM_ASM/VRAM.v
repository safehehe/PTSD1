module VRAM (
    input clk,
    input wr,
    input [9:0] wr_addr,
    input [31:0] in_data,
    input rd,
    input [5:0] rd_addr,
    output reg [511:0] out_data
);

  reg [511:0] vram[0:63];  //64 cells 512 wide
  wire [3:0] write_mask;
  assign write_mask = wr_addr[3:0];
  wire [5:0] write_row;
  assign write_row = wr_addr[9:4];

  initial begin
    $readmemh("./test_benches/test_mem_image.hex", vram);
  end


  always @(posedge clk) begin
    if (rd) out_data = vram[rd_addr];
    else if (wr) begin
      if (write_mask == 4'd0) vram[write_row][31:0] = in_data;
      if (write_mask == 4'd1) vram[write_row][63:32] = in_data;
      if (write_mask == 4'd2) vram[write_row][95:64] = in_data;
      if (write_mask == 4'd3) vram[write_row][127:96] = in_data;
      if (write_mask == 4'd4) vram[write_row][159:128] = in_data;
      if (write_mask == 4'd5) vram[write_row][191:160] = in_data;
      if (write_mask == 4'd6) vram[write_row][223:192] = in_data;
      if (write_mask == 4'd7) vram[write_row][255:224] = in_data;
      if (write_mask == 4'd8) vram[write_row][287:256] = in_data;
      if (write_mask == 4'd9) vram[write_row][319:288] = in_data;
      if (write_mask == 4'd10) vram[write_row][351:320] = in_data;
      if (write_mask == 4'd11) vram[write_row][383:352] = in_data;
      if (write_mask == 4'd12) vram[write_row][415:384] = in_data;
      if (write_mask == 4'd13) vram[write_row][447:416] = in_data;
      if (write_mask == 4'd14) vram[write_row][479:448] = in_data;
      if (write_mask == 4'd15) vram[write_row][511:480] = in_data;
    end
  end
endmodule
