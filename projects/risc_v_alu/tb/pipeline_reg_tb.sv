//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  pipeline_reg_tb.sv
// Desc:    Testbench for pipeline_reg
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module pipeline_reg_tb;

    logic        clk, rst, stall, flush;
    logic [31:0] d, q;

    pipeline_reg #(.WIDTH(32)) dut (
        .clk  (clk),
        .rst  (rst),
        .stall(stall),
        .flush(flush),
        .d    (d),
        .q    (q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== Pipeline Register Testbench ===");

        rst = 1; stall = 0; flush = 0; d = 0;
        @(posedge clk); #1;
        rst = 0;

        // Test 1: Normal
        d = 32'hAAAA_AAAA; stall = 0; flush = 0;
        @(posedge clk); #1;
        $display("Test1 - Normal:  q=%h | %s",
            q, (q == 32'hAAAA_AAAA) ? "PASS" : "FAIL");

        // Test 2: Stall
        d = 32'h1234_5678; stall = 1;
        @(posedge clk); #1;
        $display("Test2 - Stall:   q=%h | %s",
            q, (q == 32'hAAAA_AAAA) ? "PASS" : "FAIL");

        // Test 3: Flush
        stall = 0; flush = 1; d = 32'hFFFF_FFFF;
        @(posedge clk); #1;
        $display("Test3 - Flush:   q=%h | %s",
            q, (q == 32'h0000_0000) ? "PASS" : "FAIL");

        // Test 4: Resume
        flush = 0; d = 32'hBEEF_CAFE;
        @(posedge clk); #1;
        $display("Test4 - Resume:  q=%h | %s",
            q, (q == 32'hBEEF_CAFE) ? "PASS" : "FAIL");

        // Test 5: Reset
        rst = 1; d = 32'hDEAD_DEAD;
        @(posedge clk); #1;
        $display("Test5 - Reset:   q=%h | %s",
            q, (q == 32'h0000_0000) ? "PASS" : "FAIL");

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
