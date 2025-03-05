module alu (
    input                   rst, clk, 
    input       [2:0]       alu_mode_i,

    input       [15:0]      op_a_i,
    input       [15:0]      op_b_i,

    output reg  [15:0]      res_o,
);



//===ALU_Kommandos============
localparam give_back_bigger     = 3'b0;
localparam give_back_smaller    = 3'b1;
localparam modulo               = 3'b2;
localparam IDLE                 = 3'b3;

always @(*) begin
    case (alu_mode_i)

        give_back_bigger: begin
            if (op_a_i > op_b_i) begin
                res_o = op_a_i;
            end
            else begin
                res_o = op_b_i;
            end
        end


        give_back_smaller: begin
            if (op_a_i < op_b_i) begin
                res_o = op_a_i;
            end
            else begin
                res_o = op_b_i;
            end
        end


        modulo: begin
            res_o = op_a_i;

            while (res_o >= op_b_i) begin
                res_o = op_b_i;
            end
        end

        default: res_o = 'd0;

    endcase
end


    
endmodule