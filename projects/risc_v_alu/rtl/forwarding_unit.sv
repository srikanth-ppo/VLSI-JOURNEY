//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  forwarding_unit.sv
// Desc:    EX-EX and MEM-WB forwarding unit
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module forwarding_unit (
    input  logic [4:0] ex_rs1,
    input  logic [4:0] ex_rs2,
    input  logic [4:0] exmem_rd,
    input  logic       exmem_we,
    input  logic [4:0] memwb_rd,
    input  logic       memwb_we,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    always_comb begin
        forward_a = 2'b00;
        forward_b = 2'b00;

        // Forward A
        if (exmem_we && exmem_rd != 5'd0 && exmem_rd == ex_rs1)
            forward_a = 2'b10;
        else if (memwb_we && memwb_rd != 5'd0 && memwb_rd == ex_rs1)
            forward_a = 2'b01;

        // Forward B
        if (exmem_we && exmem_rd != 5'd0 && exmem_rd == ex_rs2)
            forward_b = 2'b10;
        else if (memwb_we && memwb_rd != 5'd0 && memwb_rd == ex_rs2)
            forward_b = 2'b01;
    end

endmodule
