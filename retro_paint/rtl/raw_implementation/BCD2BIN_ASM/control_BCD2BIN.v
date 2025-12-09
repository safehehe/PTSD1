module control_BCD2BIN (
    input clk,
    input rst,
    input in_init,
    input in_K,
    input [3:0] in_UND,
    output reg out_RST,
    output reg out_LOAD,
    output reg out_SHIFT,
    output reg out_LESS,
    output reg out_DONE
);


  parameter START = 0;
  parameter SHIFT = 1;
  parameter CHECK = 2;
  parameter LOAD_UND = 3;
  parameter ITER = 4;
  parameter DONE = 5;
  reg [3:0] state;
  //parameter ST_TIMER_DONE = 5'd24;
  //reg [4:0] timer_done;

  always @(posedge clk) begin
    if (rst) begin
      state = START;
      //timer_done = ST_TIMER_DONE;
    end else
      case (state)
        START: begin
          state = in_init ? SHIFT : START;
          //timer_done = ST_TIMER_DONE;
        end
        SHIFT: state = CHECK;
        CHECK: state = in_UND[3] ? ITER : LOAD_UND;
        LOAD_UND: state = ITER;
        ITER: state = in_K ? DONE : SHIFT;
        DONE: begin
          state = START;
          /*if (timer_done == 0) begin
            state = START;
          end else begin
            timer_done = timer_done - 1;
            state = DONE;
          end*/
        end
        default: state = START;
      endcase
  end

  always @(*) begin
    case (state)
      START: begin
        out_RST   = 1;
        out_LOAD  = 0;
        out_SHIFT = 0;
        out_LESS  = 0;
        out_DONE  = 0;
      end
      SHIFT: begin
        out_RST   = 0;
        out_LOAD  = 0;
        out_SHIFT = 1;
        out_LESS  = 0;
        out_DONE  = 0;
      end
      CHECK: begin
        out_RST   = 0;
        out_LOAD  = 0;
        out_SHIFT = 0;
        out_LESS  = 0;
        out_DONE  = 0;
      end
      LOAD_UND: begin
        out_RST   = 0;
        out_LOAD  = 1;
        out_SHIFT = 0;
        out_LESS  = 0;
        out_DONE  = 0;
      end
      ITER: begin
        out_RST   = 0;
        out_LOAD  = 0;
        out_SHIFT = 0;
        out_LESS  = 1;
        out_DONE  = 0;
      end
      DONE: begin
        out_RST   = 0;
        out_LOAD  = 0;
        out_SHIFT = 0;
        out_LESS  = 0;
        out_DONE  = 1;
      end
      default: begin
        out_RST   = 1;
        out_LOAD  = 0;
        out_SHIFT = 0;
        out_LESS  = 0;
        out_DONE  = 0;
      end
    endcase
  end

`ifdef BENCH
  reg [8*40:1] state_name;
  always @(*) begin
    case (state)
      START: state_name = "START";
      SHIFT: state_name = "SHIFT";
      CHECK: state_name = "CHECK";
      LOAD_UND: state_name = "LOAD_UND";
      ITER: state_name = "ITER";
      DONE: state_name = "DONE";
    endcase
  end
`endif
endmodule
