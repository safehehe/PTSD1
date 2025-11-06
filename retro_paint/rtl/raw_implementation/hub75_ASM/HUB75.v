module HUB75 (
    input clk,
    input rstn,
    output [2:0] w_RGB0,
    output [2:0] w_RGB1,
    output w_SCREEN_CLOCK,
    output [4:0] ABCDE,
    output LATCH,
    output nOE
);
  reg [3:0] auto_init;
  reg [2:0] reg_RGB0;
  reg [2:0] reg_RGB1;
  reg [2:0] state;
  reg [4:0] reg_ABCDE;
  reg reg_LATCH;
  reg reg_nOE;
  assign nOE   = reg_nOE;
  assign LATCH = reg_LATCH;
  assign ABCDE = reg_ABCDE;
  parameter START = 0;
  parameter INIT_CLOCKER = 1;
  parameter CHECK = 2;
  parameter LATCHE = 3;
  parameter SHOW = 4;
  parameter NEXT = 5;

  always @(negedge clk) begin
    if (!rstn) begin
      reg_RGB0 = 3'b011;
      reg_RGB1 = 3'b101;
      state = START;
      auto_init = 4'b1111;
      reg_ABCDE = 0;
    end else begin
      case (state)
        START: begin
          if (auto_init == 0) begin
            state = INIT_CLOCKER;
          end else begin
            auto_init = auto_init - 1;
            state = START;
          end
        end
        INIT_CLOCKER: state = CHECK;
        CHECK: begin
          state = w_CLOCKER_FINISH ? LATCHE : CHECK;
        end
        LATCHE: state = SHOW;
        SHOW: state = NEXT;
        NEXT: begin
          state = INIT_CLOCKER;
          reg_ABCDE = reg_ABCDE + 1;
        end
        default: state = START;
      endcase
    end
  end

  always @(*) begin
    case (state)
      START: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 1;
        reg_LATCH = 0;
        reg_nOE = 1;
      end
      INIT_CLOCKER: begin
        reg_CLOCKER_INIT = 1;
        reg_CLOCKER_RST = 0;
        reg_LATCH = 0;
        reg_nOE = 1;
      end
      CHECK: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 0;
        reg_LATCH = 0;
        reg_nOE = 1;
      end
      LATCHE: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 0;
        reg_LATCH = 1;
        reg_nOE = 1;
      end
      SHOW: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 1;
        reg_LATCH = 0;
        reg_nOE = 0;
      end
      NEXT: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 0;
        reg_LATCH = 0;
        reg_nOE = 0;
      end
      default: begin
        reg_CLOCKER_INIT = 0;
        reg_CLOCKER_RST = 1;
        reg_LATCH = 0;
        reg_nOE = 1;
      end
    endcase
  end

  reg  reg_CLOCKER_RST;
  reg  reg_CLOCKER_INIT;
  wire w_CLOCKER_FINISH;
  wire w_CLOCKER_ITER;
  RGB_clocker CLOCKER (
      .clk       (clk),
      .rst       (reg_CLOCKER_RST),
      .in_INIT   (reg_CLOCKER_INIT),
      .in_RGB0   (reg_RGB0),
      .in_RGB1   (reg_RGB1),
      .out_FINISH(w_CLOCKER_FINISH),
      .out_ITER  (w_CLOCKER_ITER),
      .out_RGB0  (w_RGB0),
      .out_RGB1  (w_RGB1),
      .S_CLOCK   (w_SCREEN_CLOCK)
  );

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START:        state_name = "START";
      INIT_CLOCKER: state_name = "INIT_CLOCKER";
      CHECK:        state_name = "CHECK";
      LATCHE:       state_name = "LATCHE";
      SHOW:         state_name = "SHOW";
      NEXT:         state_name = "NEXT";
    endcase
  end
`endif

endmodule
