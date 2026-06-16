//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  forwarding_unit_tb.sv
// Desc:    Testbench for forwarding_unit
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module forwarding_unit_tb;

    logic [4:0] ex_rs1, ex_rs2;
    logic [4:0] exmem_rd, memwb_rd;
    logic       exmem_we, memwb_we;
    logic [1:0] forward_a, forward_b;

    forwarding_unit dut (
        .ex_rs1   (ex_rs1),
        .ex_rs2   (ex_rs2),
        .exmem_rd (exmem_rd),
        .exmem_we (exmem_we),
        .memwb_rd (memwb_rd),
        .memwb_we (memwb_we),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    initial begin
        $display("=== Forwarding Unit Testbench ===");

        // Test 1: No forwarding
        ex_rs1 = 5'd1; ex_rs2 = 5'd2;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd4; memwb_we = 1;
        #10;
        $display("Test1 - No forward:     fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b00 && forward_b==2'b00) ? "PASS" : "FAIL");

        // Test 2: EX-EX forward rs1
        ex_rs1 = 5'd3; ex_rs2 = 5'd2;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd4; memwb_we = 1;
        #10;
        $display("Test2 - EX-EX fwd rs1:  fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b10 && forward_b==2'b00) ? "PASS" : "FAIL");

        // Test 3: EX-EX forward rs2
        ex_rs1 = 5'd1; ex_rs2 = 5'd3;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd4; memwb_we = 1;
        #10;
        $display("Test3 - EX-EX fwd rs2:  fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b00 && forward_b==2'b10) ? "PASS" : "FAIL");

        // Test 4: MEM-WB forward rs1
        ex_rs1 = 5'd4; ex_rs2 = 5'd2;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd4; memwb_we = 1;
        #10;
        $display("Test4 - MEM-WB fwd rs1: fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b01 && forward_b==2'b00) ? "PASS" : "FAIL");

        // Test 5: MEM-WB forward rs2
        ex_rs1 = 5'd1; ex_rs2 = 5'd4;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd4; memwb_we = 1;
        #10;
        $display("Test5 - MEM-WB fwd rs2: fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b00 && forward_b==2'b01) ? "PASS" : "FAIL");

        // Test 6: EX-EX priority
        ex_rs1 = 5'd3; ex_rs2 = 5'd3;
        exmem_rd = 5'd3; exmem_we = 1;
        memwb_rd = 5'd3; memwb_we = 1;
        #10;
        $display("Test6 - EX-EX priority: fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b10 && forward_b==2'b10) ? "PASS" : "FAIL");

        // Test 7: we=0 no forward
        ex_rs1 = 5'd3; ex_rs2 = 5'd4;
        exmem_rd = 5'd3; exmem_we = 0;
        memwb_rd = 5'd4; memwb_we = 0;
        #10;
        $display("Test7 - we=0 no fwd:    fwd_a=%b fwd_b=%b | %s",
            forward_a, forward_b,
            (forward_a==2'b00 && forward_b==2'b00) ? "PASS" : "FAIL");

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
