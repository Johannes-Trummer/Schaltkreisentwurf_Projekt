module datapath (

    input           rst,
    input           clk,
    input           modulo_start_i,

    input           start_i,

    input   [15:0]  Zahl1_i, Zahl2_i,

    input   [2:0]   alu_mode_i,

    //===Write-Back-Flags===
    input wren_zw_gross,
    input wren_zw_klein,
    input wren_zw_in_zahlen,
    input wren_erg_modulo,
    input wren_Zahl,
    input wren_to_new_numbers,

//===Register-Transfer===
    input Zahl1_to_alu_a,
    input Zahl2_to_alu_b,

    input check_for_termination_i,

    output              valid_o,
    output wire [15:0]  ergebnis,
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
    reg             start_r;           

    //===ALU-Instanziierung====================

    alu alu(
        .rst(rst),
        .clk(clk),
        .alu_mode_i(alu_mode_i),
        .op_a_i(alu_a_temp),
        .op_b_i(alu_b_temp),
        .res_o(alu_c),

        .modulo_start_i(modulo_start_i),
        .modulo_ready_o(modulo_ready_o)
    );


    always @(posedge clk) begin
        if (rst) begin
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
            start_r             <= start_i;
        end     
    
    end


    always @(*) begin

			alu_a_temp 			= 'd0;
			alu_b_temp 			= 'd0;

        erg_modulo_temp     = erg_modulo_r;
        erg_zuvor_temp      = erg_zuvor_r;
        zwischen_gross_temp = zwischen_gross_r;
        zwischen_klein_temp = zwischen_klein_r;

        if (start_r) begin
            Zahl1_r = Zahl1_temp;
            Zahl2_r = Zahl2_temp;
        end

        //===Write-Back-Logic==========
        if (wren_zw_gross) begin
            zwischen_gross_temp = wbb;
        end

        else if (wren_zw_klein) begin
            zwischen_klein_temp = wbb;
        end

        else if (wren_zw_in_zahlen) begin
            Zahl1_r         = zwischen_gross_r;
            Zahl2_r         = zwischen_klein_r;
            erg_zuvor_r     = zwischen_klein_r;
        end

        else if (wren_erg_modulo) begin
            erg_modulo_temp = wbb;
        end

        else if (wren_Zahl) begin
            Zahl1_r = Zahl2_r;
        end

        else if (wren_to_new_numbers) begin
            
            Zahl2_r = erg_modulo_r;
            erg_zuvor_r = erg_modulo_r;

        end

        //===Register-Transfer-Logic===
        if (Zahl1_to_alu_a) begin
            alu_a_temp = Zahl1_r;
        end
        if (Zahl2_to_alu_b) begin
            alu_b_temp = Zahl2_r;
        end
    
    end
    
assign wbb      = alu_c_r;
assign valid_o  = check_for_termination_i & (erg_modulo_r == 'd0);
assign ergebnis = erg_zuvor_r;


endmodule