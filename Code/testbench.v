module testbench(
    
);

    reg     [15:0]  Zahl1       = 16'd356;
    reg     [15:0]  Zahl2       = 16'd238;

    wire    [15:0]  ergebnis    = 'd0;     

    wire            start       = 'd0;
    wire            clk         = 'd0;
    wire            rst         = 'd0;


    top top(
        .clk(clk), 
        .rst(rst), 
        .start_i(start),

        .Zahl1_i(Zahl1), 
        .Zahl2_i(Zahl2),
        .ergebnis(ergebnis)
    );


    initial begin
        clk = 1'b0:

        #20     start     = 1'b1;
        #5      start     = 1'b0;


    end

    always 
    #5 clk = !clk;



    
endmodule