//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  alu_core_tb.sv
// Desc:    Testbench for alu_core — tests all 10 operations
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module alu_core_tb;

    // Inputs
    logic [31:0] rs1, rs2;
    logic [3:0]  alu_ctrl;

    // Outputs
    logic [31:0] result;
    logic        zero, negative, overflow;

    // Instantiate DUT
    alu_core dut (
        .rs1      (rs1),
        .rs2      (rs2),
        .alu_ctrl (alu_ctrl),
        .result   (result),
        .zero     (zero),
        .negative (negative),
        .overflow (overflow)
    );

    // Task to display results
    task check;
        input [63:0] expected;
        input [8*8:1] op_name;
        #5;
        $display("%-6s | rs1=%0d rs2=%0d | result=%0d | zero=%b neg=%b ovf=%b | %s",
            op_name, rs1, rs2, result, zero, negative, overflow,
            (result == expected[31:0]) ? "PASS" : "FAIL");
    endtask

    initial begin
        $display("=== ALU Core Testbench ===");
        $display("OP     | Inputs          | Outputs                  | Status");
        $display("---------------------------------------------------------------");

        // ADD
        rs1 = 32'd15; rs2 = 32'd10; alu_ctrl = 4'b0000;
        check(32'd25, "ADD");

        // SUB
        rs1 = 32'd20; rs2 = 32'd8;  alu_ctrl = 4'b0001;
        check(32'd12, "SUB");

        // AND
        rs1 = 32'hFF00; rs2 = 32'hF0F0; alu_ctrl = 4'b0010;
        check(32'hF000, "AND");

        // OR
        rs1 = 32'hFF00; rs2 = 32'h00FF; alu_ctrl = 4'b0011;
        check(32'hFFFF, "OR");

        // XOR
        rs1 = 32'hFFFF; rs2 = 32'h0F0F; alu_ctrl = 4'b0100;
        check(32'hF0F0, "XOR");

        // SLL
        rs1 = 32'd1; rs2 = 32'd4; alu_ctrl = 4'b0101;
        check(32'd16, "SLL");

        // SRL
        rs1 = 32'd32; rs2 = 32'd2; alu_ctrl = 4'b0110;
        check(32'd8, "SRL");

        // SRA
        rs1 = 32'hFFFFFFFC; rs2 = 32'd1; alu_ctrl = 4'b0111;
        check(32'hFFFFFFFE, "SRA");

        // SLT
        rs1 = 32'hFFFFFFFF; rs2 = 32'd1; alu_ctrl = 4'b1000;
        check(32'd1, "SLT");

        // SLTU
        rs1 = 32'd1; rs2 = 32'hFFFFFFFF; alu_ctrl = 4'b1001;
        check(32'd1, "SLTU");

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
