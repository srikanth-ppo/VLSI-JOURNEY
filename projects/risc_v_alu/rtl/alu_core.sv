//=============================================================
// Project: Pipelined RISC-V ALU
// Module:  alu_core.sv
// Desc:    Combinational ALU — RV32I subset (10 operations)
// Tool:    ModelSim 18.1 | Language: SystemVerilog
//=============================================================

module alu_core (
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    input  logic [3:0]  alu_ctrl,
    output logic [31:0] result,
    output logic        zero,
    output logic        negative,
    output logic        overflow
);

    always_comb begin
        // Default to avoid latch
        result = 32'b0;

        case (alu_ctrl)
            4'b0000: result = rs1 + rs2;                              // ADD
            4'b0001: result = rs1 - rs2;                              // SUB
            4'b0010: result = rs1 & rs2;                              // AND
            4'b0011: result = rs1 | rs2;                              // OR
            4'b0100: result = rs1 ^ rs2;                              // XOR
            4'b0101: result = rs1 << rs2[4:0];                        // SLL
            4'b0110: result = rs1 >> rs2[4:0];                        // SRL
            4'b0111: result = 32'($signed(rs1) >>> rs2[4:0]);         // SRA
            4'b1000: result = ($signed(rs1) < $signed(rs2))           // SLT
                               ? 32'd1 : 32'd0;
            4'b1001: result = (rs1 < rs2) ? 32'd1 : 32'd0;           // SLTU
            default: result = 32'b0;
        endcase
    end

    // Status flags
    assign zero     = (result == 32'b0);
    assign negative =  result[31];

    // Overflow — valid only for ADD and SUB
    always_comb begin
        case (alu_ctrl)
            4'b0000: overflow = (~rs1[31] & ~rs2[31] &  result[31]) |
                                ( rs1[31] &  rs2[31] & ~result[31]);
            4'b0001: overflow = (~rs1[31] &  rs2[31] &  result[31]) |
                                ( rs1[31] & ~rs2[31] & ~result[31]);
            default: overflow = 1'b0;
        endcase
    end

endmodule
