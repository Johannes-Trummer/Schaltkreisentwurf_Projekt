module datapath_modulo (
    input           rst_i,
    input           clk,

    input           start_i,

    input   [15:0]  Zahl1_i, Zahl2_i,

    input   [2:0]   alu_mode_i,

    //===Write-Back-Flags===
    input wren_Zahl1_to_erg,
    input wren_res_to_erg,
    input wren_term_erg,

    input wren_update_Zahlen,



    //===Register-Transfer===
    input erg_to_alu_a, 
    input Zahl2_to_alu_b,


    input check_for_termination_i,
    output wire [15:0]   ergebnis,
    output wire          valid_o
);

    //reg running = 'd0;

//===Interne Busse==========================
    reg signed [15:0] 	alu_a_temp, alu_b_temp;
    wire signed [15:0]  wbb;

 //===ALU Ausgangsregister alu_c_r===========
    reg 	signed [15:0] alu_c_r;
    wire signed [15:0] alu_c;


//===Variablenregister======================
    reg [15:0]  Zahl1_r, Zahl2_r, Zahl1_i_r, Zahl2_i_r, Zahl1_temp, Zahl2_temp;
    reg [15:0]  ergebnis_r, ergebnis_temp;
    reg         termination_erg_temp, termination_erg_r;
	 //reg 				start_r;
	 
//===ALU-Instanziierung==========

alu_modulo alu(
 .rst(rst_i), 
 .clk(clk), 
 .alu_mode_i(alu_mode_i),
 .op_a_i(alu_a_temp),
 .op_b_i(alu_b_temp),
 .res_o(alu_c)

);

always @(posedge clk) begin
    if (rst_i) begin
        Zahl1_i_r          <= 'd0;
        Zahl2_i_r          <= 'd0;

        ergebnis_r          <= 'd0;
        termination_erg_r   <= 'd0;

        Zahl1_r             <= 'd0;
        Zahl2_r             <= 'd0;
    end else begin
        Zahl1_i_r          <= Zahl1_i;
        Zahl2_i_r          <= Zahl2_i;

        ergebnis_r          <= ergebnis_temp;
        termination_erg_r   <= termination_erg_temp;

        alu_c_r             <= alu_c;

        Zahl1_r             <= Zahl1_temp;
        Zahl2_r             <= Zahl2_temp;
    end
end


always @(*) begin

		alu_a_temp 			= 'd0;
		alu_b_temp 			= 'd0;

		ergebnis_temp           = ergebnis_r;
		termination_erg_temp    = termination_erg_r;

    

    //===Write-Back-Flags===
    if (wren_update_Zahlen) begin
        Zahl1_temp = Zahl1_i_r;
        Zahl2_temp = Zahl2_i_r;
    end

    if (wren_Zahl1_to_erg) begin
        ergebnis_temp = Zahl1_r;
    end

    if (wren_term_erg) begin
        termination_erg_temp = wbb[0];
    end

    if (wren_res_to_erg) begin
        ergebnis_temp = wbb;
    end

    //===Register-Transfer==============

    if (erg_to_alu_a) begin
        alu_a_temp = ergebnis_r;
    end

    if (Zahl2_to_alu_b) begin
        alu_b_temp = Zahl2_r;
    end

end

assign wbb      = alu_c_r;
assign valid_o  = check_for_termination_i & (termination_erg_r);
assign ergebnis = ergebnis_r;
    
endmodule