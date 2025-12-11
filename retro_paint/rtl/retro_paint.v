module retro_paint (
    input clk,
    input rstn,
    input bluetooth_tx,
    output reg LED,
    output [2:0] wire_to_screen_RGB0,
    output [2:0] wire_to_screen_RGB1,
    output wire_to_screen_CLK,
    output [4:0] wire_to_screen_ABCDE,
    output wire_to_screen_LATCH,
    output wire_to_screen_nOE,
    output wire bluetooth_energy
);
  assign bluetooth_energy = 1'b1;
  wire valid_pulse;
  always @(negedge clk) begin
    if (!rstn) LED = 1;
    else begin
      LED = LED ? !valid_pulse : LED;
    end
  end
  wire [2:0] w_to_paint_cmd;
  wire [5:0] w_to_paint_x;
  wire [5:0] w_to_paint_y;

  HID u_HID (
      .clk          (clk),
      .rx_pin       (bluetooth_tx),
      .reset        (!rstn),
      .cmd_to_screen(w_to_paint_cmd),
      .x_to_screen  (w_to_paint_x),
      .y_to_screen  (w_to_paint_y),
      .valid_pulse  (valid_pulse)
  );


  wire [5:0] w_to_gpu_x;
  wire [5:0] w_to_gpu_y;
  wire w_to_gpu_write;
  wire w_to_gpu_image_overlay;
  wire w_to_gpu_image_palette;
  wire [7:0] w_to_gpu_px_data;
  paint u_paint (
      .clk      (clk),
      .rst      (!rstn),
      .init     (rstn),
      .in_button(w_to_paint_cmd),
      .in_x     (w_to_paint_x),
      .in_y     (w_to_paint_y),
      .out_x    (w_to_gpu_x),
      .out_y    (w_to_gpu_y),
      .paint    (w_to_gpu_write),
      .paleta   (w_to_gpu_image_palette),
      .selector (w_to_gpu_image_overlay),
      .px_data  (w_to_gpu_px_data)
  );

  GPU #(
      .IMAGE_FILE  ("./data/frame0.hex"),
      .OVERLAY_FILE("./data/ceros.hex"),
      .PALETTE_FILE("./data/paleta256.hex")
  ) u_GPU (
      .clk            (clk),
      .rstn           (rstn),
      .write          (w_to_gpu_write),
      .px_data        (w_to_gpu_px_data),
      .column         (w_to_gpu_x),
      .row            (w_to_gpu_y),
      .image_palette  (w_to_gpu_image_palette),
      .image_overlay  (!w_to_gpu_image_overlay),
      .to_screen_RGB0 (wire_to_screen_RGB0),
      .to_screen_RGB1 (wire_to_screen_RGB1),
      .to_screen_CLK  (wire_to_screen_CLK),
      .to_screen_ABCDE(wire_to_screen_ABCDE),
      .to_screen_LATCH(wire_to_screen_LATCH),
      .to_screen_nOE  (wire_to_screen_nOE)
  );

endmodule
