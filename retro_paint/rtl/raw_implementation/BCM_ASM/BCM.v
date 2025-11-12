module BCM #(
    parameter RESOLUTION = 4,
    parameter CYCLES_PER_TICK = 256,
    parameter BRIGHTNESS = 192//more is less bright
) (
    input  clk,
    input  rst,
    input  in_INIT,
    input  in_CONTINUE,
    output out_NEXT_PLANE,
    output out_FINISH,
    output out_HALF_WAY
);

  reg reg_NEXT_PLANE;
  assign out_NEXT_PLANE = reg_NEXT_PLANE;
  reg reg_FINISH;
  assign out_FINISH = reg_FINISH;
  reg reg_HALF_WAY;
  assign out_HALF_WAY = reg_HALF_WAY;
  reg [3:0] state;
  reg reg_RST;
  parameter START = 0;
  parameter TIMER_PLUS = 1;
  parameter NEXT = 2;
  parameter REST = 3;
  parameter FINISH = 4;

  always @(negedge clk) begin
    if (rst) begin
      reg_RST = 1;
      reg_TIMER_PLUS = 0;
      reg_NEXT_PLANE = 0;
      reg_PESO_PLUS = 0;
      reg_FINISH = 0;
      reg_HALF_WAY = 0;
      state = START;
    end else begin
      case (state)
        START: begin
          if (in_INIT) begin
            reg_RST = 0;
            reg_TIMER_PLUS = 1;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            reg_HALF_WAY = 0;
            state = TIMER_PLUS;
          end else begin
            reg_RST = 1;
            reg_TIMER_PLUS = 0;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            reg_HALF_WAY = 0;
            state = START;
          end
        end
        TIMER_PLUS: begin
          if (w_TIMER == (CYCLES_PER_TICK << (w_PESO))) begin
            reg_RST = 0;
            reg_TIMER_PLUS = 0;
            reg_NEXT_PLANE = 1;
            reg_PESO_PLUS = 1;
            reg_FINISH = 0;
            reg_HALF_WAY = 0;
            state = NEXT;
          end else if (w_TIMER >= ((CYCLES_PER_TICK - BRIGHTNESS) << (w_PESO))) begin
            reg_RST = 0;
            reg_TIMER_PLUS = 1;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            reg_HALF_WAY = 1;
            state = TIMER_PLUS;
          end else begin
            reg_RST = 0;
            reg_TIMER_PLUS = 1;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            reg_HALF_WAY = 0;
            state = TIMER_PLUS;
          end
        end
        NEXT: begin
          reg_RST = 0;
          reg_TIMER_PLUS = 0;
          reg_NEXT_PLANE = 0;
          reg_PESO_PLUS = 0;
          reg_FINISH = 0;
          reg_HALF_WAY = 0;
          state = REST;
        end
        REST: begin
          if (in_CONTINUE) begin
            if (w_PESO == RESOLUTION) begin
              reg_RST = 0;
              reg_TIMER_PLUS = 0;
              reg_NEXT_PLANE = 0;
              reg_PESO_PLUS = 0;
              reg_FINISH = 1;
              reg_HALF_WAY = 0;
              state = FINISH;
            end else begin
              reg_RST = 0;
              reg_TIMER_PLUS = 1;
              reg_NEXT_PLANE = 0;
              reg_PESO_PLUS = 0;
              reg_FINISH = 0;
              reg_HALF_WAY = 0;
              state = TIMER_PLUS;
            end
          end else begin
            reg_RST = 0;
            reg_TIMER_PLUS = 0;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            reg_HALF_WAY = 0;
            state = REST;
          end
        end
        default: begin
          reg_RST = 1;
          reg_TIMER_PLUS = 0;
          reg_NEXT_PLANE = 0;
          reg_PESO_PLUS = 0;
          reg_FINISH = 0;
          reg_HALF_WAY = 0;
          state = START;
        end
      endcase
    end
  end

  wire [12:0] w_TIMER;
  reg reg_TIMER_PLUS;
  acumulador #(
      .WIDTH(13),
      .POS_EDGE(1)
  ) acc_TIMER (
      .clk  (clk),
      .rst  (reg_RST | reg_NEXT_PLANE),
      .plus (reg_TIMER_PLUS),
      .value(w_TIMER)
  );

  wire [2:0] w_PESO;
  reg reg_PESO_PLUS;
  acumulador #(
      .WIDTH(3),
      .POS_EDGE(1)
  ) acc_PESO (
      .clk  (clk),
      .rst  (reg_RST),
      .plus (reg_PESO_PLUS),
      .value(w_PESO)
  );

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START:      state_name = "START";
      TIMER_PLUS: state_name = "TIMER_PLUS";
      NEXT:       state_name = "NEXT";
      REST:       state_name = "REST";
      FINISH:     state_name = "FINISH";
    endcase
  end
`endif
endmodule
