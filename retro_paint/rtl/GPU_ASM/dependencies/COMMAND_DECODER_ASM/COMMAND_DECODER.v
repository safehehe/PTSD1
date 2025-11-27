module COMMAND_DECODER (
    input clk,
    input rst,
    input in_write,
    input [7:0] in_px_data,
    input [5:0] in_column,
    input [5:0] in_row,
    input in_image_palette,
    input in_image_overlay,
    input in_VRAM_available,
    output reg out_write_available,
    output reg out_write,
    output reg [11:0] out_addr,
    output reg [7:0] out_px_data,
    output reg out_image_or_overlay,
    output reg out_image_select,
    output reg out_rst
);
  parameter NEED_SWITCH = 1;
  parameter NO_NEED = 0;
  reg switch_state;
  reg last_image;
  always @(posedge clk) begin
    if (rst) begin
      out_write_available = 0;
      out_write = 0;
      out_addr = 0;
      out_px_data = 0;
      out_image_or_overlay = 0;
      out_image_select = 0;
      out_rst = 1;
      last_image = 0;
      switch_state = NO_NEED;
    end else begin
      case (switch_state)
        NO_NEED: begin
          if (in_image_palette != last_image) begin
            if (in_VRAM_available) begin
              out_image_select = in_image_palette;
              last_image = in_image_palette;
              switch_state = NO_NEED;
            end else begin
              last_image   = in_image_palette;
              switch_state = NEED_SWITCH;
            end
          end else switch_state = NO_NEED;
        end
        NEED_SWITCH: begin
          if (in_VRAM_available) begin
            out_image_select = last_image;
            switch_state = NO_NEED;
          end else begin
            switch_state = NEED_SWITCH;
          end
        end
      endcase
      out_write_available = in_VRAM_available & (&{~switch_state, ~in_image_palette} | in_image_overlay);
      out_write = &{in_write, in_VRAM_available} & (&{~switch_state, ~in_image_palette} | in_image_overlay);
      out_addr = {in_row, in_column};
      out_px_data = in_px_data;
      out_image_or_overlay = in_image_overlay;
      out_rst = 0;
    end
  end
endmodule
