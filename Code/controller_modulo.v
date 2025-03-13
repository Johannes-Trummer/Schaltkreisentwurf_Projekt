module controller_modulo (
    input           rst_i,
    input           clk,
    input           start_i,
    input           valid_i,

    output reg [2:0]    alu_mode_o,

    output reg wren_Zahl1_to_erg_o,
    output reg wren_res_to_erg_o,
    output reg wren_term_erg_o,

    output reg wren_update_Zahlen_o,

    output reg erg_to_alu_a_o,
    output reg Zahl2_to_alu_b_o,

    output reg check_for_termination_o
);

    
    
//===Schritte====
localparam STATE_update     = 4'd0;
localparam STATE_write_init = 4'd1;
localparam STATE_compare    = 4'd2;
localparam STATE_write_comp = 4'd3;
localparam STATE_check_term = 4'd4;
localparam STATE_diff       = 4'd5;
localparam STATE_write      = 4'd6;
localparam STATE_IDLE       = 4'd7;


//===ALU-Kommandos===
localparam ALU_compare      = 3'd0;
localparam ALU_Diff         = 3'd1;
localparam ALU_IDLE         = 3'd2;

//===Schrittregister============
reg [3:0] 			current_state, next_state;
reg                 start_r, valid_r;   


always @(posedge clk) begin
    if (rst_i) begin
        valid_r         <= 1'd0;
        start_r         <= 1'd0;
        current_state   <= STATE_IDLE;
    end
    else begin
        valid_r         <= valid_i;
        start_r         <= start_i;
        current_state   <= next_state;
    end
end

always @(*) begin

    alu_mode_o                  = ALU_IDLE;
    next_state                  = current_state;
    check_for_termination_o     = 'b0;

    //===Write-Back-Flags===
    wren_Zahl1_to_erg_o   = 'd0;
    wren_res_to_erg_o     = 'd0;
    wren_term_erg_o       = 'd0;

    wren_update_Zahlen_o  = 'd0;
   
    
    //===Register-Transfer===
    erg_to_alu_a_o    = 'd0;
    Zahl2_to_alu_b_o  = 'd0;

    case (current_state)

        STATE_IDLE: begin
            
            if (start_r) begin
                next_state = STATE_update;
            end
        end

        STATE_update: begin
            next_state = STATE_write_init;
            wren_update_Zahlen_o = 1'd1;
        end

        STATE_write_init: begin
            next_state = STATE_compare;
            wren_Zahl1_to_erg_o = 1'd1;
        end


        STATE_compare: begin
            erg_to_alu_a_o    = 1'd1;
            Zahl2_to_alu_b_o  = 1'd1;

            next_state = STATE_write_comp;
            alu_mode_o = ALU_compare;
        end 

        STATE_write_comp: begin
            next_state = STATE_check_term;
            wren_term_erg_o = 1'd1;

        end

        STATE_check_term: begin
            next_state = STATE_diff;
            check_for_termination_o = 1'd1;

        end
        
        STATE_diff: begin
            next_state = STATE_write;

            erg_to_alu_a_o    = 1'd1;
            Zahl2_to_alu_b_o  = 1'd1;
            alu_mode_o = ALU_Diff;
        end

        STATE_write: begin
            next_state = STATE_compare;
            wren_res_to_erg_o = 1'd1;
        end


    endcase

    if (valid_r == 1'b1) begin
        next_state = STATE_IDLE;
        $display("Valid-Abfrage im Controller aktiv");
    end

end

endmodule