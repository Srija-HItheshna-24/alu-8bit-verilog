`timescale 1ns/1ps

module alu_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [2:0] op,
    output reg  [7:0] result,
    output reg        zero,
    output reg        carry,
    output reg        overflow,
    output reg        negative
);

    reg [8:0] temp;

    always @(*) begin
        temp     = 9'b0;
        carry    = 1'b0;
        overflow = 1'b0;

        case (op)
            3'b000: begin
                temp     = {1'b0, A} + {1'b0, B};
                result   = temp[7:0];
                carry    = temp[8];
                overflow = (~A[7] & ~B[7] &  result[7]) |
                           ( A[7] &  B[7] & ~result[7]);
            end
            3'b001: begin
                temp     = {1'b0, A} - {1'b0, B};
                result   = temp[7:0];
                carry    = temp[8];
                overflow = ( A[7] & ~B[7] & ~result[7]) |
                           (~A[7] &  B[7] &  result[7]);
            end
            3'b010: result = A & B;
            3'b011: result = A | B;
            3'b100: result = A ^ B;
            3'b101: result = ~A;
            3'b110: begin
                result = A << 1;
                carry  = A[7];
            end
            3'b111: begin
                result = A >> 1;
                carry  = A[0];
            end
            default: result = 8'h00;
        endcase

        zero     = (result == 8'h00);
        negative = result[7];
    end

endmodule
