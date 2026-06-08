# RISC-V ALU — Architecture Reference
**Project:** Pipelined RISC-V ALU
**Date:** 2026-06-08

## ALU Control Encoding

| alu_ctrl [3:0] | Operation |
|----------------|-----------|
| 4'b0000 | ADD  |
| 4'b0001 | SUB  |
| 4'b0010 | AND  |
| 4'b0011 | OR   |
| 4'b0100 | XOR  |
| 4'b0101 | SLL  |
| 4'b0110 | SRL  |
| 4'b0111 | SRA  |
| 4'b1000 | SLT  |
| 4'b1001 | SLTU |

## Pipeline Signal Flow

| Pipeline Reg | Carries |
|-------------|---------|
| IF/ID  | instruction[31:0], PC+4 |
| ID/EX  | rs1_data, rs2_data, rd_addr, alu_ctrl |
| EX/MEM | alu_result, rd_addr, ctrl signals |
| MEM/WB | alu_result, rd_addr, we |

## Forwarding Paths

- EX-EX: MEM/WB.rd → EX stage operand
- MEM-WB: WB.rd → EX stage operand

## References
- RISC-V ISA Spec v2.2
- Patterson & Hennessy — CO&D RISC-V Edition
