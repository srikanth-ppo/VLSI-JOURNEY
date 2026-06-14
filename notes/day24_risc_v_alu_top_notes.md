# Day 24 — RISC-V ALU Top Module
## VLSI Journey — Q1 Project Phase
**Date:** 2026-06-13
**Status:** ✅ Full pipeline coded, simulated, verified

---

## What Was Built Today

Connected all three verified modules into a complete
2-stage pipeline (ID → EX → MEM):

register_file → ID/EX reg → alu_core → EX/MEM reg

---

## Module: risc_v_alu_top.sv

### Port Summary
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| clk | in | 1 | Clock |
| rst | in | 1 | Sync reset |
| rs1_addr | in | 5 | RS1 register address |
| rs2_addr | in | 5 | RS2 register address |
| rd_addr_in | in | 5 | Destination register |
| alu_ctrl_in | in | 4 | ALU operation select |
| we | in | 1 | Write enable (WB) |
| rd_addr_wb | in | 5 | WB write address |
| rd_data_wb | in | 32 | WB write data |
| stall | in | 1 | Pipeline stall |
| flush | in | 1 | Pipeline flush |
| alu_result | out | 32 | Final ALU result |
| zero | out | 1 | Result == 0 |
| negative | out | 1 | Result[31] |
| overflow | out | 1 | Signed overflow |

---

## Pipeline Signal Packing

### ID/EX Register — 73 bits
