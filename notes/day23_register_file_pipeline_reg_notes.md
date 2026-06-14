# Day 23 — Register File + Pipeline Register
## VLSI Journey — Q1 Project Phase
**Date:** 2026-06-12
**Status:** ✅ Both modules coded, simulated, verified

---

## Module 1 — register_file.sv

**Type:** Sequential (synchronous write, async read)
**Size:** 32 registers × 32 bits = 1024 bits total

### Port Summary
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| clk | in | 1 | Clock |
| rst | in | 1 | Sync reset |
| rs1_addr | in | 5 | Read port 1 address |
| rs2_addr | in | 5 | Read port 2 address |
| rs1_data | out | 32 | Read port 1 data |
| rs2_data | out | 32 | Read port 2 data |
| we | in | 1 | Write enable |
| rd_addr | in | 5 | Write address |
| rd_data | in | 32 | Write data |

### Key Design Rules
- x0 hardwired to 0 — write ignored, read always 0
- Write: synchronous on posedge clk
- Read: asynchronous (combinational assign)
- Reset: clears all 32 registers to 0

### Test Results
- Test1 - Write/Read x1  → PASS ✅
- Test2 - Write/Read x2  → PASS ✅
- Test3 - x0 always 0    → PASS ✅
- Test4 - Dual read      → PASS ✅
- Test5 - Reset clears   → PASS ✅

---

## Module 2 — pipeline_reg.sv

**Type:** Sequential — parameterized register
**Purpose:** Stage boundary register in 5-stage pipeline

### Port Summary
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| clk | in | 1 | Clock |
| rst | in | 1 | Sync reset |
| stall | in | 1 | Hold value |
| flush | in | 1 | Clear to 0 |
| d | in | WIDTH | Data in |
| q | out | WIDTH | Data out |

### Control Signal Priority
| rst/flush | stall | Action |
|-----------|-------|--------|
| 1 | x | q <= 0 (bubble) |
| 0 | 1 | q holds |
| 0 | 0 | q <= d (normal) |

### Test Results
- Test1 - Normal  → PASS ✅
- Test2 - Stall   → PASS ✅
- Test3 - Flush   → PASS ✅
- Test4 - Resume  → PASS ✅
- Test5 - Reset   → PASS ✅

---

## Key Concepts Reinforced

### Why async read in register file?
In RISC-V pipeline, register values must be available
immediately in ID stage without waiting for clock edge.
Synchronous read would add one extra cycle latency.

### Why parameterized pipeline_reg?
Each pipeline stage carries different signal bundles:
- IF/ID: 64 bits (instruction + PC)
- ID/EX: 100+ bits (data + control)
One parameterized module handles all stages cleanly.

### Stall vs Flush
- Stall: pipeline pauses — instruction waits (RAW hazard)
- Flush: pipeline clears — instruction discarded (branch)

---

## Tomorrow — Day 24
Build risc_v_alu_top.sv — connect all modules:
alu_core + register_file + pipeline_reg → full pipeline
### EX/MEM Register — 40 bits
[39:8] = alu_result (32 bits)

[7]    = zero       (1 bit)

[6]    = negative   (1 bit)

[5]    = overflow   (1 bit)

[4:0]  = rd_addr    (5 bits)

---

## Test Results

| Test | Operation | Expected | Status |
|------|-----------|----------|--------|
| 1 | ADD x1+x2 | 30 | PASS ✅ |
| 2 | SUB x2-x1 | 10 | PASS ✅ |
| 3 | AND x3&x4 | 0x0F0F | PASS ✅ |
| 4 | OR  x3\|x4 | 0xFFFF | PASS ✅ |
| 5 | XOR x3^x4 | 0xF0F0 | PASS ✅ |
| 6 | STALL | holds | PASS ✅ |
| 7 | FLUSH | clears | PASS ✅ |

---

## Key Concepts Applied

### Signal Packing/Unpacking
Bundling multiple signals into one wide bus for
pipeline register:
```sv
assign idex_in = {rs1_data_id, rs2_data_id, rd_addr_in, alu_ctrl_in};
assign {rs1_data_ex, rs2_data_ex, rd_addr_ex, alu_ctrl_ex} = idex_out;
```
Clean, readable, synthesizable. Width must match exactly.

### Pipeline Latency
2 cycle latency from input to output:
- Cycle 1: ID stage reads register file
- Cycle 2: ID/EX reg → EX stage ALU computes
- Cycle 3: EX/MEM reg → result available at output

### Stall Behavior
When stall=1: pipeline registers hold their values.
In-flight instruction pauses — no new data enters.

### Flush Behavior
When flush=1: pipeline registers clear to 0.
Inserts bubble — used on branch misprediction.

---

## Module Hierarchy — Complete So Far
risc_v_alu_top.sv      ← TODAY ✅

├── register_file.sv   ← Day 23 ✅

├── pipeline_reg.sv    ← Day 23 ✅ (used twice)

└── alu_core.sv        ← Day 22 ✅

---

## Tomorrow — Day 25
- hazard_unit.sv — RAW hazard detection
- forwarding_unit.sv — EX-EX and MEM-WB forwarding
- Integrate into top module
