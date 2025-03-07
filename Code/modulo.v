module modulo (
    input rst, clk,

    input [15:0]    Zahl1_i, Zahl2_i,
    input           modulo_start_i,

    output wire [15:0] ergebnis,
    output wire modulo_ready_o
);

    reg [15:0]  Zahl1_r, Zahl2_r, Zahl1_temp, Zahl2_temp;
    reg         start_r;
    reg         running = 'd0;
    reg [15:0]  ergebnis_intern;
    reg         modulo_ready_intern;

    reg [15:0] ergebnis_next;
    reg        modulo_ready_next;
    reg        running_next;



always @(posedge clk) begin
    if (rst) begin
        Zahl1_r         <= 'd0;
        Zahl2_r         <= 'd0;
        Zahl1_temp      <= 'd0;
        Zahl2_temp      <= 'd0;
    end else begin
        Zahl1_temp      <= Zahl1_i;
        Zahl2_temp      <= Zahl2_i;
        start_r         <= modulo_start_i;

    end

end


always @(posedge clk) begin
    $display("Schleife wird durchlaufen");
    if (start_r == 1'b1 && running == 1'b0) begin
        Zahl1_r = Zahl1_temp;
        Zahl2_r = Zahl2_temp;
        running         = 1'b1;
        modulo_ready_intern  = 1'b0;
        ergebnis_intern = Zahl1_r;
        $display("Start wird durchlaufen");
    end
    if (running == 1'b1) begin
        $display("Running an");
        if (ergebnis_intern >= Zahl2_r) begin
            ergebnis_intern = ergebnis_intern - Zahl2_r;
            
        end 
        
        else begin
            running                 = 1'b0;
            modulo_ready_intern     = 1'b1;
            $display("Running aus");
        end
    end
end

/* 
always @(*) begin
        ergebnis_next = ergebnis;
        modulo_ready_next = modulo_ready_o;
        running_next = running;

       if (start_r == 1'b1 && running == 1'b0) begin
        Zahl1_r = Zahl1_temp;
        Zahl2_r = Zahl2_temp;
        running         = 1'b1;
        modulo_ready_intern  = 1'b0;
        ergebnis_intern = Zahl1_r;
        $display("Start wird durchlaufen");
    end
    if (running == 1'b1) begin
        $display("Running an");
        if (ergebnis_intern >= Zahl2_r) begin
            ergebnis_intern = ergebnis_intern - Zahl2_r;
            
        end 
        
        else begin
            running                 = 1'b0;
            modulo_ready_intern     = 1'b1;
            $display("Running aus");
        end
    end
    end
 */


assign modulo_ready_o = modulo_ready_intern;
assign ergebnis = ergebnis_intern;
    
endmodule