# Day 8 — Shift Registers & Cellular Automata (28 May 2026)
## Q1 - RTL Mastery | HDLBits Shift Registers Section

---

## What is a Shift Register?
A chain of flip flops where data moves one position
per clock cycle. Used for serial communication,
delay lines, and data conversion.

    in → [DFF0] → [DFF1] → [DFF2] → [DFF3] → out
    
After 4 clock cycles, in appears at out.
This is a 4-cycle delay line.

---

## Concept 1 — Basic Shift Register Operations

RIGHT SHIFT (data moves toward LSB):
    q <= {1'b0, q[3:1]};
    MSB filled with 0, LSB falls off

    Before: q = 1011
    After:  q = 0101  (shifted right by 1)

LEFT SHIFT (data moves toward MSB):
    q <= {q[2:0], 1'b0};
    LSB filled with 0, MSB falls off

    Before: q = 1011
    After:  q = 0110  (shifted left by 1)

ARITHMETIC RIGHT SHIFT (fill with sign bit):
    q <= {q[63], q[63:1]};  // fill with MSB
    Preserves sign for signed numbers.

    q = 1100 → arith >>1 → 1110 (negative stays negative)
    q = 0100 → arith >>1 → 0010 (positive stays positive)

ROTATION (wrap around, nothing lost):
    Right rotate: q <= {q[0], q[99:1]};
    Left rotate:  q <= {q[98:0], q[99]};

---

## Concept 2 — Priority in Shift Registers

Standard priority order:
    1. async reset → immediate (in sensitivity list)
    2. load        → synchronous, load data
    3. enable/shift → shift data
    4. hold        → default (no else needed)

    always @(posedge clk or posedge areset) begin
        if (areset)    q <= 0;      // highest priority
        else if (load) q <= data;   // second
        else if (ena)  q <= {0, q[3:1]}; // third
        // hold is implicit
    end

---

## Concept 3 — LFSR (Linear Feedback Shift Register)

A shift register with XOR feedback at tap positions.
Produces pseudo-random sequences.

GALOIS LFSR structure:
    - Shift right every cycle
    - Output bit (q[0]) XORs with tap positions
    - Non-tap positions just shift

    Tap at position N:     q[N-1] <= q[N] ^ q[0]
    No tap at position N:  q[N-1] <= q[N]

Why reset to 1 not 0?
    All-zeros state is a dead state — LFSR gets stuck.
    Maximum length = 2^n - 1 states.

ASCII timing (5-bit LFSR starting at 1):
    clk: ↑   ↑   ↑   ↑   ↑   ↑   ↑
    q:   1   10  05  14  0a  11  19 ...→ 31 states → repeat

Real world uses:
    - PCIe, SATA, USB 3.0 data scrambling
    - Built-in Self Test (BIST)
    - CRC calculation
    - Pseudo-random test pattern generation

---

## Concept 4 — Shift Register with Parallel Load

Mux between serial shift and parallel load:
    Q <= L ? R : (E ? w : Q);
    L=1     → load R (parallel load mode)
    L=0,E=1 → shift w (serial shift mode)
    L=0,E=0 → hold Q (no change)

This is a universal shift register stage.
Used in serial-to-parallel and parallel-to-serial conversion.

---

## Concept 5 — LUT (Look-Up Table)

An 8-bit shift register used as a 3-input truth table:
    Shift in 8 bits = truth table values
    ABC selects which bit = output

    assign Z = Q[{A, B, C}];

This is EXACTLY how FPGA logic cells work internally!
Every FPGA LUT is a programmable shift register + mux.

---

## Concept 6 — Cellular Automata

1D and 2D systems where each cell updates based on neighbours.

RULE 90 (1D):
    next[i] = left ^ right
    Produces Sierpiński triangle fractal pattern

    ASCII (starting from q=1):
           1
          10
         101
        1000
       10100

Vector shift trick for all cells at once:
    L = {q[510:0], 1'b0}  // all left neighbours
    R = {1'b0, q[511:1]}  // all right neighbours
    next = L ^ R           // all cells updated in one line

RULE 110 (1D, Turing complete):
    next = direct SOP from truth table
    0 only when LCR=000, 100, or 111

GAME OF LIFE (2D):
    Each cell counts 8 neighbours
    0-1 neighbours → dies
    2 neighbours   → stays same
    3 neighbours   → becomes alive
    4+ neighbours  → dies

    Toroidal wrapping: edges connect to opposite edges
    row wrapping: (row+1)%16, (row-1+16)%16
    col wrapping: (col+1)%16, (col-1+16)%16

---

## Key Shift Operations Summary
    Right shift 1:       {1'b0, q[N-1:1]}
    Left shift 1:        {q[N-2:0], 1'b0}
    Right shift 8:       {8'b0, q[N-1:8]}
    Left shift 8:        {q[N-9:0], 8'b0}
    Arith right 1:       {q[N-1], q[N-1:1]}
    Arith right 8:       {{8{q[N-1]}}, q[N-1:8]}
    Rotate right:        {q[0], q[N-1:1]}
    Rotate left:         {q[N-2:0], q[N-1]}

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | 4-bit shift register | async reset, load, enable priority |
| 2 | 100-bit rotator | rotate left/right with case |
| 3 | 64-bit arithmetic shift | sign bit fill, shift by 1 or 8 |
| 4 | 5-bit Galois LFSR | tap positions XOR feedback |
| 5 | 3-bit LFSR + load | parallel load + XOR feedback |
| 6 | 32-bit Galois LFSR | taps at 32,22,2,1 |
| 7 | 4-bit delay line | shift register as delay |
| 8 | Universal shift register | 3-mode: load/shift/hold |
| 9 | 3-input LUT | shift reg as truth table |
| 10 | Rule 90 automaton | XOR neighbours, vector trick |
| 11 | Rule 110 automaton | SOP from truth table |
| 12 | Game of Life | 2D toroidal neighbour count |

---

## The Golden Rule of Day 8
A shift register is just a pipeline of flip flops.
Data enters one end and exits the other.
Feedback makes it an LFSR.
Parallel load makes it a universal shift register.
Content addressing makes it a LUT.

---

## What's Next (Day 9)
- HDLBits: Finite State Machines (FSMs)
- Moore and Mealy machines
- One-hot and binary encoding
- FSMs are the most important topic for VLSI interviews
