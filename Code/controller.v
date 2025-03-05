module controller(

    input           rst,
    input           clk,
    input           start_i,
    input           valid_i,

    output reg [2:0]    alu_mode_o,

//===Write-Back-Flags===
    output reg wren_zw_gross,
    output reg wren_zw_klein,
    output reg wren_zw_in_zahlen,
    output reg wren_erg_modulo,
    output reg wren_to_new_numbers,

//===Register-Transfer===
    output reg Zahl1_to_alu_a,
    output reg Zahl2_to_alu_b,

    output reg check_for_termination_o

);

//===Schritte================
localparam find_bigger      = 4'b0;
localparam find_smaller     = 4'b1;
localparam write_both       = 4'b2;

localparam calc             = 4'b3; //iterative Schritte des Algorithmus
localparam check_if_zero    = 4'b4;
localparam write_numbers    = 4'b5;
localparam IDLE             = 4'b6;


//===ALU_Kommandos============
localparam give_back_bigger     = 3'b0;
localparam give_back_smaller    = 3'b1;
localparam modulo               = 3'b2;
localparam ALU_IDLE                 = 3'b3;


//===Schrittregister============
reg [3:0] 			current_state, next_state;
reg                 start_r, valid_r;      



always @(posedge clk) begin
    if (rst) begin
        valid_r         <= 0;
        start_r         <= 0;
        current_state   <= IDLE;
    end
    else if begin
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
    wren_zw_gross               = 'b0;    
    wren_zw_klein               = 'b0;    
    wren_zw_in_zahlen           = 'b0;        
    wren_erg_modulo             = 'b0;    
    wren_to_new_numbers         = 'b0;        

//===Register-Transfer===
    Zahl1_to_alu_a              = 'b0;     
    Zahl2_to_alu_b              = 'b0;     
    erg_modulo_to_alu_a         = 'b0;         





    case (current_state)


        IDLE: begin
            if (start_r == 1'b1) begin
                next_state = find_bigger;
            end
        end    


        find_bigger: begin              //1
            next_state = find_smaller;

            Zahl1_to_alu_a = 1'b1;
            Zahl2_to_alu_b = 1'b1;

            wren_zw_gross = 1'b1;

            alu_mode_o = give_back_bigger;
        end


        find_smaller: begin             //2
            next_state = write_both;

            Zahl1_to_alu_a = 1'b1;
            Zahl2_to_alu_b = 1'b1;

            wren_zw_klein = 1'b1;

            alu_mode_o = give_back_smaller;
        end


        write_both: begin               //3
            next_state = calc;

            wren_zw_in_zahlen = 1'b1;
        end


        calc: begin                     //4
            next_state = check_if_zero;

            Zahl1_to_alu_a = 1'b1;
            Zahl2_to_alu_b = 1'b1;

            wren_erg_modulo = 1'b1;

            alu_mode_o = modulo;
        end


        check_if_zero: begin            //5
            check_for_termination_o = 1'b1;
            next_state = write_numbers;
        end


        write_numbers: begin            //6
            next_state = calc;

            wren_to_new_numbers = 1'b1;
        end


        default: 
    endcase

    if (valid_r == 1'b1) begin
        next_state = IDLE;
    end
end








endmodule