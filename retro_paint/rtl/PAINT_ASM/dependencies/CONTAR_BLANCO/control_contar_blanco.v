module control_contar_blanco(
    clk,
    rst,
    init,
    cont_cursor,
    CB,
    plus,
    out_rst
);

    input clk;
    input rst;
    input init;
    input [23:0] cont_cursor;

    output wire plus;
    output wire out_rst;
    output reg CB;

    parameter START = 2'b00;
    parameter ACC = 2'b01;
    parameter DONE = 2'b11;

    reg [3:0] state;
    reg [4:0] ST_TIMER_DONE;

    parameter timer = 5'd24;

    always @(posedge clk) begin
        if (rst) begin
            state = START;
            ST_TIMER_DONE = timer;
        end else begin
            case (state)

                START: begin
                    ST_TIMER_DONE = timer;
                    state = init ? ACC : START;
                end  

                ACC: begin
                    if (cont_cursor == 24'b010011000100101101000000) begin
                        state = DONE;
                    end
                    else state = ACC;
                end

                DONE: begin
                    if (ST_TIMER_DONE == 0) begin
                        state = START;
                    end
                    else begin
                        ST_TIMER_DONE = ST_TIMER_DONE - 1;
                        state = DONE;
                    end
                end

                default: state = START;

            endcase
        end
        
    end

    always @(*) begin
        case (state)
            START: begin
                plus = 0;
                CB = 0;
                out_rst = 1;
            end
            
            ACC: begin
                plus = 1;
                CB = 0;
                out_rst = 0;
            end

            DONE: begin
                plus = 0;
                CB = 1;
                out_rst = 0;
            end

        endcase 
    end 

    `ifdef BENCH
        reg [8*40:1] state_name;
        always @(*) begin
            case (state)
            START:   state_name    = "START";
            ACC:   state_name    = "ACC";
            DONE:    state_name    = "DONE";
            endcase

        end
    `endif

endmodule