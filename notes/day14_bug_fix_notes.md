# Day 14 — Bug Fixing Concepts (03 June 2026)

## Q1 - RTL Mastery | HDLBits Bug Fixing Problems

---

## What was covered today?

RTL debugging and fixing common Verilog design mistakes involving:

* Multiplexers
* Arithmetic circuits
* Case statements
* Width mismatches
* Latch inference
* Incorrect constants
* Combinational logic bugs

---

## Concept 1 — Width Mismatch Errors

Problem:
Signal widths were incorrectly declared.

Example:

```verilog id="zb01k0"
output out;
```

Fixed:

```verilog id="7xgq6k"
output [7:0] out;
```

Key lesson:
Bus widths must match connected signals.

---

## Concept 2 — Multiplexer Debugging

Implemented and debugged:

* 2:1 mux
* 4:1 mux

Key concepts:

* Bus-based muxing
* Hierarchical mux design
* Intermediate wire connections

Applications:

* Datapath selection
* ALU input selection
* Routing logic

---

## Concept 3 — Latch Inference Prevention

Problem:
Signals were not assigned in all paths.

Bad design causes:

* Unwanted latches
* Synthesis warnings
* Timing issues

Fixed by:
Assigning outputs in every combinational path.

Key lesson:
Combinational always blocks must fully assign outputs.

---

## Concept 4 — Case Statement Debugging

Fixed:

* Wrong hexadecimal constants
* Invalid case values
* Missing default assignments

Example:

```verilog id="lj7l2v"
8'd26
```

Correct:

```verilog id="gh0kpk"
8'h26
```

Key lesson:
Always verify radix and constant widths.

---

## Concept 5 — Combinational Logic Design

Used:

```verilog id="xqzvga"
always @(*)
```

Purpose:

* Automatic sensitivity list
* Proper combinational behavior

Key lesson:
Use always @(*) for combinational logic blocks.

---

## Problems Solved Today

| # | Problem      | Key Concept      |
| - | ------------ | ---------------- |
| 1 | Bugs_mux2    | Width mismatch   |
| 2 | Bugs_mux4    | Hierarchical mux |
| 3 | Bugs_addsubz | Latch prevention |
| 4 | Bugs_case    | Case debugging   |

---

## The Golden Rule of Day 14

Most RTL bugs come from:

1. Width mismatches
2. Missing assignments
3. Incorrect constants
4. Improper combinational logic

Careful signal declaration and complete assignments
prevent most synthesis and simulation errors.
