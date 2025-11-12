module run_CACHE (
    input clk,
    input in_INIT,
    input rst,
    input in_PLANE_READY_MM,
    output reg out_CACHE,
    output reg out_HUB75_INIT
);
  reg [1:0] state;
  always @(posedge clk) begin
    if (rst) begin
      if (in_INIT) begin
        out_CACHE = 1;
        out_HUB75_INIT = 0;
        state = 2'b01;
      end else begin
        out_CACHE = 0;
        out_HUB75_INIT = 0;
        state = 2'b00;
      end
    end else
      case (state)
        2'b00: begin
          if (in_INIT) begin
            out_CACHE = 1;
            out_HUB75_INIT = 0;
            state = 2'b01;
          end else begin
            out_CACHE = 0;
            out_HUB75_INIT = 0;
            state = 2'b00;
          end
        end
        2'b01: begin
          if (in_PLANE_READY_MM) begin
            out_CACHE = 0;
            out_HUB75_INIT = 1;
            state = 2'b10;
          end else begin
            out_CACHE = 0;
            out_HUB75_INIT = 0;
            state = 2'b01;
          end
        end
        2'b10: begin
          out_CACHE = 0;
          out_HUB75_INIT = 0;
          state = 2'b00;
        end
        default: state = 2'b00;
      endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      2'b00: begin
        if (in_INIT) begin
          state_name = "out_CACHE = 1";
        end else begin
          state_name = "00 BOTH cero";
        end
      end
      2'b01: begin
        if (in_PLANE_READY_MM) begin
          state_name = "out_HUB75_INIT = 1";
        end else begin
          state_name = "01 BOTH cero";
        end
      end
      2'b10: begin
        state_name = "10 BOTH cero";
      end
    endcase
  end
`endif
endmodule
