# Day 20 — RISC-V ALU Architecture Deep Dive
## VLSI Journey — Q1 Project Phase
**Date:** 2026-06-09
**Status:** Architecture Study

## 1. ALU Core — Combinational Logic Design

The ALU core is purely combinational — no clocks, no state.

Ports:
- rs1 [31:0] — first operand
- rs2 [31:0] — second operand
- alu_ctrl [3:0] — operation select
- result [31:0] — output
- zero — result == 0
- negative — result[31]
- overflow — signed overflow on ADD/SUB

## 2. Pipeline Register Behavior

| stall | flush | Action |
|-------|-------|--------|
| 0 | 0 | Normal: q <= d |
| 1 | 0 | Stall: q holds |
| x | 1 | Flush: q <= 0 (bubble) |

Parameterized width so same module works at every stage boundary.

## 3. Register File — 32x32 Key Rules

- x0 always reads 0 — hardwired, writes ignored
- 2 read ports — combinational, no clock needed
- 1 write port — synchronous on posedge clk
- Write to x0 is silently ignored

## 4. Data Hazard Types in 5-Stage Pipeline

RAW — Read After Write:
- Instruction 2 needs result of Instruction 1
- But Instruction 1 hasn't written back yet
- Solution: Forwarding unit

Forwarding Paths:
- EX-EX Forward: result available after EX, forward to next EX
- MEM-WB Forward: result available after MEM, forward to next EX

## 5. Full Pipeline Datapath

IF → IF/ID reg → ID → ID/EX reg → EX → EX/MEM reg → MEM → MEM/WB reg → WB
                                    ↑                    |
                                    └────────────────────┘
                                       Forwarding paths

## 6. Signals at Each Pipeline Register

| Pipeline Reg | Carries |
|-------------|---------|
| IF/ID  | instruction[31:0], PC+4 |
| ID/EX  | rs1_data, rs2_data, rd_addr, alu_ctrl, imm |
| EX/MEM | alu_result, rs2_data, rd_addr, ctrl signals |
| MEM/WB | alu_result or mem_data, rd_addr, we |

## 7. Key SystemVerilog Notes for Implementation

Arithmetic right shift — must use $signed():
    result = $signed(rs1) >>> rs2[4:0];

Signed comparison for SLT:
    result = ($signed(rs1) < $signed(rs2)) ? 32'd1 : 32'd0;

Overflow detection for ADD:
    overflow = (~rs1[31] & ~rs2[31] & result[31]) |
               ( rs1[31] &  rs2[31] & ~result[31]);

## 8. Study References
- Patterson & Hennessy Chapter 4.1 to 4.7
- RISC-V ISA Spec v2.2 — RV32I base instructions
- HDLBits Days 1-17 completed — RTL foundation ready
