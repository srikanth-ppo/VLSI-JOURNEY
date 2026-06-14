//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  risc_v_alu_top.sv
// Desc:    Top level — 5-stage pipeline connecting
//          register_file, pipeline_reg, alu_core
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module risc_v_alu_top (
    input  logic        clk,
    input  logic        rst,
    // ID stage inputs
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    input  logic [4:0]  rd_addr_in,
    input  logic [3:0]  alu_ctrl_in,
    // WB stage (write back)
    input  logic        we,
    input  logic [4:0]  rd_addr_wb,
    input  logic [31:0] rd_data_wb,
    // Pipeline control
    input  logic        stall,
    input  logic        flush,
    // EX/MEM stage outputs
    output logic [31:0] alu_result,
    output logic        zero,
    output logic        negative,
    output logic        overflow
);

    //=========================================================
    // ID Stage — Register File Read
    //=========================================================
    logic [31:0] rs1_data_id, rs2_data_id;

    register_file u_regfile (
        .clk      (clk),
        .rst      (rst),
        .rs1_addr (rs1_addr),
        .rs2_addr (rs2_addr),
        .rs1_data (rs1_data_id),
        .rs2_data (rs2_data_id),
        .we       (we),
        .rd_addr  (rd_addr_wb),
        .rd_data  (rd_data_wb)
    );

    //=========================================================
    // ID/EX Pipeline Register
    // Carries: rs1_data, rs2_data, rd_addr, alu_ctrl
    // Total width = 32+32+5+4 = 73 bits
    //=========================================================
    logic [72:0] idex_in, idex_out;

    assign idex_in = {rs1_data_id, rs2_data_id, rd_addr_in, alu_ctrl_in};

    pipeline_reg #(.WIDTH(73)) u_idex (
        .clk  (clk),
        .rst  (rst),
        .stall(stall),
        .flush(flush),
        .d    (idex_in),
        .q    (idex_out)
    );

    // Unpack ID/EX outputs
    logic [31:0] rs1_data_ex, rs2_data_ex;
    logic [4:0]  rd_addr_ex;
    logic [3:0]  alu_ctrl_ex;

    assign {rs1_data_ex, rs2_data_ex, rd_addr_ex, alu_ctrl_ex} = idex_out;

    //=========================================================
    // EX Stage — ALU Core
    //=========================================================
    logic [31:0] alu_result_ex;
    logic        zero_ex, negative_ex, overflow_ex;

    alu_core u_alu (
        .rs1     (rs1_data_ex),
        .rs2     (rs2_data_ex),
        .alu_ctrl(alu_ctrl_ex),
        .result  (alu_result_ex),
        .zero    (zero_ex),
        .negative(negative_ex),
        .overflow(overflow_ex)
    );

    //=========================================================
    // EX/MEM Pipeline Register
    // Carries: alu_result, zero, negative, overflow, rd_addr
    // Total width = 32+1+1+1+5 = 40 bits
    //=========================================================
    logic [39:0] exmem_in, exmem_out;

    assign exmem_in = {alu_result_ex, zero_ex,
                       negative_ex, overflow_ex, rd_addr_ex};

    pipeline_reg #(.WIDTH(40)) u_exmem (
        .clk  (clk),
        .rst  (rst),
        .stall(stall),
        .flush(flush),
        .d    (exmem_in),
        .q    (exmem_out)
    );

    // Unpack EX/MEM outputs
    logic [4:0] rd_addr_mem;

    assign {alu_result, zero, negative, overflow, rd_addr_mem} = exmem_out;

endmodule
