//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  register_file.sv
// Desc:    32x32 Register File — 2 async read, 1 sync write
//          x0 hardwired to 0
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module register_file (
    input  logic        clk,
    input  logic        rst,
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    input  logic        we,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data
);

    logic [31:0] regs [31:0];
    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i++)
                regs[i] <= 32'b0;
        end
        else if (we && rd_addr != 5'd0)
            regs[rd_addr] <= rd_data;
    end

    assign rs1_data = (rs1_addr == 5'd0) ? 32'd0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'd0) ? 32'd0 : regs[rs2_addr];

endmodule
