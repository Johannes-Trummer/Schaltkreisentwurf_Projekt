module top (

    input clk, rst, start_i,

    input   [15:0]  Zahl1_i, Zahl2_i,

    output  [15:0]  ergebnis
    
);

    wire valid, alu_mode;

    //===Write-Back-Flags===
    wire wren_zw_gross, wren_zw_klein, wren_zw_in_zahlen, wren_erg_modulo, wren_to_new_numbers;

    //===Register Transfer===
    wire Zahl1_to_alu_a, Zahl2_to_alu_b;

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
        .wren_to_new_numbers(wren_to_new_numbers),

        .Zahl1_to_alu_a(Zahl1_to_alu_a),
        .Zahl2_to_alu_b(Zahl2_to_alu_b),
        
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
        .wren_to_new_numbers(wren_to_new_numbers),

        .Zahl1_to_alu_a(Zahl1_to_alu_a),
        .Zahl2_to_alu_b(Zahl2_to_alu_b),
    
        .check_for_termination_i(check_for_termination),

        .valid_o(valid),
        .ergebnis(ergebnis)

    );


endmodule