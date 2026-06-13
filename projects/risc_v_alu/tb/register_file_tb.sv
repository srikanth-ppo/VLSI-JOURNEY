//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  register_file_tb.sv
// Desc:    Testbench for register_file
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module register_file_tb;

    logic        clk, rst, we;
    logic [4:0]  rs1_addr, rs2_addr, rd_addr;
    logic [31:0] rd_data;
    logic [31:0] rs1_data, rs2_data;

    register_file dut (
        .clk      (clk),
        .rst      (rst),
        .rs1_addr (rs1_addr),
        .rs2_addr (rs2_addr),
        .rs1_data (rs1_data),
        .rs2_data (rs2_data),
        .we       (we),
        .rd_addr  (rd_addr),
        .rd_data  (rd_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("=== Register File Testbench ===");

        rst = 1; we = 0;
        rs1_addr = 0; rs2_addr = 0;
        rd_addr = 0; rd_data = 0;
        @(posedge clk); #1;
        rst = 0;

        // Test 1: Write/Read x1
        we = 1; rd_addr = 5'd1; rd_data = 32'hDEADBEEF;
        @(posedge clk); #1;
        we = 0; rs1_addr = 5'd1; #1;
        $display("Test1 - Write/Read x1: result=%h | %s",
            rs1_data,
            (rs1_data == 32'hDEADBEEF) ? "PASS" : "FAIL");

        // Test 2: Write/Read x2
        we = 1; rd_addr = 5'd2; rd_data = 32'hCAFEBABE;
        @(posedge clk); #1;
        we = 0; rs1_addr = 5'd2; #1;
        $display("Test2 - Write/Read x2: result=%h | %s",
            rs1_data,
            (rs1_data == 32'hCAFEBABE) ? "PASS" : "FAIL");

        // Test 3: x0 always 0
        we = 1; rd_addr = 5'd0; rd_data = 32'hFFFFFFFF;
        @(posedge clk); #1;
        we = 0; rs1_addr = 5'd0; #1;
        $display("Test3 - x0 always 0:   result=%h | %s",
            rs1_data,
            (rs1_data == 32'd0) ? "PASS" : "FAIL");

        // Test 4: Dual read
        rs1_addr = 5'd1; rs2_addr = 5'd2; #1;
        $display("Test4 - Dual read:     x1=%h x2=%h | %s",
            rs1_data, rs2_data,
            (rs1_data == 32'hDEADBEEF &&
             rs2_data == 32'hCAFEBABE) ? "PASS" : "FAIL");

        // Test 5: Reset
        rst = 1;
        @(posedge clk); #1;
        rst = 0; rs1_addr = 5'd1; rs2_addr = 5'd2; #1;
        $display("Test5 - Reset clears:  x1=%h x2=%h | %s",
            rs1_data, rs2_data,
            (rs1_data == 32'd0 &&
             rs2_data == 32'd0) ? "PASS" : "FAIL");

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
