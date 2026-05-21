# Day 1 — Vectors in SystemVerilog (21 May 2026)
## Q1 - RTL Mastery | HDLBits Vectors Section

---

## What is a Vector?
A vector in SystemVerilog is a group of wires bundled together.
Instead of declaring 8 separate wires, you declare one 8-bit vector.

```verilog
wire a;           // single wire — 1 bit
wire [7:0] bus;   // vector — 8 bits bundled together
```

Think of it like a cable with multiple wires inside.
- [7:0] means bit 7 is the leftmost (MSB) and bit 0 is the rightmost (LSB)
- A 16-bit vector [15:0] has 16 wires bundled together

---

## Concept 1 — Vector Splitting
You can access individual bits of a vector using their index.

```verilog
input [2:0] vec;   // 3-bit input

assign o0 = vec[0];   // rightmost bit
assign o1 = vec[1];   // middle bit
assign o2 = vec[2];   // leftmost bit
```

Think of vec like a 3-seat row: seat 0, seat 1, seat 2.
You can pick any seat individually.

---

## Concept 2 — Vector Slicing
You can pick a range of bits from a vector using [high:low].

```verilog
input [15:0] in;

assign out_hi = in[15:8];   // upper 8 bits
assign out_lo = in[7:0];    // lower 8 bits
```

This is called slicing — like slicing a loaf of bread.
You pick from position X down to position Y.

Rule: the left number is always higher than the right number.
in[15:8] is valid. in[8:15] is NOT valid in Verilog.

---

## Concept 3 — Byte Reversal
A 32-bit word has 4 bytes. You can reverse their order by
slicing each byte and placing it in the opposite position.

```verilog
assign out[31:24] = in[7:0];    // byte 0 → top
assign out[23:16] = in[15:8];   // byte 1 → second
assign out[15:8]  = in[23:16];  // byte 2 → third
assign out[7:0]   = in[31:24];  // byte 3 → bottom
```

This is called endianness swapping — used in networking
and communication between different processor architectures.

---

## Concept 4 — Bitwise vs Logical Operators

### Bitwise Operators ( | & ^ ~ )
Works on each bit position separately. Output is N bits.

```verilog
a = 3'b101
b = 3'b110

a | b = 3'b111   // each bit OR'd separately
a & b = 3'b100   // each bit AND'd separately
a ^ b = 3'b011   // each bit XOR'd separately
~a    = 3'b010   // each bit flipped
```

### Logical Operators ( || && )
Treats the entire vector as true (non-zero) or false (zero).
Output is always just 1 bit.

```verilog
a = 3'b101   // non-zero = TRUE
b = 3'b000   // zero = FALSE

a || b = 1   // TRUE OR FALSE = TRUE
a && b = 0   // TRUE AND FALSE = FALSE
```

Key rule: Use | for hardware signal operations.
Use || only when you want a single true/false result.

---

## Concept 5 — Reduction Operators ( & | ^ )
Place the operator IN FRONT of a vector to fold all its
bits into a single 1-bit result.

```verilog
in = 4'b1111
&in = 1    // AND all bits: 1&1&1&1 = 1

in = 4'b1011
&in = 0    // AND all bits: 1&0&1&1 = 0

in = 4'b1000
|in = 1    // OR all bits: 1|0|0|0 = 1

in = 4'b0000
|in = 0    // OR all bits: 0|0|0|0 = 0

in = 4'b1011
^in = 1    // XOR all bits: 1^0^1^1 = 1 (odd number of 1s)
```

Shortcut to remember:
- &in → is everything 1? (all bits must be 1)
- |in → is anything 1? (at least one bit must be 1)
- ^in → is the count of 1s odd?

---

## Concept 6 — Concatenation Operator { }
Curly braces join multiple vectors/bits into one larger vector.

```verilog
wire [2:0] a = 3'b101;
wire [2:0] b = 3'b110;

wire [5:0] out = {a, b};   // out = 6'b101110
```

You can also use it on the LEFT side of assign to split:

```verilog
assign {out_hi, out_lo} = in;   // splits in into two halves
```

And you can mix vectors and constants:

```verilog
assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};
// 2'b11 = a 2-bit constant with value binary 11
```

---

## Concept 7 — Bit Reversal using Concatenation
Verilog does NOT allow reversed ranges like in[0:7].
So to reverse bits, pick them one by one in reverse order:

```verilog
assign out = {in[0], in[1], in[2], in[3],
              in[4], in[5], in[6], in[7]};
```

For very wide vectors (100 bits), use a generate loop instead.
You will learn that in a later session.

---

## Concept 8 — Replication Operator {N{x}}
Repeat a bit or vector N times.

```verilog
{4{1'b1}}       = 4'b1111
{3{2'b10}}      = 6'b101010
{24{in[7]}}     = in[7] repeated 24 times
```

Most common use: sign extension.
When converting a small signed number to a larger one,
you must copy the sign bit (MSB) to fill the extra bits.

```verilog
// 8-bit to 32-bit sign extension
assign out = {{24{in[7]}}, in};

// if in[7]=0: out = 00000000 00000000 00000000 [in]
// if in[7]=1: out = 11111111 11111111 11111111 [in]
```

Note the double braces: outer {} is concatenation,
inner {24{in[7]}} is replication. They work together.

---

## Concept 9 — Pairwise Comparison using Replication + XNOR
To compare every pair of 5 inputs (25 comparisons total),
build two 25-bit vectors and XNOR them.

```verilog
// Top vector:    aaaaabbbbbcccccdddddeeeee
// Bottom vector: abcdeabcdeabcdeabcdeabcde

assign out = ~{{5{a}},{5{b}},{5{c}},{5{d}},{5{e}}} ^
              {5{a,b,c,d,e}};
```

XNOR truth table:
- 0 XNOR 0 = 1  (equal)
- 1 XNOR 1 = 1  (equal)
- 0 XNOR 1 = 0  (not equal)
- 1 XNOR 0 = 0  (not equal)

XOR gives 0 when equal. ~ flips it → XNOR gives 1 when equal.

---

## Problems Solved Today
| # | Problem | Concept Used |
|---|---------|-------------|
| 1 | Vector splitting | Bit indexing vec[0] |
| 2 | Vector slicing | Range select in[15:8] |
| 3 | Byte reversal | Slicing on both sides |
| 4 | Bitwise vs Logical OR | \| vs \|\| |
| 5 | Reduction gates | &in, \|in, ^in |
| 6 | Concatenation | {a,b,c,d,e,f,2'b11} |
| 7 | Bit reversal | Manual reverse concat |
| 8 | Sign extension | {24{in[7]}}, in} |
| 9 | Pairwise comparison | Replication + XNOR |

---

## The Golden Rule of Day 1
**assign is just wiring. You are not computing — you are connecting.**

Every assign statement in today's problems was just
routing signals from one place to another. No logic gates,
no calculations — just wires being connected in clever ways.

---

## What's Next (Day 2)
- HDLBits: Modules section
- Learn how to connect multiple modules together
- Understand ports, instantiation, and hierarchy
