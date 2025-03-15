module alu (
    input                   rst_i, clk, 
    input       [2:0]       alu_mode_i,
    input                   modulo_start_i,

    input       [15:0]      op_a_i,
    input       [15:0]      op_b_i,

    output reg  [15:0]      res_o, 
    output                  modulo_ready_o
);


wire [15:0]     modulo_zwischenspeicher;

 modulo_top modulo(

            .rst_i(rst_i), 
            .clk(clk), 
            .start_i(modulo_start_i),

            .Zahl1_i(op_a_i), 
            .Zahl2_i(op_b_i),

            .valid_o(modulo_ready_o),
            .ergebnis_o(modulo_zwischenspeicher)

            );



//===ALU_Kommandos============
localparam give_back_bigger     = 3'd0;
localparam give_back_smaller    = 3'd1;
localparam ALU_modulo           = 3'd2;
localparam ALU_IDLE             = 3'd3;

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


        ALU_modulo: begin

            res_o = modulo_zwischenspeicher;

        end

        default: res_o = 'd0;

    endcase
end


    
endmodule