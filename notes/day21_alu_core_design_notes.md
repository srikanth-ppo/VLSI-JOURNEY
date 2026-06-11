# Day 21 — RISC-V ALU Core Design Notes
## VLSI Journey — Q1 Project Phase
**Date:** 2026-06-10
**Status:** Pre-coding Study

---

## What We Are Building Today

Module: alu_core.sv
Type: Pure combinational logic
Purpose: Executes all 10 RV32I integer ALU operations

---

## ALU Core — Full Design Plan

### Inputs and Outputs
- rs1 [31:0]      — first operand
- rs2 [31:0]      — second operand
- alu_ctrl [3:0]  — selects operation
- result [31:0]   — computed output
- zero            — 1 when result == 0
- negative        — 1 when result[31] == 1
- overflow        — 1 on signed ADD/SUB overflow

---

## Operation-by-Operation Notes

### ADD (4'b0000)
result = rs1 + rs2
Overflow when:
- Both positive, result negative: ~rs1[31] & ~rs2[31] & result[31]
- Both negative, result positive:  rs1[31] &  rs2[31] & ~result[31]

### SUB (4'b0001)
result = rs1 - rs2
Overflow when:
- Positive - Negative = Negative: ~rs1[31] & rs2[31] & result[31]
- Negative - Positive = Positive:  rs1[31] & ~rs2[31] & ~result[31]

### AND (4'b0010)
result = rs1 & rs2
Bitwise AND — no overflow possible

### OR (4'b0011)
result = rs1 | rs2
Bitwise OR — no overflow possible

### XOR (4'b0100)
result = rs1 ^ rs2
Bitwise XOR — no overflow possible

### SLL (4'b0101)
result = rs1 << rs2[4:0]
Shift left logical — only lower 5 bits of rs2 used (max shift = 31)

### SRL (4'b0110)
result = rs1 >> rs2[4:0]
Shift right logical — zero filled from left
Only lower 5 bits of rs2 used

### SRA (4'b0111)
result = $signed(rs1) >>> rs2[4:0]
Shift right arithmetic — sign bit extended from left
MUST use $signed() cast in SystemVerilog

### SLT (4'b1000)
result = ($signed(rs1) < $signed(rs2)) ? 32'd1 : 32'd0
Signed comparison — both operands must be cast to $signed()
Output is 1 or 0 only — not the difference

### SLTU (4'b1001)
result = (rs1 < rs2) ? 32'd1 : 32'd0
Unsigned comparison — no cast needed
Output is 1 or 0 only

---

## Status Flags

| Flag | Logic | Used For |
|------|-------|---------|
| zero | result == 32'b0 | Branch decisions (BEQ, BNE) |
| negative | result[31] | Signed comparisons |
| overflow | ADD/SUB signed overflow | Exception detection |

---

## Key SystemVerilog Rules to Remember

1. Use always_comb for combinational ALU — not always @(*)
2. All outputs must be assigned in every branch — use default first
3. $signed() cast required for SRA and SLT
4. rs2[4:0] — only lower 5 bits used for shift amount in RV32I
5. overflow is 0 for all operations except ADD and SUB

---

## Common Mistakes to Avoid

- Forgetting $signed() on SRA → gets logical shift instead of arithmetic
- Using full rs2 for shift amount → should be rs2[4:0] only
- Not setting default result = 0 before case → latch inferred
- Confusing SLT (signed) with SLTU (unsigned)

---

## Tomorrow — Day 22
- Write alu_core.sv in ModelSim
- Simulate all 10 operations
- Verify zero, negative, overflow flags
- Commit working RTL to projects/risc_v_alu/rtl/
