module controller(

    input           rst,
    input           clk,
    input           start_i,
    input           valid_i,
    input           modulo_ready_i,

    output reg [2:0]    alu_mode_o,

//===Write-Back-Flags===
    output reg wren_zw_gross,
    output reg wren_zw_klein,
    output reg wren_zw_in_zahlen,
    output reg wren_erg_modulo,
    output reg wren_Zahl, 
    output reg wren_to_new_numbers,

//===Register-Transfer===
    output reg Zahl1_to_alu_a,
    output reg Zahl2_to_alu_b,

    output reg check_for_termination_o,

    output reg modulo_start_o

);

//===Schritte================
localparam find_bigger              = 5'b0;
localparam find_smaller             = 5'd1;
localparam write_both               = 5'd2;
localparam write_zwischenspeicher   = 5'd3;

localparam calc                     = 5'd4; //iterative Schritte des Algorithmus
localparam write_erg                = 5'd5;
localparam check_if_zero            = 5'd6;
localparam write_Zahl               = 5'd7;
localparam write_numbers            = 5'd8;
localparam IDLE                     = 5'd9;


//===ALU_Kommandos============
localparam give_back_bigger     = 3'd0;
localparam give_back_smaller    = 3'd1;
localparam ALU_modulo           = 3'd2;
localparam ALU_IDLE             = 3'd3;


//===Schrittregister============
reg [3:0] 			current_state, next_state;
reg                 start_r, valid_r;      



always @(posedge clk) begin
    if (rst) begin
        valid_r         <= 1'd0;
        start_r         <= 1'd0;
        current_state   <= IDLE;
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

    modulo_start_o = 1'd0;

//===Write-Back-Flags===
    wren_zw_gross               = 'b0;    
    wren_zw_klein               = 'b0;    
    wren_zw_in_zahlen           = 'b0;        
    wren_erg_modulo             = 'b0;    
    wren_Zahl                   = 'b0;
    wren_to_new_numbers         = 'b0;        

//===Register-Transfer===
    Zahl1_to_alu_a              = 'b0;     
    Zahl2_to_alu_b              = 'b0;     
    //erg_modulo_to_alu_a         = 'b0;         





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

            alu_mode_o = give_back_bigger;
        end


        find_smaller: begin             //2
            next_state = write_both;

            Zahl1_to_alu_a = 1'b1;
            Zahl2_to_alu_b = 1'b1;

            wren_zw_gross = 1'b1;
            

            alu_mode_o = give_back_smaller;
        end


        write_both: begin               //3
            next_state = write_zwischenspeicher;
            wren_zw_klein = 1'b1;
            
        end

        write_zwischenspeicher: begin

            next_state = calc;
            wren_zw_in_zahlen = 1'b1;
        end


    
        calc: begin                     //4

            if (modulo_ready_i == 1'b1) begin
                next_state = write_erg;
            end
            
            Zahl1_to_alu_a = 1'b1;
            Zahl2_to_alu_b = 1'b1;

            alu_mode_o = ALU_modulo;
            modulo_start_o = 1'd1;
        end

        write_erg: begin            //5
            next_state = check_if_zero;
            wren_erg_modulo = 1'b1;
        end

        check_if_zero: begin

            next_state = write_Zahl;
            check_for_termination_o = 1'd1;
        end

        write_Zahl: begin
            next_state = write_numbers;
            wren_Zahl = 1'b1;
        end

        write_numbers: begin            //7
            next_state = calc;

            wren_to_new_numbers = 1'b1;
        end

    endcase

    if (valid_i == 1'b1) begin
        next_state = IDLE;
    end
end








endmodule