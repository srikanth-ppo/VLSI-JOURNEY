# Day 4 — More Verilog Features (24 May 2026)
## Q1 - RTL Mastery | HDLBits More Verilog Features Section

---

## What is covered today?
Today's problems go beyond basic gates and modules.
We use operators and loops to describe large, repetitive
hardware structures in very few lines of code.
This is how real RTL engineers work — describe patterns,
let the synthesizer build the hardware.

---

## Concept 1 — Ternary Operator ? :
A one-line multiplexer. Selects one of two values based
on a condition.

    assign out = (condition) ? value_if_true : value_if_false;

Examples:
    assign out = sel ? b : a;           // 2to1 mux
    assign min = (a < b) ? a : b;       // minimum of two numbers
    assign out = ena ? q : 1'bz;        // tri-state buffer

Chaining ternary operators builds tree structures:
    wire ab_min = (a < b) ? a : b;      // min of a,b
    wire cd_min = (c < d) ? c : d;      // min of c,d
    assign min  = (ab_min < cd_min) ? ab_min : cd_min;  // overall min

This builds a tournament bracket in hardware:
    a ──┐
        ├─ min(a,b) ──┐
    b ──┘              ├─ final min
    c ──┐              │
        ├─ min(c,d) ──┘
    d ──┘

Used for: min/max circuits, comparators, priority logic,
tri-state buffers, FSM next-state logic.

---

## Concept 2 — Reduction Operators (revisited)
Fold all bits of a vector into one bit using an operator.

    &in   → AND all bits  (1 only if ALL bits are 1)
    |in   → OR all bits   (1 if ANY bit is 1)
    ^in   → XOR all bits  (1 if ODD number of 1s)
    ~&in  → NAND all bits
    ~|in  → NOR all bits
    ~^in  → XNOR all bits (1 if EVEN number of 1s)

Parity checking:
    assign parity = ^in;   // even parity bit

    Sender sends data + parity bit.
    Receiver XORs all received bits.
    Result = 0 → no error detected
    Result = 1 → error detected (one bit flipped)

Used in: RAM, UART, network protocols, storage, ECC memory.

For 100-input gates — without reduction:
    out = in[0] & in[1] & in[2] & ... & in[99];  // 99 operators
With reduction:
    out = &in;   // 1 symbol, same hardware

---

## Concept 3 — for Loop inside always Block
Used to describe repetitive combinational logic.
The loop is UNROLLED at synthesis time — all iterations
happen in parallel in hardware.

    integer i;    // loop variable declared as integer

    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i];    // reverses bit order
        end
    end

Synthesizer expands this to:
    out[0] = in[99];
    out[1] = in[98];
    ...
    out[99] = in[0];

All running in parallel — not sequential like software.

Rules:
- Declare loop variable as integer outside always block
- Use i = i + 1 not i++ (Verilog doesn't support ++)
- Output must be reg when assigned in always block
- Set default values before loop to avoid latches

---

## Concept 4 — Accumulator Pattern
Build a running total inside a for loop.

    always @(*) begin
        out = 8'd0;                         // start at 0
        for (i = 0; i < 255; i = i + 1) begin
            out = out + in[i];              // add each bit
        end
    end

Since in[i] is 0 or 1, adding it directly counts the 1s.
No if statement needed.

Why initialise out = 0 before the loop?
- out is reg in combinational always block
- Without initial value, previous value is held → LATCH
- Always give default values before loops and case statements

Population count (popcount) real world uses:
- Cryptography (Hamming weight calculation)
- Error correction codes (Hamming codes, BCH codes)
- Machine learning (binary neural networks)
- Chess engines (counting pieces on bitboard)
- x86 has POPCNT instruction, ARM has CNT instruction

---

## Concept 5 — generate for Loop
Used to instantiate multiple copies of a module.
Different from always for loop — this creates module instances.

    genvar i;     // special variable only for generate loops

    generate
        for (i = 0; i < 100; i = i + 1) begin : block_label
            module_name instance_name (
                .port(connection)
            );
        end
    endgenerate

Rules:
- Use genvar not integer for generate loops
- Block label after begin : is required
- Cannot use generate inside always blocks
- Cannot use always for loop to instantiate modules

always for loop vs generate for loop:
    always for   → repetitive logic and assignments
    generate for → repetitive module instantiation

---

## Concept 6 — Indexed Part Select
Access a fixed-width slice of a vector using a variable index.

    a[4*i+3 : 4*i]   // selects 4 bits starting at position 4*i

    i=0 → a[3:0]     // digit 0
    i=1 → a[7:4]     // digit 1
    i=2 → a[11:8]    // digit 2
    i=99 → a[399:396] // digit 99

This is how packed arrays work — multiple fixed-width
elements stored in one wide vector. Access element i by
multiplying i by the element width.

Standard pattern:
    vector[WIDTH*i + WIDTH-1 : WIDTH*i]
    // for 4-bit elements: vector[4*i+3 : 4*i]
    // for 8-bit elements: vector[8*i+7 : 8*i]

---

## Concept 7 — Ripple Carry Adder (full logic)
Full adder equations for 1 bit:
    sum[i]  = a[i] ^ b[i] ^ cin
    cout[i] = (a[i] & b[i]) | (cin & (a[i] ^ b[i]))

For 100-bit ripple carry:
    - bit 0 uses external cin
    - bits 1-99 use cout[i-1] as their cin
    - Each bit must wait for previous bit's carry

This is called ripple carry because the carry
"ripples" from bit 0 to bit 99 one at a time.
Delay grows linearly with width — slow for wide adders.
Solutions: carry lookahead, carry select (Day 2).

---

## Concept 8 — BCD (Binary Coded Decimal)
BCD stores each decimal digit (0-9) separately in 4 bits.

Normal binary:  99 = 7'b1100011
BCD:            99 = 8'b1001_1001  (9=1001, 9=1001)

Why BCD?
- Financial systems (no rounding errors)
- Digital displays (each digit drives one display segment)
- Anywhere humans read decimal numbers directly

100-digit BCD number packed into 400 bits:
    bits [3:0]   = digit 0 (ones)
    bits [7:4]   = digit 1 (tens)
    bits [11:8]  = digit 2 (hundreds)
    ...
    bits [399:396] = digit 99

---

## Problems Solved Today
| # | Problem | Concept Used |
|---|---------|-------------|
| 1 | Min of 4 numbers | Ternary operator tree |
| 2 | Parity bit | Reduction XOR |
| 3 | 100-input gates | Reduction AND OR XOR |
| 4 | 100-bit reversal | for loop in always block |
| 5 | Population count | Accumulator + for loop |
| 6 | 100-bit ripple adder | for loop + full adder logic |
| 7 | 100-digit BCD adder | generate loop + indexed part select |

---

## Key Differences — 3 types of repetition in Verilog
1. assign with ternary chain → small repetition, 2-4 levels
2. always + for loop        → repetitive logic, no modules
3. generate + for loop      → repetitive module instantiation

---

## The Golden Rule of Day 4
Describe the PATTERN, not each gate.
Let the synthesizer build the hardware from your description.
A 100-bit adder in 10 lines beats a 300-line gate-by-gate description.

---

## What's Next (Day 5)
- HDLBits: Sequential Logic section
- Latches and Flip Flops
- D flip flop, T flip flop, JK flip flop
- Registers and shift registers
- This is where clocked always blocks become the main focus
