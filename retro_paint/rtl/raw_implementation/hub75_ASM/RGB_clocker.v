module RGB_clocker (
    input clk,
    input rst,
    input in_INIT,
    input in_R0,
    input in_G0,
    input in_B0,
    input in_R1,
    input in_G1,
    input in_B1,
    output reg out_FINISH,
    output wire out_ITER,
    output wire out_R0,
    output wire out_G0,
    output wire out_B0,
    output wire out_R1,
    output wire out_G1,
    output wire out_B1,
    output wire S_CLOCK
);
  reg reg_LEDS_RST;
  reg reg_LEDS_L;
  assign out_ITER = reg_LEDS_L;
  assign S_CLOCK  = clk & reg_LEDS_L;
  wire w_K;

  assign out_R0 = in_R0;
  assign out_G0 = in_G0;
  assign out_B0 = in_B0;
  assign out_R1 = in_R1;
  assign out_G1 = in_G1;
  assign out_B1 = in_B1;

  reg [1:0] state;
  parameter START = 2'b00;
  parameter ITER = 2'b01;
  parameter FINISH = 2'b10;

  always @(posedge clk) begin
    if (rst) begin
      state = START;
      reg_LEDS_RST = 1;
      reg_LEDS_L = 0;
      out_FINISH = 0;
    end else
      case (state)
        START: begin
          if (in_INIT) begin
            state = ITER;
            reg_LEDS_RST = 0;
            reg_LEDS_L = 1;
            out_FINISH = 0;
          end else begin
            state = START;
            reg_LEDS_RST = 1;
            reg_LEDS_L = 0;
            out_FINISH = 0;
          end
        end
        ITER: begin
          if (!w_K) begin
            state = FINISH;
            reg_LEDS_RST = 0;
            reg_LEDS_L = 0;
            out_FINISH = 1;
          end else begin
            state = ITER;
            reg_LEDS_RST = 0;
            reg_LEDS_L = 1;
            out_FINISH = 0;
          end
        end
        FINISH: begin
          state = FINISH;
          reg_LEDS_RST = 0;
          reg_LEDS_L = 0;
          out_FINISH = 1;
        end
        default: begin
          if (in_INIT) begin
            state = ITER;
            reg_LEDS_RST = 0;
            reg_LEDS_L = 1;
            out_FINISH = 0;
          end else begin
            state = START;
            reg_LEDS_RST = 1;
            reg_LEDS_L = 0;
            out_FINISH = 0;
          end
        end
      endcase
  end

  acumulador_restando #(
      .REG_WIDTH(7),
      .RST_VALUE(64),
      .LESS_VALUE(1)
  ) LEDS (
      .rst  (reg_LEDS_RST),
      .clk  (clk),
      .less (reg_LEDS_L),
      .out_K(w_K)
  );

endmodule
