module controller(

    input           rst_i,
    input           clk,
    input           start_i,
    input           valid_i,
    input           modulo_ready_i,

    output reg [2:0]    alu_mode_o,

//===Write-Back-Flags===
    output reg wren_zw_gross_o,
    output reg wren_zw_klein_o,
    output reg wren_zw_in_zahlen_o,
    output reg wren_erg_modulo_o,
    output reg wren_Zahl_o, 
    output reg wren_to_new_numbers_o,
    output reg wren_initial_o,

//===Register-Transfer===
    output reg Zahl1_to_alu_a_o,
    output reg Zahl2_to_alu_b_o,

    output reg check_for_termination_o,

    output reg modulo_start_o

);

//===Schritte================
localparam STATE_initial_write            = 4'd0;
localparam STATE_find_bigger              = 4'd1;
localparam STATE_find_smaller             = 4'd2;
localparam STATE_write_both               = 4'd3;
localparam STATE_write_zwischenspeicher   = 4'd4;

localparam STATE_calc                     = 4'd5; //iterative Schritte des Algorithmus
localparam STATE_write_erg                = 4'd6;
localparam STATE_check_if_zero            = 4'd7;
localparam STATE_write_Zahl               = 4'd8;
localparam STATE_write_numbers            = 4'd9;
localparam STATE_IDLE                     = 4'd10;


//===ALU_Kommandos============
localparam ALU_give_back_bigger     = 3'd0;
localparam ALU_give_back_smaller    = 3'd1;
localparam ALU_modulo           		= 3'd2;
localparam ALU_IDLE             		= 3'd3;


//===Schrittregister============
reg [3:0] 			current_state, next_state;
reg                 start_r, valid_r; //valid_r;      



always @(posedge clk) begin
    if (rst_i) begin
        valid_r         <= 1'd0;
        start_r         <= 1'd0;
        current_state   <= STATE_IDLE;
        //modulo_ready_r  <= 1'd0;
    end
    else begin
        valid_r         <= valid_i;
        start_r         <= start_i;
        current_state   <= next_state;
        //modulo_ready_r  <= modulo_ready_i;
    end
end

always @(*) begin

    alu_mode_o                  = ALU_IDLE;
    next_state                  = current_state;
    check_for_termination_o     = 'b0;

    modulo_start_o = 1'd0;

//===Write-Back-Flags===
    wren_zw_gross_o               = 'b0;    
    wren_zw_klein_o               = 'b0;    
    wren_zw_in_zahlen_o           = 'b0;        
    wren_erg_modulo_o             = 'b0;    
    wren_Zahl_o                   = 'b0;
    wren_to_new_numbers_o         = 'b0;   
    wren_initial_o                  = 'b0;     

//===Register-Transfer===
    Zahl1_to_alu_a_o              = 'b0;     
    Zahl2_to_alu_b_o              = 'b0;     
           





    case (current_state)


        STATE_IDLE: begin
            if (start_r == 1'b1) begin
                next_state = STATE_initial_write;
            end
        end    

        STATE_initial_write: begin
            next_state = STATE_find_bigger;
            wren_initial_o = 1'b1;
        end


        STATE_find_bigger: begin              //1
            next_state = STATE_find_smaller;

            Zahl1_to_alu_a_o = 1'b1;
            Zahl2_to_alu_b_o = 1'b1;

            alu_mode_o = ALU_give_back_bigger;
        end


        STATE_find_smaller: begin             //2
            next_state = STATE_write_both;

            Zahl1_to_alu_a_o = 1'b1;
            Zahl2_to_alu_b_o = 1'b1;

            wren_zw_gross_o = 1'b1;
        
            alu_mode_o = ALU_give_back_smaller;
        end


        STATE_write_both: begin               //3
            next_state = STATE_write_zwischenspeicher;

            wren_zw_klein_o = 1'b1;
            
        end

        STATE_write_zwischenspeicher: begin
            next_state = STATE_calc;

            wren_zw_in_zahlen_o = 1'b1;
        end


    
        STATE_calc: begin                     //4

            if (modulo_ready_i == 1'b1) begin
                next_state = STATE_write_erg;
            end
            
            Zahl1_to_alu_a_o = 1'b1;
            Zahl2_to_alu_b_o = 1'b1;

            alu_mode_o = ALU_modulo;
            modulo_start_o = 1'd1;
        end

        STATE_write_erg: begin            //5
            next_state = STATE_check_if_zero;

            wren_erg_modulo_o = 1'b1;
        end

        STATE_check_if_zero: begin
            next_state = STATE_write_Zahl;

            check_for_termination_o = 1'd1;
        end

        STATE_write_Zahl: begin
            next_state = STATE_write_numbers;
            
            wren_Zahl_o = 1'b1;
        end

        STATE_write_numbers: begin            //7
            next_state = STATE_calc;

            wren_to_new_numbers_o = 1'b1;
        end

    endcase

    if (valid_i == 1'b1) begin
        next_state = STATE_IDLE;
    end
end








endmodule