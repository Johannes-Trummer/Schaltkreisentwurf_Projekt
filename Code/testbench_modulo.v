module testbench_modulo (


);

    reg clk = 'd0;
    reg rst;
    reg start_i = 'd0;

    wire [15:0]  ergebnis;
    wire valid;
    reg [15:0] Zahl1 = 16'd24255;
    reg [15:0] Zahl2 = 16'd9540;

    modulo_top modulo_top(

    	.rst_i(rst), 
        .clk(clk), 
        .start_i(start_i),
    	.Zahl1_i(Zahl1), 
        .Zahl2_i(Zahl2),
    	.valid_o(valid),
    	.ergebnis_o(ergebnis)
    );

    initial begin
        #5  start_i = 1'd1;
            rst     = 1'd1;
        #2  rst     = 1'd0;  
        #10 start_i = 1'd0;  
    	
    end

    always
    #5 clk = !clk;



endmodule