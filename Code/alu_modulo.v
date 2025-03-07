module alu_modulo (
    input                   rst, clk, 
    input       [2:0]       alu_mode_i,

    input       [15:0]      op_a_i,
    input       [15:0]      op_b_i,

    output reg  [15:0]      res_o
);


//===ALU-Kommandos===
    localparam ALU_compare      = 4'd0;
    localparam ALU_Diff         = 4'd1;
    localparam ALU_IDLE         = 4'd2;

    always @(*) begin
        
        case (alu_mode_i)


            ALU_compare: begin
                if (op_a_i >= op_b_i) begin
                    res_o = 1'b0;
                end
                else begin
                    res_o = 1'b1;
                end
            end

            ALU_Diff: begin
                res_o = op_a_i - op_b_i;
            end


            default: res_o = 'd0;
        endcase
    end
    
endmodule