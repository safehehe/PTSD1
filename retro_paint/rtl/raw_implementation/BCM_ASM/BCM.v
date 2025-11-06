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
  parameter CHECK_TIMER = 2;
  parameter NEXT = 3;
  parameter REST = 4;
  parameter CHECK_PESO = 5;
  parameter FINISH = 6;


  always @(posedge clk) begin
    if (rst) state = START;
    else begin
      case (state)
        START: state = in_INIT ? TIMER_PLUS : START;
        TIMER_PLUS: state = CHECK_TIMER;
        CHECK_TIMER: begin
          state = w_TIMER == w_PESO*CYCLES_PER_TICK ? NEXT : TIMER_PLUS;
        end
        NEXT: state = REST;
        REST: state = in_CONTINUE ? CHECK_PESO : REST;
        CHECK_PESO: state = w_PESO == RESOLUTION ? FINISH : TIMER_PLUS;
        default: state = START;
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
  reg reg_PESO_SHIFT;
  LSR #(
      .WIDTH(4),
      .RST_VALUE(1),
      .PARALLEL_OUTPUT(1)
  ) lsr_PESO (
      .clk     (clk),
      .rst     (reg_RST),
      .in_DATA (1'b0),
      .in_SHIFT(reg_PESO_SHIFT),
      .in_LOAD (1'b0),
      .out_DATA(w_PESO)
  );

  always @(*) begin
    case (state)
      START: begin
        reg_RST = 1;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
      TIMER_PLUS: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 1;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
      CHECK_TIMER: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
      NEXT: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 1;
        reg_PESO_SHIFT = 1;
        reg_FINISH = 0;
      end
      REST: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
      CHECK_PESO: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
      FINISH: begin
        reg_RST = 0;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 1;
      end
      default: begin
        reg_RST = 1;
        reg_TIMER_PLUS = 0;
        reg_NEXT_PLANE = 0;
        reg_PESO_SHIFT = 0;
        reg_FINISH = 0;
      end
    endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START:       state_name = "START";
      TIMER_PLUS:  state_name = "TIMER_PLUS";
      CHECK_TIMER: state_name = "CHECK_TIMER";
      NEXT:        state_name = "NEXT";
      REST:        state_name = "REST";
      CHECK_PESO:  state_name = "CHECK_PESO";
      FINISH:      state_name = "FINISH";
    endcase
  end
`endif
endmodule
