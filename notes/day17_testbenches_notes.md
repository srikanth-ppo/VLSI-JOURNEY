# Day 17 — Testbenches
## HDLBits | Testbench Writing — Problems 1–5
**Date:** 2026-06-06

---

## Problem 1 — Clock Generation
**Task:** Instantiate dut, drive 10ps clock starting at 0

```sv
initial clk = 0;
always #5 clk = ~clk;  // toggle every 5 → period=10
```
**Key:** init to 0 + toggle at #5 → first transition is 0→1 at t=5. ✅

---

## Problem 2 — Waveform Generation
**Task:** Produce exact A, B waveform using initial block

```sv
initial begin
    A = 0; B = 0;
    #10 A = 1;
    #5  B = 1;
    #5  A = 0;
    #20 B = 0;
end
```
**Key:** #delay is RELATIVE to previous statement, not absolute.
Check if signals hold for long stretches before assuming repeat.

| Time | A | B |
|------|---|---|
| 0    | 0 | 0 |
| 10   | 1 | 0 |
| 15   | 1 | 1 |
| 20   | 0 | 1 |
| 40   | 0 | 0 |

---

## Problem 3 — AND Gate Testbench
**Task:** Test all 4 input combinations of andgate

```sv
initial begin
    in = 2'b00;
    #10 in = 2'b01;
    #10 in = 2'b10;
    #10 in = 2'b11;
end
```
**Key:** DUT inputs → reg | DUT outputs → wire.
Uniform #10 delays unless waveform shows otherwise.
No $finish needed for simple HDLBits testbenches.

---

## Problem 4 — q7 Module Testbench
**Task:** Drive clk, in, s[2:0] exactly per waveform

```sv
initial begin clk=0; forever #5 clk=~clk; end

initial begin
    in=0; s=3'd2;           // t=0
    #10   s=3'd6;           // t=10
    #10 in=1; s=3'd2;       // t=20
    #10 in=0; s=3'd7;       // t=30
    #10 in=1; s=3'd0;       // t=40
    #30 in=0;               // t=70
end
```
**Key:** When multiple signals change at same time,
assign them together with no delay between.
Use forever loop for clock in separate initial block.

---

## Problem 5 — T Flip-Flop Testbench
**Task:** Reset TFF then toggle to q=1

```sv
initial begin clk=0; forever #5 clk=~clk; end

initial begin
    reset = 1; t = 0;
    #10 reset = 0; t = 1;
end
```
**Key:** #10 = one full clock cycle (period=10).
Reset for one cycle → deassert reset → assert t=1 → q toggles to 1.
Simple and clean — no need for @(posedge clk) here.

---

## Testbench Essentials Summary

| Concept | Rule |
|---------|------|
| DUT inputs | declare as `reg` |
| DUT outputs | declare as `wire` |
| Clock gen | `initial clk=0; forever #5 clk=~clk;` |
| Stimulus | separate `initial` block from clock |
| Delays | `#N` is relative to previous statement |
| Clock-aligned stimulus | use `@(posedge clk)` for synchronous signals |
| Multiple signals same time | assign on same line or back-to-back, no delay |
| Simulation end | `$finish` optional for HDLBits |

## always #5 vs forever #5
- `always #5 clk = ~clk` — concurrent always block
- `initial begin forever #5 clk=~clk; end` — procedural thread
- Both produce identical clocks; `forever` is more explicit
