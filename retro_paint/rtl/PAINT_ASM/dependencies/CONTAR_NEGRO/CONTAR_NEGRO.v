module CONTAR_NEGRO(
    clk,
    rst,
    init,
    CN
);

    input clk;
    input rst;
    input init;


    wire [23:0] cont_cursor;
    wire plus;
    wire rst_add;


    output wire CN;


    acumulador #(
        .WIDTH(24),
        .RST_VALUE(0),
        .PLUS_VALUE(1),
        .POS_EDGE(1)
    ) contador(
        .clk(clk),
        .rst(rst_add),
        .plus(plus),
        .value(cont_cursor)
    );

    control_contar_negro control_contar_negro(
        .clk(clk),
        .rst(rst),
        .init(init),
        .cont_cursor(cont_cursor),
        .CN(CN),
        .plus(plus),
        .out_rst(rst_add)
    );


endmodule