# Day 2 — Modules & Hierarchy in SystemVerilog (22 May 2026)
## Q1 - RTL Mastery | HDLBits Modules Section

---

## What is a Module?
A module is a self-contained circuit block with input and output ports.
Real chips are built by connecting hundreds of modules together.
You never write one giant block of code — you build small modules
and wire them together. This is called hierarchy.

    top_module
      └── add16 (lower)
            └── add1 × 16
      └── add16 (upper)
            └── add1 × 16

---

## Concept 1 — Module Instantiation
To use a module inside another, you instantiate it — like placing
a chip on a circuit board.

    // module type    instance name   port connections
    mod_a             instance1      (.in1(a), .in2(b), .out(out));

- mod_a      = the module type (what chip you're using)
- instance1  = the name of this specific copy (you choose this)
- .in1(a)    = connect mod_a's port "in1" to your wire "a"

You can instantiate the same module multiple times with different
instance names — each is an independent copy of the circuit.

---

## Concept 2 — By Position vs By Name

BY POSITION — list wires in the same order as the module declaration:
    mod_a instance1 (out1, out2, a, b, c, d);

    Risky: if someone changes the port order in mod_a, your
    connections silently break.

BY NAME — explicitly map each port to a wire:
    mod_a instance1 (
        .out1(out1),
        .in1(a),
        .in2(b)
    );

    Safe: order doesn't matter, connections are always correct.

RULE: Always use by name in real professional RTL code.

---

## Concept 3 — Internal Wires
When connecting two module instances together, you need
wires to carry signals between them.

    wire w1;   // declare internal wire
    wire [7:0] w2;   // 8-bit internal wire

    my_dff dff1 (.clk(clk), .d(d),  .q(w1));   // w1 carries output of dff1
    my_dff dff2 (.clk(clk), .d(w1), .q(q));    // w1 feeds input of dff2

Internal wires are invisible outside the module — they only
exist to connect things inside.

---

## Concept 4 — Shift Register
Chaining flip flops together creates a shift register.
Each clock tick, data moves one stage to the right.

    d → [DFF1] → w1 → [DFF2] → w2 → [DFF3] → q
          clk            clk            clk

After 1 clock: w1 = d
After 2 clocks: w2 = d, w1 = next d
After 3 clocks: q  = d (original d appears at output)

Used everywhere: serial communication, pipeline stages,
synchronizers, delay lines.

---

## Concept 5 — Always Block and Case Statement (intro)
An always block runs its code whenever inputs change.
A case statement picks one output from many options.

    always @(*) begin       // run whenever any input changes
        case(sel)
            2'b00: q = d;   // sel=0 → output d directly
            2'b01: q = w1;  // sel=1 → output after 1 DFF
            2'b10: q = w2;  // sel=2 → output after 2 DFFs
            2'b11: q = w3;  // sel=3 → output after 3 DFFs
        endcase
    end

This builds a 4-to-1 multiplexer — selects one of 4 inputs.
Day 3 will cover always blocks in full detail.

---

## Concept 6 — Ripple Carry Adder
Split a 32-bit addition into two 16-bit adders.
Lower adder runs first, its carry feeds into upper adder.

    a[15:0]  + b[15:0]  + 0     → sum[15:0],  carry
    a[31:16] + b[31:16] + carry → sum[31:16]

Problem: upper adder must WAIT for lower adder to finish.
This creates a delay — called propagation delay.

---

## Concept 7 — Three Level Hierarchy
Modules can contain modules which contain more modules.

    top_module instantiates add16
    add16 instantiates add1 (16 times)
    add1 is the lowest level — actual gate logic

A 1-bit full adder (add1):
    sum  = a ^ b ^ cin         (XOR gives sum bit)
    cout = (a & b) | (cin & (a ^ b))  (carry when 2+ inputs are 1)

Truth table:
    a=0 b=0 cin=0 → sum=0 cout=0
    a=1 b=0 cin=0 → sum=1 cout=0
    a=1 b=1 cin=0 → sum=0 cout=1  (1+1=2, carry the 1)
    a=1 b=1 cin=1 → sum=1 cout=1  (1+1+1=3, carry the 1)

---

## Concept 8 — Carry Select Adder
Solution to the ripple carry delay problem.
Compute upper half TWICE in parallel — one assuming carry=0,
one assuming carry=1. Pick the right one with a mux.

    lower:  a[15:0] + b[15:0] + 0  → sum[15:0], carry

    upper0: a[31:16] + b[31:16] + 0  → sum0  (parallel)
    upper1: a[31:16] + b[31:16] + 1  → sum1  (parallel)

    result: carry=0 → use sum0
            carry=1 → use sum1

Both upper adders run at the SAME TIME as the lower adder.
When carry arrives, the answer is already computed — just pick it.
This is faster than waiting.

---

## Concept 9 — Adder-Subtractor
One circuit that does both a+b and a-b.

Key insight: a - b = a + (~b) + 1   (two's complement)

    sub=0: b ^ 0 = b    and cin=0  →  a + b + 0  = addition
    sub=1: b ^ 1 = ~b   and cin=1  →  a + ~b + 1 = subtraction

    assign b_modified = b ^ {32{sub}};
    // {32{sub}} replicates sub 32 times
    // XOR with 1 flips the bit, XOR with 0 leaves it unchanged

The same replication trick from Day 1 used here again.

---

## Ternary Operator ? :
A one-line mux. Used constantly in RTL.

    assign out = condition ? value_if_true : value_if_false;

    assign sum[31:16] = carry ? sum1 : sum0;
    // if carry=1, take sum1. if carry=0, take sum0.

---

## Unconnected Ports
Leave brackets empty to ignore an output you don't need:

    add16 upper (.cout());   // cout exists but we don't use it

---

## Problems Solved Today
| # | Problem | Concept Used |
|---|---------|-------------|
| 1 | Basic instantiation | By name connection |
| 2 | Module by position | Positional port mapping |
| 3 | Module by name | Named port mapping |
| 4 | Shift register | Chained DFFs + internal wires |
| 5 | 8-bit shift register + mux | Vector wires + case statement |
| 6 | 32-bit adder | Carry chaining between modules |
| 7 | Adder with full adder | 3-level hierarchy + add1 logic |
| 8 | Carry select adder | Parallel computation + ternary mux |
| 9 | Adder-subtractor | XOR flip + two's complement |

---

## The Golden Rule of Day 2
Real chips are not one big block of code.
They are hundreds of small modules connected together.
Master instantiation and you can build anything.

---

## What's Next (Day 3)
- HDLBits: Procedures section
- always @(*) for combinational logic
- always @(posedge clk) for sequential logic
- if/else inside always blocks
- The difference between wire and reg
