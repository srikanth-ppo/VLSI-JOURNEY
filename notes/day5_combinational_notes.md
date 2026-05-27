# Day 5 — Combinational Logic (25 May 2026)
## Q1 - RTL Mastery | HDLBits Combinational Logic Sections

---

## Sections Covered Today
1. Basic Gates
2. Multiplexers
3. Arithmetic Circuits
4. Karnaugh Maps

---

## BASIC GATES

### All 7 fundamental gates:
    AND   a & b       1 only if BOTH are 1
    OR    a | b       1 if EITHER is 1
    XOR   a ^ b       1 if inputs are DIFFERENT
    NAND  ~(a & b)    0 only if BOTH are 1
    NOR   ~(a | b)    1 only if BOTH are 0
    XNOR  ~(a ^ b)    1 if inputs are SAME
    ANOTB a & ~b      1 if a=1 AND b=0

### Hardware thinking — output first:
Instead of "if ring then motor=1", think:
    motor  = ring & vibrate_mode
    ringer = ring & ~vibrate_mode
This is the hardware design mindset — describe what
conditions make each output true.

### Truth table to SOP:
For each row where output=1, write an AND term.
OR all those terms together.
    Row 2 (010): ~x3 & x2 & ~x1
    Row 3 (011): ~x3 & x2 &  x1
    f = row2 | row3 | ...

---

## MULTIPLEXERS

### 2to1 mux:
    assign out = sel ? b : a;
Works for any width — 1-bit, 100-bit, same syntax.

### 9to1 mux - use case statement:
    always @(*) begin
        case(sel)
            4'd0: out = a;
            ...
            default: out = 16'hFFFF;
        endcase
    end

### 256to1 mux - variable indexing:
    assign out = in[sel];         // 1-bit output
    assign out = in[sel*4 +: 4];  // 4-bit output

The +: operator is a variable part-select:
    in[base +: width] selects width bits from base upward
    sel*4 computes starting position for each 4-bit group

---

## ARITHMETIC CIRCUITS

### Half adder (no carry-in):
    assign sum  = a ^ b;
    assign cout = a & b;

### Full adder (with carry-in):
    assign {cout, sum} = a + b + cin;
The {cout, sum} concatenation captures the 2-bit result.
Upper bit = carry, lower bit = sum.

### Ripple carry adder:
Chain full adders — cout of each feeds cin of next:
    assign {cout[0], sum[0]} = a[0] + b[0] + cin;
    assign {cout[1], sum[1]} = a[1] + b[1] + cout[0];
    assign {cout[2], sum[2]} = a[2] + b[2] + cout[1];

### Signed overflow detection:
Overflow when two same-sign numbers produce opposite sign:
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
    Pos + Pos = Neg → overflow
    Neg + Neg = Pos → overflow
    Mixed signs     → never overflow

### Large adders - let Verilog handle it:
    assign {cout, sum} = a + b + cin;  // works for any width

### BCD adder - instantiate modules:
Each BCD digit is 4 bits. Chain bcd_fadd modules:
    bcd_fadd d0(.a(a[3:0]), .b(b[3:0]), .cin(cin), ...);
    bcd_fadd d1(.a(a[7:4]), .b(b[7:4]), .cin(c1),  ...);

---

## KARNAUGH MAPS

### What is a K-map?
A visual tool to simplify Boolean expressions.
Rows and columns use Gray code order (00,01,11,10)
so adjacent cells differ by only one bit.

### Sum of Products (SOP):
Group 1s in powers of 2 (1,2,4,8 cells).
Each group gives one AND term.
OR all terms together.

    out = (~a & ~d) | (b & c) | ...

### Product of Sums (POS):
Group 0s in powers of 2.
Each group gives one OR term (inverted variables).
AND all terms together.

### Don't cares (d):
Can be treated as 0 or 1 — use whichever makes
larger groups possible → simpler expression.

### Key patterns:
Checkerboard pattern → XOR:
    out = a ^ b ^ c ^ d

Only one 0 in map → invert the 0 condition:
    out = a | b | c  (De Morgan's of the single 0)

### Variable part-select +: operator:
    in[base +: width]   select width bits upward from base
    in[base -: width]   select width bits downward from base

Used for accessing packed arrays with variable index.

### Neighbour comparison pattern:
    out_both      = in[N-2:0] & in[N-1:1]  // AND with left neighbour
    out_any       = in[N-1:1] | in[N-2:0]  // OR with right neighbour
    out_different = in ^ {in[0], in[N-1:1]} // XOR with wrap-around

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | Wire/GND | Constant output |
| 2 | NOR gate | ~(a\|b) |
| 3 | Two gates | XNOR + XOR chain |
| 4 | All 7 gates | AND OR XOR NAND NOR XNOR ANOTB |
| 5 | 7420 chip | 4-input NAND |
| 6 | Truth table | SOP form |
| 7 | 2-bit equality | == operator |
| 8 | Combine A+B | Module hierarchy + gates |
| 9 | Ring/vibrate | Hardware thinking |
| 10 | Thermostat | mode as selector |
| 11 | 3-bit popcount | addition trick |
| 12 | Gates vectors 4bit | Neighbour comparison |
| 13 | Gates vectors 100bit | Same pattern scaled |
| 14 | 2to1 mux 1bit | Ternary operator |
| 15 | 2to1 mux 100bit | Ternary on vectors |
| 16 | 9to1 mux | case statement |
| 17 | 256to1 mux 1bit | Variable indexing |
| 18 | 256to1 mux 4bit | +: part select |
| 19 | Half adder | XOR + AND |
| 20 | Full adder | {cout,sum} = a+b+cin |
| 21 | 3-bit adder | Ripple carry chain |
| 22 | 4-bit adder | Simple + operator |
| 23 | Overflow detect | Sign bit comparison |
| 24 | 100-bit adder | {cout,sum} scaled |
| 25 | 4-digit BCD adder | Module instantiation |
| 26 | 3-var kmap | a\|b\|c |
| 27 | 4-var kmap | a^b^c^d |
| 28 | Kmap don't cares | a\|(~b&c) |
| 29 | SOP and POS | (c&d)\|(~a&~b&c) |
| 30 | Kmap 4-input | (~x3&x1)\|(x1&x2&x4) wait |
| 31 | Mux kmap | mux_in per ab value |

---

## The Golden Rule of Day 5
Think about outputs first, not inputs.
"The output should be 1 when..."
not
"If the input is... then..."
This is the hardware design mindset.

---

## What's Next (Day 6)
- HDLBits: Sequential Logic
- Latches and Flip Flops
- D flip flop, T flip flop, JK flip flop
- Registers and counters
- This is where clocked always blocks become the focus
