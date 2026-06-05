# Day 16 — Build a Circuit from a Simulation Waveform
## HDLBits | Combinational Circuit 6 + Sequential Circuits 7–10
**Date:** 2026-06-05

---

## Problem 1 — Combinational Circuit 6
**Circuit:** 8×16 ROM / Lookup Table
**Key:** No arithmetic pattern → pure case-based LUT.
Maps to FPGA Block RAM or distributed LUTs in synthesis.

## Problem 2 — Sequential Circuit 7
**Circuit:** D flip-flop with inverted input
```sv
always @(posedge clk) q <= ~a;
```
**Key:** q=~a, registered. Hatched start = uninitialized state X.

## Problem 3 — Sequential Circuit 8
**Circuit:** Master-Slave D Flip-Flop
```sv
always @(*)          if (clock) p = a;  // latch
always @(negedge clock)         q <= p; // slave FF
```
| Stage  | Type    | Trigger        | Captures |
|--------|---------|----------------|----------|
| Master | D Latch | clock=1 (level)| a        |
| Slave  | D FF    | negedge clock  | p        |

**Key:** How real CMOS flip-flops are built internally.

## Problem 4 — Sequential Circuit 9
**Circuit:** Mod-7 counter (0–6) with synchronous load to 4
```sv
if (a)         q <= 4'd4;  // load to 4, NOT reset to 0
else if (q==6) q <= 4'd0;  // wrap
else           q <= q + 1; // increment
```
**Key:** a=1 loads 4 (not 0). Always read exact reset value from waveform!

## Problem 5 — Sequential Circuit 10
**Circuit:** Mealy Machine — Last Agreement Register
```sv
always @(posedge clk)
    if (a == b) state <= a;  // holds when a != b

assign q = state ? (a ~^ b) : (a ^ b);
```
| state | q output  |
|-------|-----------|
| 1     | a XNOR b  |
| 0     | a XOR b   |

**Key:** Mealy machine — q depends on state AND current inputs.

---

## Full Waveform Section Summary (Day 15 + 16)

| Day | # | Circuit | Key Concept |
|-----|---|---------|-------------|
| 15  | 1 | Comb 1  | AND gate |
| 15  | 2 | Comb 2  | 4-input XNOR / even parity |
| 15  | 3 | Comb 3  | (a\|b)&(c\|d) SOP factoring |
| 15  | 4 | Comb 4  | OR(b,c) — decoy inputs |
| 15  | 5 | Comb 5  | 4-to-1 MUX via case |
| 16  | 6 | Comb 6  | 8×16 ROM / LUT |
| 16  | 7 | Seq 7   | DFF with inverted input |
| 16  | 8 | Seq 8   | Master-slave FF |
| 16  | 9 | Seq 9   | Mod-7 counter + sync load |
| 16  | 10| Seq 10  | Mealy machine XOR/XNOR |

## Waveform Reading Checklist
- Output changes at clock edge? → Sequential. Instantly? → Combinational
- posedge or negedge? Read carefully
- Counter wrap point AND load value — both matter
- Does output depend on inputs only (Moore) or inputs+state (Mealy)?
- Decoy inputs — always verify all inputs actually affect output
