# Day 15 — Build a Circuit from a Simulation Waveform
## HDLBits | Combinational Circuits 1–5
**Date:** 2026-06-04
**Section:** Build a Circuit from a Simulation Waveform

---

## Overview
This section tests reverse-engineering skills — given a simulation
waveform, identify the logic function and implement it.
Inputs often cycle like a binary counter; some inputs are decoys.

---

## Problem 1 — Combinational Circuit 1
**Inputs:** a, b | **Output:** q
**Circuit:** 2-input AND gate
```sv
assign q = a & b;
```
**Key observation:** q=1 only when both a=1 and b=1 simultaneously.

---

## Problem 2 — Combinational Circuit 2
**Inputs:** a, b, c, d | **Output:** q
**Circuit:** 4-input XNOR (even parity checker)
```sv
assign q = ~(a ^ b ^ c ^ d);
```
**Key observation:** q=1 when even number of inputs are HIGH.
XOR chain detects odd parity; invert gives even parity.

---

## Problem 3 — Combinational Circuit 3
**Inputs:** a, b, c, d | **Output:** q
**Circuit:** (a|b) & (c|d)
```sv
assign q = (a | b) & (c | d);
```
**Key observation:** Two groups {a,b} and {c,d}.
At least one from each group must be HIGH.
SOP form: (a&c)|(a&d)|(b&c)|(b&d) — factors cleanly.

---

## Problem 4 — Combinational Circuit 4
**Inputs:** a, b, c, d | **Output:** q
**Circuit:** 2-input OR gate on b and c
```sv
assign q = b | c;
```
**Key observation:** q=0 only when b=0 AND c=0 together.
Inputs a and d are decoys.

---

## Problem 5 — Combinational Circuit 5
**Inputs:** a,b,c,d,e (4-bit each) | **Output:** q (4-bit)
**Circuit:** 4-to-1 Multiplexer with c as select
```sv
always @(*) begin
    case (c)
        4'd0: q = b;
        4'd1: q = e;
        4'd2: q = a;
        4'd3: q = d;
        default: q = 4'hf;
    endcase
end
```
**Key observation:** c acts as a 4-bit selector. Non-standard
MUX — select and data are same width. default=4'hf covers
c values 4–15. Use `always @(*)` with `case` for clean MUX coding.

---

## Key Takeaways — Day 15

| # | Circuit | Function |
|---|---------|----------|
| 1 | Comb 1  | AND (a,b) |
| 2 | Comb 2  | 4-input XNOR / even parity |
| 3 | Comb 3  | (a\|b) & (c\|d) |
| 4 | Comb 4  | OR (b,c) |
| 5 | Comb 5  | 4-to-1 MUX, select=c |

## Waveform Reading Strategy
1. Check if inputs cycle like a binary counter
2. Find when q=0 — identify which inputs are all 0
3. Find when q=1 — identify common pattern
4. Check for decoy inputs (no correlation with q)
5. Try XOR/XNOR if pattern matches parity
6. Try factoring SOP to find clean gate structure

## Concepts Reinforced
- AND, OR, NOT, XNOR gate identification from waveforms
- Even parity detection using XOR chain
- Multiplexer using case statement
- Decoy input identification
- SOP factoring: (a&c)|(a&d)|(b&c)|(b&d) = (a|b)&(c|d)
