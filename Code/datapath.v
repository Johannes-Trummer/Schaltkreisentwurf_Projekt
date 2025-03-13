module datapath (

    input           rst_i,
    input           clk,
    input           modulo_start_i,

    input           start_i,

    input   [15:0]  Zahl1_i, Zahl2_i,

    input   [2:0]   alu_mode_i,

    //===Write-Back-Flags===
    input wren_zw_gross_i,
    input wren_zw_klein_i,
    input wren_zw_in_zahlen_i,
    input wren_erg_modulo_i,
    input wren_Zahl_i,
    input wren_to_new_numbers_i,
    input wren_initial_i,

//===Register-Transfer===
    input Zahl1_to_alu_a_i,
    input Zahl2_to_alu_b_i,

    input check_for_termination_i,

    output              valid_o,
    output wire [15:0]  ergebnis_o,
    output              modulo_ready_o
);

   

    //===Interne Busse==========================
    reg signed [15:0] 	alu_a_temp, alu_b_temp;
    wire signed [15:0]  wbb;

    //===ALU Ausgangsregister alu_c_r===========
    reg 	signed [15:0] alu_c_r;
    wire 	signed [15:0] alu_c;

    //===Variablenregister=======================
    reg     [15:0]  Zahl1_r, Zahl2_r, Zahl1_temp, Zahl2_temp;
    reg     [15:0]  erg_modulo_temp, erg_modulo_r, erg_zuvor_temp, erg_zuvor_r;
    reg     [15:0]  zwischen_gross_temp, zwischen_gross_r, zwischen_klein_temp, zwischen_klein_r;
    //reg             start_r;           

    //===ALU-Instanziierung====================

    alu alu(
        .rst_i(rst_i),
        .clk(clk),
        .alu_mode_i(alu_mode_i),
        .op_a_i(alu_a_temp),
        .op_b_i(alu_b_temp),
        .res_o(alu_c),

        .modulo_start_i(modulo_start_i),
        .modulo_ready_o(modulo_ready_o)
    );


    always @(posedge clk) begin
        if (rst_i) begin
            Zahl1_temp          <= 'd0;
            Zahl2_temp          <= 'd0;
            //Zahl1_r             <= 'd0;
            //Zahl2_r             <= 'd0;
            erg_modulo_r        <= 'd0;
            //erg_zuvor_r         <= 'd0;
            zwischen_gross_r    <= 'd0;
            zwischen_klein_r    <= 'd0;
            alu_c_r             <= 'd0;
        end else begin
            Zahl1_temp          <= Zahl1_i;
            Zahl2_temp          <= Zahl2_i;
            erg_modulo_r        <= erg_modulo_temp;
            erg_zuvor_r         <= erg_zuvor_temp;
            zwischen_gross_r    <= zwischen_gross_temp;
            zwischen_klein_r    <= zwischen_klein_temp;
            alu_c_r             <= alu_c;
            //start_r             <= start_i;
        end     
    
    end


    always @(*) begin

			alu_a_temp 			= 'd0;
			alu_b_temp 			= 'd0;

        erg_modulo_temp     = erg_modulo_r;
        erg_zuvor_temp      = erg_zuvor_r;
        zwischen_gross_temp = zwischen_gross_r;
        zwischen_klein_temp = zwischen_klein_r;

        
        //===Write-Back-Logic==========
        if (wren_zw_gross_i) begin
            zwischen_gross_temp = wbb;
        end

        else if (wren_zw_klein_i) begin
            zwischen_klein_temp = wbb;
        end

        else if (wren_zw_in_zahlen_i) begin
            Zahl1_r         = zwischen_gross_r;
            Zahl2_r         = zwischen_klein_r;
            erg_zuvor_temp     = zwischen_klein_r;
        end

        else if (wren_erg_modulo_i) begin
            erg_modulo_temp = wbb;
        end

        else if (wren_Zahl_i) begin
            Zahl1_r = Zahl2_r;
        end

        else if (wren_to_new_numbers_i) begin
            
            Zahl2_r = erg_modulo_r;
            erg_zuvor_temp = erg_modulo_r;

        end
        else if (wren_initial_i) begin
            Zahl1_r = Zahl1_temp;
            Zahl2_r = Zahl2_temp;
        end

        //===Register-Transfer-Logic===
        if (Zahl1_to_alu_a_i) begin
            alu_a_temp = Zahl1_r;
        end
        if (Zahl2_to_alu_b_i) begin
            alu_b_temp = Zahl2_r;
        end
    
    end
    
assign wbb      = alu_c_r;
assign valid_o  = check_for_termination_i & (erg_modulo_r == 'd0);
assign ergebnis_o = erg_zuvor_r;


endmodule