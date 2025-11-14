module hub75_show_sync (
    input  clk,
    input  rst,
    input  in_sync_hub75_latch,
    output out_synced_hub75_latch
);
  reg state;
  assign out_synced_hub75_latch = state;
  always @(posedge clk) begin
    if (rst) state = 1'b0;
    else
      case (state)
        1'b0: state = in_sync_hub75_latch ? 1'b1 : 1'b0;
        1'b1: state = 1'b0;
        default: state = 1'b0;
      endcase
  end
endmodule
