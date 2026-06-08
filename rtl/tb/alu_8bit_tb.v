`timescale 1ns/1ps

module alu_8bit_tb;

    reg  [7:0] A, B;
    reg  [2:0] op;
    wire [7:0] result;
    wire       zero, carry, overflow, negative;

    alu_8bit dut (
        .A(A), .B(B), .op(op),
        .result(result),
        .zero(zero), .carry(carry),
        .overflow(overflow), .negative(negative)
    );

    initial begin
        $dumpfile("alu_waves.vcd");       // <-- no sim/ folder
        $dumpvars(0, alu_8bit_tb);
    end

    integer pass_count, fail_count;

    task apply_test;
        input [7:0]  t_A, t_B;
        input [2:0]  t_op;
        input [7:0]  expected_result;
        input        expected_zero;
        input        expected_carry;
        input [23:0] op_name;
        begin
            A = t_A; B = t_B; op = t_op;
            #10;
            if (result === expected_result &&
                zero   === expected_zero   &&
                carry  === expected_carry) begin
                $display("PASS | %s | A=%0d B=%0d | result=%0d zero=%b carry=%b",
                          op_name, t_A, t_B, result, zero, carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %s | A=%0d B=%0d | got=%0d zero=%b carry=%b | exp=%0d zero=%b carry=%b",
                          op_name, t_A, t_B,
                          result, zero, carry,
                          expected_result, expected_zero, expected_carry);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("       8-bit ALU Testbench");
        $display("========================================");

        $display("\n--- ADD ---");
        apply_test(8'd10,  8'd20,  3'b000, 8'd30,  0, 0, "ADD");
        apply_test(8'd0,   8'd0,   3'b000, 8'd0,   1, 0, "ADD");
        apply_test(8'd255, 8'd1,   3'b000, 8'd0,   1, 1, "ADD");
        apply_test(8'd200, 8'd100, 3'b000, 8'd44,  0, 1, "ADD");
        apply_test(8'd127, 8'd1,   3'b000, 8'd128, 0, 0, "ADD");

        $display("\n--- SUB ---");
        apply_test(8'd50, 8'd20, 3'b001, 8'd30,  0, 0, "SUB");
        apply_test(8'd20, 8'd20, 3'b001, 8'd0,   1, 0, "SUB");
        apply_test(8'd10, 8'd20, 3'b001, 8'd246, 0, 1, "SUB");

        $display("\n--- AND ---");
        apply_test(8'hFF, 8'hAA, 3'b010, 8'hAA, 0, 0, "AND");
        apply_test(8'hF0, 8'h0F, 3'b010, 8'h00, 1, 0, "AND");
        apply_test(8'hAB, 8'hCD, 3'b010, 8'h89, 0, 0, "AND");

        $display("\n--- OR  ---");
        apply_test(8'hF0, 8'h0F, 3'b011, 8'hFF, 0, 0, "OR ");
        apply_test(8'h00, 8'h00, 3'b011, 8'h00, 1, 0, "OR ");
        apply_test(8'hAA, 8'h55, 3'b011, 8'hFF, 0, 0, "OR ");

        $display("\n--- XOR ---");
        apply_test(8'hFF, 8'hFF, 3'b100, 8'h00, 1, 0, "XOR");
        apply_test(8'hAA, 8'h55, 3'b100, 8'hFF, 0, 0, "XOR");
        apply_test(8'hA5, 8'h5A, 3'b100, 8'hFF, 0, 0, "XOR");

        $display("\n--- NOT ---");
        apply_test(8'hFF, 8'h00, 3'b101, 8'h00, 1, 0, "NOT");
        apply_test(8'h00, 8'h00, 3'b101, 8'hFF, 0, 0, "NOT");
        apply_test(8'hAA, 8'h00, 3'b101, 8'h55, 0, 0, "NOT");

        $display("\n--- SHL ---");
        apply_test(8'b00000001, 8'd0, 3'b110, 8'b00000010, 0, 0, "SHL");
        apply_test(8'b10000000, 8'd0, 3'b110, 8'b00000000, 1, 1, "SHL");
        apply_test(8'b01010101, 8'd0, 3'b110, 8'b10101010, 0, 0, "SHL");

        $display("\n--- SHR ---");
        apply_test(8'b10000000, 8'd0, 3'b111, 8'b01000000, 0, 0, "SHR");
        apply_test(8'b00000001, 8'd0, 3'b111, 8'b00000000, 1, 1, "SHR");
        apply_test(8'b10101010, 8'd0, 3'b111, 8'b01010101, 0, 0, "SHR");

        $display("\n========================================");
        $display("  Results: %0d PASSED  |  %0d FAILED", pass_count, fail_count);
        $display("========================================\n");

        #20;
        $finish;
    end

endmodule
