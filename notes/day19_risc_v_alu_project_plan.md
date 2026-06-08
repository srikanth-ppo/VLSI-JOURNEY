# Day 19 — RISC-V ALU Project Plan
## VLSI Journey — Q1 Project Phase Begins
**Date:** 2026-06-08
**Status:** Planning Phase

## Project Overview

**Project:** Pipelined RISC-V ALU
**Target:** RV32I subset — integer arithmetic and logic operations
**Goal:** Month 1 milestone — synthesizable, verified RTL

## RV32I ALU Operations (Target Subset)

| Instruction | Operation | Notes |
|-------------|-----------|-------|
| ADD  | rd = rs1 + rs2 | 32-bit addition |
| SUB  | rd = rs1 - rs2 | 32-bit subtraction |
| AND  | rd = rs1 & rs2 | Bitwise AND |
| OR   | rd = rs1 or rs2 | Bitwise OR |
| XOR  | rd = rs1 ^ rs2 | Bitwise XOR |
| SLL  | rd = rs1 << rs2[4:0] | Shift left logical |
| SRL  | rd = rs1 >> rs2[4:0] | Shift right logical |
| SRA  | rd = rs1 >>> rs2[4:0] | Shift right arithmetic |
| SLT  | rd = (rs1 < rs2) ? 1 : 0 | Set less than signed |
| SLTU | rd = (rs1 < rs2) ? 1 : 0 | Set less than unsigned |

## Pipeline Architecture — 5 Stage

IF → ID → EX → MEM → WB

| Stage | Full Name | Function |
|-------|-----------|----------|
| IF  | Instruction Fetch  | Fetch instruction from memory |
| ID  | Instruction Decode | Decode opcode, read registers |
| EX  | Execute | ALU operation |
| MEM | Memory Access | Load/store (NOP for ALU-only) |
| WB  | Write Back | Write result to register file |

## Module Hierarchy

risc_v_alu_top.sv
- alu_core.sv
- pipeline_reg.sv
- register_file.sv
- hazard_unit.sv
- forwarding_unit.sv

## Repo File Structure

projects/
└── risc_v_alu/
    ├── rtl/
    │   ├── alu_core.sv
    │   ├── pipeline_reg.sv
    │   ├── register_file.sv
    │   ├── hazard_unit.sv
    │   ├── forwarding_unit.sv
    │   └── risc_v_alu_top.sv
    ├── tb/
    │   ├── alu_core_tb.sv
    │   └── risc_v_alu_top_tb.sv
    ├── sim/
    │   └── modelsim_run.do
    └── docs/
        └── architecture.md

## Milestones

| Milestone | Target Day | Description |
|-----------|------------|-------------|
| M1 | Day 21 | alu_core.sv — all 10 ops |
| M2 | Day 23 | register_file + pipeline_reg |
| M3 | Day 25 | Full 5-stage pipeline top |
| M4 | Day 27 | hazard + forwarding units |
| M5 | Day 29 | ModelSim simulation |
| M6 | Day 31 | UVM testbench begins |

## Design Decisions

- Word width: 32-bit (RV32I)
- Reset: Synchronous, active-high
- Forwarding: Full EX-EX and MEM-EX
- Simulation tool: ModelSim
