//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  risc_v_alu_top_tb.sv
// Desc:    Testbench for risc_v_alu_top
//          Tests full pipeline — regfile → ID/EX → ALU → EX/MEM
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module risc_v_alu_top_tb;

    logic        clk, rst;
    logic [4:0]  rs1_addr, rs2_addr, rd_addr_in;
    logic [3:0]  alu_ctrl_in;
    logic        we;
    logic [4:0]  rd_addr_wb;
    logic [31:0] rd_data_wb;
    logic        stall, flush;
    logic [31:0] alu_result;
    logic        zero, negative, overflow;

    risc_v_alu_top dut (
        .clk        (clk),
        .rst        (rst),
        .rs1_addr   (rs1_addr),
        .rs2_addr   (rs2_addr),
        .rd_addr_in (rd_addr_in),
        .alu_ctrl_in(alu_ctrl_in),
        .we         (we),
        .rd_addr_wb (rd_addr_wb),
        .rd_data_wb (rd_data_wb),
        .stall      (stall),
        .flush      (flush),
        .alu_result (alu_result),
        .zero       (zero),
        .negative   (negative),
        .overflow   (overflow)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    task show_result;
        input [8*8:1] op_name;
        input [31:0]  expected;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("%-6s | result=%0d | zero=%b neg=%b ovf=%b | %s",
            op_name, alu_result, zero, negative, overflow,
            (alu_result == expected) ? "PASS" : "FAIL");
    endtask

    initial begin
        $display("=== RISC-V ALU Top Testbench ===");

        rst = 1; stall = 0; flush = 0;
        we = 0; rs1_addr = 0; rs2_addr = 0;
        rd_addr_in = 0; alu_ctrl_in = 0;
        rd_addr_wb = 0; rd_data_wb = 0;
        @(posedge clk); #1;
        rst = 0;

        // Load register file
        we = 1; rd_addr_wb = 5'd1; rd_data_wb = 32'd10;
        @(posedge clk); #1;
        rd_addr_wb = 5'd2; rd_data_wb = 32'd20;
        @(posedge clk); #1;
        rd_addr_wb = 5'd3; rd_data_wb = 32'hFFFF;
        @(posedge clk); #1;
        rd_addr_wb = 5'd4; rd_data_wb = 32'h0F0F;
        @(posedge clk); #1;
        we = 0;

        $display("--- Register file loaded ---");
        $display("x1=10, x2=20, x3=0xFFFF, x4=0x0F0F");
        $display("--- Pipeline Results (2 cycle latency) ---");

        // ADD
        rs1_addr = 5'd1; rs2_addr = 5'd2;
        rd_addr_in = 5'd5; alu_ctrl_in = 4'b0000;
        show_result("ADD", 32'd30);

        // SUB
        rs1_addr = 5'd2; rs2_addr = 5'd1;
        rd_addr_in = 5'd6; alu_ctrl_in = 4'b0001;
        show_result("SUB", 32'd10);

        // AND
        rs1_addr = 5'd3; rs2_addr = 5'd4;
        rd_addr_in = 5'd7; alu_ctrl_in = 4'b0010;
        show_result("AND", 32'h0F0F);

        // OR
        rs1_addr = 5'd3; rs2_addr = 5'd4;
        rd_addr_in = 5'd8; alu_ctrl_in = 4'b0011;
        show_result("OR", 32'hFFFF);

        // XOR
        rs1_addr = 5'd3; rs2_addr = 5'd4;
        rd_addr_in = 5'd9; alu_ctrl_in = 4'b0100;
        show_result("XOR", 32'hF0F0);

        // Stall
        rs1_addr = 5'd1; rs2_addr = 5'd2;
        alu_ctrl_in = 4'b0000;
        stall = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("STALL  | result=%0d | held=%s",
            alu_result,
            (alu_result == 32'hF0F0) ? "PASS" : "FAIL");
        stall = 0;

        // Flush
        flush = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        $display("FLUSH  | result=%0d | cleared=%s",
            alu_result,
            (alu_result == 32'd0) ? "PASS" : "FAIL");
        flush = 0;

        $display("=== Simulation Complete ===");
        $finish;
    end

endmodule
