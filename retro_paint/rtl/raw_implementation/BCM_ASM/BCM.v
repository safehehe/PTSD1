module BCM #(
    parameter RESOLUTION = 16,
    parameter CYCLES_PER_TICK = 512
) (
    input  clk,
    input  rst,
    input  in_INIT,
    input  in_CONTINUE,
    output out_NEXT_PLANE,
    output out_FINISH
);

  reg reg_NEXT_PLANE;
  assign out_NEXT_PLANE = reg_NEXT_PLANE;
  reg reg_FINISH;
  assign out_FINISH = reg_FINISH;

  reg [3:0] state;
  reg reg_RST;
  parameter START = 0;
  parameter TIMER_PLUS = 1;
  parameter NEXT = 2;
  parameter REST = 3;
  parameter FINISH = 4;

  parameter TIME_PESO1 = 1 * CYCLES_PER_TICK;
  parameter TIME_PESO2 = 2 * CYCLES_PER_TICK;
  parameter TIME_PESO4 = 4 * CYCLES_PER_TICK;
  parameter TIME_PESO8 = 8 * CYCLES_PER_TICK;

  always @(posedge clk) begin
    if (rst) begin
      reg_RST = 1;
      reg_TIMER_PLUS = 0;
      reg_NEXT_PLANE = 0;
      reg_PESO_PLUS = 0;
      reg_FINISH = 0;
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
            state = TIMER_PLUS;
          end else begin
            reg_RST = 1;
            reg_TIMER_PLUS = 0;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
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
            state = NEXT;
          end else begin
            reg_RST = 0;
            reg_TIMER_PLUS = 1;
            reg_NEXT_PLANE = 0;
            reg_PESO_PLUS = 0;
            reg_FINISH = 0;
            state = TIMER_PLUS;
          end
        end
        NEXT: begin
          reg_RST = 0;
          reg_TIMER_PLUS = 0;
          reg_NEXT_PLANE = 0;
          reg_PESO_PLUS = 0;
          reg_FINISH = 0;
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
              state = FINISH;
            end else begin
              reg_RST = 0;
              reg_TIMER_PLUS = 1;
              reg_NEXT_PLANE = 0;
              reg_PESO_PLUS = 0;
              reg_FINISH = 0;
              state = TIMER_PLUS;
            end
          end
        end
        default: begin
          reg_RST = 1;
          reg_TIMER_PLUS = 0;
          reg_NEXT_PLANE = 0;
          reg_PESO_PLUS = 0;
          reg_FINISH = 0;
          state = START;
        end
      endcase
    end
  end

  wire [12:0] w_TIMER;
  reg reg_TIMER_PLUS;
  acumulador #(
      .WIDTH(13)
  ) acc_TIMER (
      .clk  (clk),
      .rst  (reg_RST | reg_NEXT_PLANE),
      .plus (reg_TIMER_PLUS),
      .value(w_TIMER)
  );

  wire [3:0] w_PESO;
  reg reg_PESO_PLUS;
  acumulador #(
      .WIDTH(3)
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
      START:       state_name = "START";
      TIMER_PLUS:  state_name = "TIMER_PLUS";
      NEXT:        state_name = "NEXT";
      REST:        state_name = "REST";
      FINISH:      state_name = "FINISH";
    endcase
  end
`endif
endmodule
