module top (

    input                   clk, rst, start_i,

    input       [15:0]      Zahl1_i, Zahl2_i,

    output reg  [15:0]      ergebnis,

    output reg              valid
    
);

    
    wire        [2:0]       alu_mode;
    wire        [15:0]      erg;

    //===Modulo-Flags===
    wire modulo_ready, modulo_start;

    //===Write-Back-Flags===
    wire wren_zw_gross, wren_zw_klein, wren_zw_in_zahlen, wren_erg_modulo, wren_Zahl, wren_to_new_numbers;

    //===Register Transfer===
    wire Zahl1_to_alu_a, Zahl2_to_alu_b, valid_w;

    //===Check for Termination===
    wire check_for_termination;


    controller controller(

        .rst(rst),
        .clk(clk),
        .start_i(start_i),
        .valid_i(valid),
        .alu_mode_o(alu_mode),

        .wren_zw_gross(wren_zw_gross),
        .wren_zw_klein(wren_zw_klein),
        .wren_zw_in_zahlen(wren_zw_in_zahlen),
        .wren_erg_modulo(wren_erg_modulo),
        .wren_Zahl(wren_Zahl),
        .wren_to_new_numbers(wren_to_new_numbers),

        .Zahl1_to_alu_a(Zahl1_to_alu_a),
        .Zahl2_to_alu_b(Zahl2_to_alu_b),

        .modulo_ready_i(modulo_ready),
        .modulo_start_o(modulo_start),
        
        .check_for_termination_o(check_for_termination)

    );

    datapath datapath(

        .rst(rst),
        .clk(clk),
        .start_i(start_i),
        .Zahl1_i(Zahl1_i), 
        .Zahl2_i(Zahl2_i),
        .alu_mode_i(alu_mode),

        .wren_zw_gross(wren_zw_gross),
        .wren_zw_klein(wren_zw_klein),
        .wren_zw_in_zahlen(wren_zw_in_zahlen),
        .wren_erg_modulo(wren_erg_modulo),
        .wren_Zahl(wren_Zahl),
        .wren_to_new_numbers(wren_to_new_numbers),

        .Zahl1_to_alu_a(Zahl1_to_alu_a),
        .Zahl2_to_alu_b(Zahl2_to_alu_b),
    
        .check_for_termination_i(check_for_termination),

        .modulo_ready_o(modulo_ready),
        .modulo_start_i(modulo_start),

        .valid_o(valid_w),
        .ergebnis(erg)

    );
assign ergebnis = erg;
assign valid = valid_w;

endmodule