module testbench(
    
);

    reg     [15:0]  Zahl1       = 16'd24255;
    reg     [15:0]  Zahl2       = 16'd12540;

    wire    [15:0]  ergebnis;     

    reg             start       = 'd0;
    reg             clk         = 'd0;
    reg             rst         = 'd0;

    wire            valid;


    top top(
        .clk(clk), 
        .rst(rst), 
        .start_i(start),

        .Zahl1_i(Zahl1), 
        .Zahl2_i(Zahl2),
        .ergebnis(ergebnis),
        .valid(valid)
    );


    initial begin
                clk = 1'b0;
                rst = 1'd1;
        #10     rst = 1'd0;

        #20     start     = 1'b1;
        #10      start     = 1'b0;


    end

    always 
    #5 clk = !clk;



    
endmodule