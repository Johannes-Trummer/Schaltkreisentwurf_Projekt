module datapath (

    input           rst,
    input           clk,

    input   [15:0]  Zahl1_i, Zahl2_i,

    input   [2:0]   alu_mode_i,

    //===Write-Back-Flags===
    input wren_zw_gross,
    input wren_zw_klein,
    input wren_zw_in_zahlen,
    input wren_erg_modulo,
    input wren_to_new_numbers,

//===Register-Transfer===
    input Zahl1_to_alu_a,
    input Zahl2_to_alu_b,
    input erg_modulo_to_alu_a,

    input check_for_termination_i
);


    //===Variablenregister=======================
    reg     [15:0]  Zahl1_r, Zahl2_r;
    


    //===ALU-Instanziierung====================

    alu alu(


    );


    always @(posedge clk) begin
        if (rst) begin
            Zahl1_r     <= 'd0;
            Zahl2_r     <= 'd0;
        end else begin
            Zahl1_r     <= Zahl1_i;
            Zahl2_r     <= Zahl2_i;
        end     
    
    end


    always @(*) begin
        
    end
    
endmodule