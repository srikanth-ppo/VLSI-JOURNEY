# Day 25 — Hazard Unit + Forwarding Unit
## VLSI Journey — Q1 Project Phase
**Date:** 2026-06-16
**Status:** ✅ Both modules coded, simulated, verified

---

## Module 1 — hazard_unit.sv

**Type:** Combinational
**Purpose:** Detects load-use RAW hazards, generates stall

### Port Summary
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| id_ex_rd | in | 5 | Destination reg in EX stage |
| id_ex_mem_read | in | 1 | Is EX stage a load? |
| if_id_rs1 | in | 5 | Source reg 1 of incoming instr |
| if_id_rs2 | in | 5 | Source reg 2 of incoming instr |
| stall | out | 1 | Stall pipeline |
| flush_idex | out | 1 | Flush ID/EX register |

### Hazard Condition
if (id_ex_mem_read &&

(id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs2) &&

id_ex_rd != x0)

→ stall=1, flush_idex=1

### Test Results
- Test1 - No hazard   → PASS ✅
- Test2 - Hazard rs1  → PASS ✅
- Test3 - Hazard rs2  → PASS ✅
- Test4 - Not a load  → PASS ✅
- Test5 - rd is x0    → PASS ✅

---

## Module 2 — forwarding_unit.sv

**Type:** Combinational
**Purpose:** Eliminates RAW hazards by forwarding results

### Port Summary
| Port | Dir | Width | Description |
|------|-----|-------|-------------|
| ex_rs1 | in | 5 | EX stage source reg 1 |
| ex_rs2 | in | 5 | EX stage source reg 2 |
| exmem_rd | in | 5 | EX/MEM destination reg |
| exmem_we | in | 1 | EX/MEM write enable |
| memwb_rd | in | 5 | MEM/WB destination reg |
| memwb_we | in | 1 | MEM/WB write enable |
| forward_a | out | 2 | Forward select for rs1 |
| forward_b | out | 2 | Forward select for rs2 |

### Forward Select Encoding
| forward_a/b | Source |
|-------------|--------|
| 2'b00 | No forward — use register file |
| 2'b01 | Forward from MEM/WB stage |
| 2'b10 | Forward from EX/MEM stage |

### Priority Rule
EX/MEM forwarding takes priority over MEM/WB.
Most recent result always wins.

### Test Results
- Test1 - No forward      → PASS ✅
- Test2 - EX-EX fwd rs1   → PASS ✅
- Test3 - EX-EX fwd rs2   → PASS ✅
- Test4 - MEM-WB fwd rs1  → PASS ✅
- Test5 - MEM-WB fwd rs2  → PASS ✅
- Test6 - EX-EX priority  → PASS ✅
- Test7 - we=0 no fwd     → PASS ✅

---

## Key Concepts

### RAW Hazard — Read After Write
Occurs when an instruction reads a register that
a previous instruction hasn't written back yet.

Example:
LW  x3, 0(x1)   ← writes x3 in MEM stage

ADD x4, x3, x2  ← reads x3 in EX stage (too early!)
Solution: stall for 1 cycle + insert bubble

### Forwarding — Why it matters
Without forwarding: every RAW hazard = 1-2 stall cycles
With forwarding: most RAW hazards resolved with 0 stalls
Performance improvement: significant in real workloads

### Complete Module Hierarchy
risc_v_alu_top.sv

├── alu_core.sv          ← Day 22 ✅

├── pipeline_reg.sv      ← Day 23 ✅

├── register_file.sv     ← Day 23 ✅

├── hazard_unit.sv       ← Day 25 ✅

└── forwarding_unit.sv   ← Day 25 ✅

All 5 RTL modules complete and verified!

---

## Tomorrow — Day 26
Integrate hazard_unit and forwarding_unit into
risc_v_alu_top.sv — complete final pipeline with
full hazard handling and forwarding paths.
