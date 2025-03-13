module ggt_top (

    input                   clk, rst_i, start_i,

    input       [15:0]      Zahl1_i, Zahl2_i,

	 
	 
	 output wire              valid_o,
    output wire  [15:0]      ergebnis_o

    
    
);

    
    wire        [2:0]       alu_mode;
    wire        [15:0]      erg;

    //===Modulo-Flags===
    wire modulo_ready, modulo_start;

    //===Write-Back-Flags===
    wire wren_zw_gross, wren_zw_klein, wren_zw_in_zahlen, wren_erg_modulo, wren_Zahl, wren_to_new_numbers, wren_initial;

    //===Register Transfer===
    wire Zahl1_to_alu_a, Zahl2_to_alu_b; 
	 wire valid_w;

    //===Check for Termination===
    wire check_for_termination;


    controller controller(

        .rst_i(rst_i),
        .clk(clk),
        .start_i(start_i),
        .valid_i(valid_w),
        .alu_mode_o(alu_mode),

        .wren_zw_gross_o(wren_zw_gross),
        .wren_zw_klein_o(wren_zw_klein),
        .wren_zw_in_zahlen_o(wren_zw_in_zahlen),
        .wren_erg_modulo_o(wren_erg_modulo),
        .wren_Zahl_o(wren_Zahl),
        .wren_to_new_numbers_o(wren_to_new_numbers),
        .wren_initial_o(wren_initial),

        .Zahl1_to_alu_a_o(Zahl1_to_alu_a),
        .Zahl2_to_alu_b_o(Zahl2_to_alu_b),

        .modulo_ready_i(modulo_ready),
        .modulo_start_o(modulo_start),
        
        .check_for_termination_o(check_for_termination)

    );

    datapath datapath(

        .rst_i(rst_i),
        .clk(clk),
        .start_i(start_i),
        .Zahl1_i(Zahl1_i), 
        .Zahl2_i(Zahl2_i),
        .alu_mode_i(alu_mode),

        .wren_zw_gross_i(wren_zw_gross),
        .wren_zw_klein_i(wren_zw_klein),
        .wren_zw_in_zahlen_i(wren_zw_in_zahlen),
        .wren_erg_modulo_i(wren_erg_modulo),
        .wren_Zahl_i(wren_Zahl),
        .wren_to_new_numbers_i(wren_to_new_numbers),
        .wren_initial_i(wren_initial),

        .Zahl1_to_alu_a_i(Zahl1_to_alu_a),
        .Zahl2_to_alu_b_i(Zahl2_to_alu_b),
    
        .check_for_termination_i(check_for_termination),

        .modulo_ready_o(modulo_ready),
        .modulo_start_i(modulo_start),

        .valid_o(valid_w),
        .ergebnis_o(erg)

    );
assign ergebnis_o = erg;
assign valid_o = valid_w;

endmodule