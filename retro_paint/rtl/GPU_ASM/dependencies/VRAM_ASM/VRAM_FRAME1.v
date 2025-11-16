module VRAM_FRAME1 (
    input clk,
    input wr,
    input [11:0] wr_addr,  //4096 direcciones una por pixel
    input [7:0] in_data,
    input rd,
    input [5:0] rd_addr,
    output reg [511:0] out_data
);
  (* ram_style = "block" *)
  reg [7:0] vram[0:4095];  //4096 cells 8bits wide

  initial begin
    $readmemh("./test_benches/frame1.hex", vram);
  end
  always @(posedge clk) begin
    if (wr) vram[wr_addr] <= in_data;
    if (rd) begin  //7:0 pixel numero cero, numero de pixel aumenta a la derecha
      out_data[7:0] <= vram[{rd_addr, 6'd0}];
      out_data[15:8] <= vram[{rd_addr, 6'd1}];
      out_data[23:16] <= vram[{rd_addr, 6'd2}];
      out_data[31:24] <= vram[{rd_addr, 6'd3}];
      out_data[39:32] <= vram[{rd_addr, 6'd4}];
      out_data[47:40] <= vram[{rd_addr, 6'd5}];
      out_data[55:48] <= vram[{rd_addr, 6'd6}];
      out_data[63:56] <= vram[{rd_addr, 6'd7}];
      out_data[71:64] <= vram[{rd_addr, 6'd8}];
      out_data[79:72] <= vram[{rd_addr, 6'd9}];
      out_data[87:80] <= vram[{rd_addr, 6'd10}];
      out_data[95:88] <= vram[{rd_addr, 6'd11}];
      out_data[103:96] <= vram[{rd_addr, 6'd12}];
      out_data[111:104] <= vram[{rd_addr, 6'd13}];
      out_data[119:112] <= vram[{rd_addr, 6'd14}];
      out_data[127:120] <= vram[{rd_addr, 6'd15}];
      out_data[135:128] <= vram[{rd_addr, 6'd16}];
      out_data[143:136] <= vram[{rd_addr, 6'd17}];
      out_data[151:144] <= vram[{rd_addr, 6'd18}];
      out_data[159:152] <= vram[{rd_addr, 6'd19}];
      out_data[167:160] <= vram[{rd_addr, 6'd20}];
      out_data[175:168] <= vram[{rd_addr, 6'd21}];
      out_data[183:176] <= vram[{rd_addr, 6'd22}];
      out_data[191:184] <= vram[{rd_addr, 6'd23}];
      out_data[199:192] <= vram[{rd_addr, 6'd24}];
      out_data[207:200] <= vram[{rd_addr, 6'd25}];
      out_data[215:208] <= vram[{rd_addr, 6'd26}];
      out_data[223:216] <= vram[{rd_addr, 6'd27}];
      out_data[231:224] <= vram[{rd_addr, 6'd28}];
      out_data[239:232] <= vram[{rd_addr, 6'd29}];
      out_data[247:240] <= vram[{rd_addr, 6'd30}];
      out_data[255:248] <= vram[{rd_addr, 6'd31}];
      out_data[263:256] <= vram[{rd_addr, 6'd32}];
      out_data[271:264] <= vram[{rd_addr, 6'd33}];
      out_data[279:272] <= vram[{rd_addr, 6'd34}];
      out_data[287:280] <= vram[{rd_addr, 6'd35}];
      out_data[295:288] <= vram[{rd_addr, 6'd36}];
      out_data[303:296] <= vram[{rd_addr, 6'd37}];
      out_data[311:304] <= vram[{rd_addr, 6'd38}];
      out_data[319:312] <= vram[{rd_addr, 6'd39}];
      out_data[327:320] <= vram[{rd_addr, 6'd40}];
      out_data[335:328] <= vram[{rd_addr, 6'd41}];
      out_data[343:336] <= vram[{rd_addr, 6'd42}];
      out_data[351:344] <= vram[{rd_addr, 6'd43}];
      out_data[359:352] <= vram[{rd_addr, 6'd44}];
      out_data[367:360] <= vram[{rd_addr, 6'd45}];
      out_data[375:368] <= vram[{rd_addr, 6'd46}];
      out_data[383:376] <= vram[{rd_addr, 6'd47}];
      out_data[391:384] <= vram[{rd_addr, 6'd48}];
      out_data[399:392] <= vram[{rd_addr, 6'd49}];
      out_data[407:400] <= vram[{rd_addr, 6'd50}];
      out_data[415:408] <= vram[{rd_addr, 6'd51}];
      out_data[423:416] <= vram[{rd_addr, 6'd52}];
      out_data[431:424] <= vram[{rd_addr, 6'd53}];
      out_data[439:432] <= vram[{rd_addr, 6'd54}];
      out_data[447:440] <= vram[{rd_addr, 6'd55}];
      out_data[455:448] <= vram[{rd_addr, 6'd56}];
      out_data[463:456] <= vram[{rd_addr, 6'd57}];
      out_data[471:464] <= vram[{rd_addr, 6'd58}];
      out_data[479:472] <= vram[{rd_addr, 6'd59}];
      out_data[487:480] <= vram[{rd_addr, 6'd60}];
      out_data[495:488] <= vram[{rd_addr, 6'd61}];
      out_data[503:496] <= vram[{rd_addr, 6'd62}];
      out_data[511:504] <= vram[{rd_addr, 6'd63}];
    end
  end
endmodule
