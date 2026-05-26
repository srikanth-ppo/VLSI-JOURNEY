# Day 6 — Sequential Logic: Latches and Flip Flops (26 May 2026)
## Q1 - RTL Mastery | HDLBits Sequential Logic Section

---

## What is Sequential Logic?
Combinational logic: output depends only on current inputs
Sequential logic:    output depends on current inputs AND past history

Sequential logic has MEMORY — it remembers previous states.
Everything with memory in a chip is sequential:
registers, counters, state machines, caches, pipelines.

---

## Concept 1 — D Flip Flop (the most fundamental building block)

    always @(posedge clk)
        q <= d;

At every rising clock edge: q captures d and holds it.
Think of it like a photograph — freezes d at the clock edge.

    clk:  ___/‾‾‾\___/‾‾‾\___
    d:    ___/‾‾‾‾‾‾‾\______
    q:    ______/‾‾‾‾‾‾‾\___
                 ↑
            captured here

Rules:
- Always use always @(posedge clk)
- Always use <= non-blocking
- Output must be reg

Vector registers work identically — just add [7:0] to ports.
All bits captured simultaneously on the same clock edge.

---

## Concept 2 — Reset Types

SYNCHRONOUS RESET (reset only at clock edge):
    always @(posedge clk) begin
        if (reset) q <= 0;
        else       q <= d;
    end
    - reset is NOT in sensitivity list
    - Cleaner timing, preferred in most designs

ASYNCHRONOUS RESET (reset immediately):
    always @(posedge clk or posedge areset) begin
        if (areset) q <= 0;
        else        q <= d;
    end
    - areset IS in sensitivity list
    - Triggers instantly without waiting for clock
    - Used when immediate reset at power-up is needed

ACTIVE-LOW RESET (reset when signal = 0):
    if (~resetn) q <= 0;  // n suffix = active low
    - Invert the condition
    - Common in real chips (reset pin is active low)

NON-ZERO RESET VALUE:
    if (reset) q <= 8'h34;  // reset to hex 34
    - Reset to any value, not just 0
    - Used for initialising state machines, counters

NEGEDGE TRIGGER:
    always @(negedge clk)  // triggers on falling edge
    - Just swap posedge for negedge

---

## Concept 3 — Byte Enable
Selectively write only parts of a register:

    if (byteena[1]) q[15:8] <= d[15:8];  // upper byte
    if (byteena[0]) q[7:0]  <= d[7:0];   // lower byte

No else needed — missing assignment in clocked block
holds previous value (not a latch, intentional memory).
Used in memory controllers, bus interfaces, CPU register files.

---

## Concept 4 — D Latch vs D Flip Flop

D LATCH (level sensitive):
    always @(*) begin
        if (ena) q = d;  // no else — intentional
    end
    - q follows d WHILE ena=1
    - Holds last value when ena=0
    - Usually AVOIDED (timing problems, glitch sensitive)
    - Missing else IS intentional here

D FLIP FLOP (edge sensitive):
    always @(posedge clk) q <= d;
    - q captures d ONLY AT clock edge
    - Preferred in all synchronous designs

---

## Concept 5 — Feedback in Sequential Logic

OR FEEDBACK (sticky set):
    always @(posedge clk)
        out <= in | out;
    Once out=1, it stays 1 forever (can't be cleared)
    Used for: status flags, event capture registers

XOR FEEDBACK (toggle / T flip flop):
    always @(posedge clk)
        out <= in ^ out;
    in=1 → out toggles every clock
    in=0 → out holds
    Used for: T flip flops, frequency dividers, counters

---

## Concept 6 — Mux + DFF Patterns

PARALLEL LOAD SHIFT REGISTER STAGE:
    Q <= L ? r_in : q_in;
    L=1 → load preset value
    L=0 → shift (pass previous stage's output)

UNIVERSAL SHIFT REGISTER STAGE (3 modes):
    Q <= L ? R : (E ? w : Q);
    L=1     → load R (parallel load)
    L=0,E=1 → shift w (shift mode)
    L=0,E=0 → hold Q (no change)

---

## Concept 7 — JK Flip Flop from D Flip Flop

JK truth table:
    J=0,K=0 → hold    (Q stays same)
    J=0,K=1 → reset   (Q=0)
    J=1,K=0 → set     (Q=1)
    J=1,K=1 → toggle  (Q flips)

D equation derived from truth table:
    D = (J & ~Q) | (~K & Q)

    always @(posedge clk)
        Q <= (j & ~Q) | (~k & Q);

This derivation method is tested in every VLSI interview.
Know how to convert between flip flop types.

---

## Concept 8 — Edge Detection

POSITIVE EDGE (0→1 transition):
    prev  <= in;
    pedge <= in & ~prev;

NEGATIVE EDGE (1→0 transition):
    prev  <= in;
    nedge <= ~in & prev;

ANY EDGE (either transition):
    prev    <= in;
    anyedge <= in ^ prev;

Why XOR for any edge?
XOR = 1 when bits are DIFFERENT = transition occurred

STICKY CAPTURE (latch until reset):
    out <= out | (prev & ~in);  // set on 1→0
    if (reset) out <= 0;        // clear on reset

Used in: interrupt controllers, status registers,
button debouncing, protocol decoders.

---

## Concept 9 — Dual Edge Triggered DFF Emulation

FPGAs don't have dual-edge DFFs.
Emulate with posedge + negedge DFF + mux:

    always @(posedge clk) p <= d;  // captures at rising
    always @(negedge clk) n <= d;  // captures at falling
    assign q = clk ? p : n;        // mux by clock phase

clk=1 (high) → show posedge result
clk=0 (low)  → show negedge result

---

## The 3 DFF Patterns to Memorise

    // 1. Basic
    always @(posedge clk)
        q <= d;

    // 2. Synchronous reset
    always @(posedge clk)
        if (rst) q <= 0; else q <= d;

    // 3. Asynchronous reset
    always @(posedge clk or posedge arst)
        if (arst) q <= 0; else q <= d;

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | Single DFF | Basic posedge clk |
| 2 | 8-bit register | Vector DFF |
| 3 | Sync reset register | if(reset) in clocked block |
| 4 | Negedge + reset to 0x34 | negedge, non-zero reset |
| 5 | Async reset register | posedge clk or posedge areset |
| 6 | Byte enable register | Selective write + active-low reset |
| 7 | D latch | always@(*) with intentional missing else |
| 8 | DFF async reset | 1-bit version |
| 9 | DFF sync reset | 1-bit version |
| 10 | OR feedback DFF | Sticky set register |
| 11 | XOR feedback DFF | Toggle / T flip flop |
| 12 | Shift reg stage | Mux + DFF parallel load |
| 13 | Universal shift stage | 3-mode mux + DFF |
| 14 | FSM from circuit | 3 DFFs with different feedback |
| 15 | JK flip flop | D equation derivation |
| 16 | Positive edge detect | in & ~prev |
| 17 | Any edge detect | in ^ prev |
| 18 | Sticky capture | out | (prev & ~in) |
| 19 | Dual edge DFF | posedge + negedge + mux |

---

## The Golden Rule of Day 6
Every circuit that remembers something is a flip flop.
Every flip flop in a real chip is one of these 3 patterns.
Master these and you can build any sequential circuit.

---

## What's Next (Day 7)
- HDLBits: Counters
- Binary counters, BCD counters
- Up/down counters with load
- These are built directly from what you learned today
