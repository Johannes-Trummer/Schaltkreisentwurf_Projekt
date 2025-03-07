module modulo_top (

    input rst, clk, start_i,

    input   [15:0]  Zahl1_i, Zahl2_i,


    output valid_o,
    output reg [15:0]   ergebnis_o
);

    wire [2:0] alu_mode;
    wire [15:0] zwischen_ergebnis;
    wire        zwischen_valid;

    wire wren_Zahl2_to_erg, wren_res_to_erg, wren_term_erg, wren_update_Zahlen;
    wire erg_to_alu_a, Zahl2_to_alu_b;

    wire check_for_termination;

controller_modulo controller(
    .rst(rst),
    .clk(clk),
    .start_i(start_i),
    .valid_i(zwischen_valid),
    .alu_mode_o(alu_mode),


    .wren_Zahl1_to_erg(wren_Zahl2_to_erg),
    .wren_res_to_erg(wren_res_to_erg),
    .wren_term_erg(wren_term_erg),

    .wren_update_Zahlen(wren_update_Zahlen),

    .erg_to_alu_a(erg_to_alu_a),
    .Zahl2_to_alu_b(Zahl2_to_alu_b),
    .check_for_termination_o(check_for_termination)

);


datapath_modulo datapath(

    .rst(rst),
    .clk(clk),
    .start_i(start_i),
    .Zahl1_i(Zahl1_i), 
    .Zahl2_i(Zahl2_i),
    .alu_mode_i(alu_mode),

    .wren_Zahl1_to_erg(wren_Zahl2_to_erg),
    .wren_res_to_erg(wren_res_to_erg),
    .wren_term_erg(wren_term_erg),

    .wren_update_Zahlen(wren_update_Zahlen),
   

    .erg_to_alu_a(erg_to_alu_a), 
    .Zahl2_to_alu_b(Zahl2_to_alu_b),

    .check_for_termination_i(check_for_termination),
    .ergebnis(zwischen_ergebnis),
    .valid_o(zwischen_valid)
);

assign ergebnis_o = zwischen_ergebnis;
assign valid_o = zwischen_valid;

endmodule
