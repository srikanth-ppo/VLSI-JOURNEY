//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  hazard_unit_tb.sv
// Desc:    Testbench for hazard_unit
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module hazard_unit_tb;

    logic [4:0] id_ex_rd;
    logic       id_ex_mem_read;
    logic [4:0] if_id_rs1, if_id_rs2;
    logic       stall, flush_idex;

    hazard_unit dut (
        .id_ex_rd      (id_ex_rd),
        .id_ex_mem_read(id_ex_mem_read),
        .if_id_rs1     (if_id_rs1),
        .if_id_rs2     (if_id_rs2),
        .stall         (stall),
        .flush_idex    (flush_idex)
    );

    initial begin
        $display("=== Hazard Unit Testbench ===");

        // Test 1: No hazard
        id_ex_rd = 5'd3; id_ex_mem_read = 1;
        if_id_rs1 = 5'd1; if_id_rs2 = 5'd2;
        #10;
        $display("Test1 - No hazard:      stall=%b flush=%b | %s",
            stall, flush_idex,
            (stall==0 && flush_idex==0) ? "PASS" : "FAIL");

        // Test 2: Hazard on rs1
        id_ex_rd = 5'd1; id_ex_mem_read = 1;
        if_id_rs1 = 5'd1; if_id_rs2 = 5'd2;
        #10;
        $display("Test2 - Hazard rs1:     stall=%b flush=%b | %s",
            stall, flush_idex,
            (stall==1 && flush_idex==1) ? "PASS" : "FAIL");

        // Test 3: Hazard on rs2
        id_ex_rd = 5'd2; id_ex_mem_read = 1;
        if_id_rs1 = 5'd1; if_id_rs2 = 5'd2;
        #10;
        $display("Test3 - Hazard rs2:     stall=%b flush=%b | %s",
            stall, flush_idex,
            (stall==1 && flush_idex==1) ? "PASS" : "FAIL");

        // Test 4: Not a load
        id_ex_rd = 5'd1; id_ex_mem_read = 0;
        if_id_rs1 = 5'd1; if_id_rs2 = 5'd2;
        #10;
        $display("Test4 - Not a load:     stall=%b flush=%b | %s",
            stall, flush_idex,
            (stall==0 && flush_idex==0) ? "PASS" : "FAIL");

        // Test 5: rd is x0
        id_ex_rd = 5'd0; id_ex_mem_read = 1;
        if_id_rs1 = 5'd0; if_id_rs2 = 5'd0;
        #10;
        $display("Test5 - rd is x0:       stall=%b flush=%b | %s",
            stall, flush_idex,
            (stall==0 && flush_idex==0) ? "PASS" : "FAIL");

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
