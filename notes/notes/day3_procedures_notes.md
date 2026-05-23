# Day 3 — Procedures in SystemVerilog (23 May 2026)
## Q1 - RTL Mastery | HDLBits Procedures Section

---

## What is a Procedure?
A procedure is an alternative way to describe hardware logic.
Instead of using assign statements, you write logic inside
always blocks. Both produce the same hardware — it's just
a different syntax.

    assign out = a & b;           // assign statement
    always @(*) out = a & b;      // procedure - same hardware!

Procedures become powerful when you need if/else, case
statements, or loops — things assign cannot do.

---

## Concept 1 — Two Types of Always Blocks

COMBINATIONAL always block:
    always @(*) begin
        out = a & b;   // updates instantly when inputs change
    end

    - @(*) means "trigger when ANY input changes"
    - Same behaviour as assign statement
    - Use blocking assignment =

CLOCKED always block:
    always @(posedge clk) begin
        out <= a & b;  // updates only on rising clock edge
    end

    - @(posedge clk) means "trigger on rising clock edge"
    - Creates flip flops — output is delayed by 1 clock cycle
    - Use non-blocking assignment <=

---

## Concept 2 — wire vs reg

wire  → used on left side of assign statements
reg   → used on left side of always block assignments

    output wire out_assign;      // driven by assign
    output reg  out_always;      // driven by always block

IMPORTANT: reg does NOT mean a hardware register.
It is just Verilog syntax. The actual hardware depends
on what you write inside the always block:
    always @(*)        → combinational logic (no memory)
    always @(posedge clk) → sequential logic (has memory)

---

## Concept 3 — Blocking vs Non-Blocking Assignment

BLOCKING (=) — use inside always @(*)
    Executes line by line, like normal code.
    Each line completes before the next starts.

    always @(*) begin
        a = b;    // a gets b first
        c = a;    // then c gets the new a
    end

NON-BLOCKING (<=) — use inside always @(posedge clk)
    All right-hand sides evaluated at the same time,
    then all assigned at the same time on clock edge.

    always @(posedge clk) begin
        a <= b;   // a and c evaluated simultaneously
        c <= a;   // c gets OLD value of a, not new
    end

THE GOLDEN RULE — just memorise this:
    always @(*)           use =
    always @(posedge clk) use <=

Breaking this rule causes simulation vs hardware mismatches
that are extremely hard to debug.

---

## Concept 4 — if/else in Always Blocks
An if/else inside always @(*) builds a multiplexer.

    always @(*) begin
        if (sel)
            out = b;    // sel=1 → choose b
        else
            out = a;    // sel=0 → choose a
    end

Equivalent assign version:
    assign out = sel ? b : a;

Use if/else when:
- You have 2-3 conditions
- Conditions involve ranges or comparisons (if x > 5)
- The logic reads more clearly as if/else

---

## Concept 5 — Latches and How to Avoid Them
A latch is unintended memory in combinational logic.
It is created when an output is not assigned in every condition.

CREATES A LATCH (bad):
    always @(*) begin
        if (cpu_overheated)
            shut_off = 1;
        // what happens when cpu_overheated=0?
        // Verilog holds previous value → LATCH
    end

NO LATCH (correct):
    always @(*) begin
        if (cpu_overheated)
            shut_off = 1;
        else
            shut_off = 0;   // always assigned → no latch
    end

WARNING SIGN IN MODELSIM:
    Warning: inferring latch for variable 'shut_off'
    If you see this → find your missing else or default.

RULE: In combinational always blocks, every output must
be assigned a value under every possible input condition.

---

## Concept 6 — Case Statements
A case statement is cleaner than if/elseif when you have
many specific values to check.

    always @(*) begin
        case(sel)
            3'd0: out = data0;
            3'd1: out = data1;
            3'd2: out = data2;
            default: out = 0;   // covers all other values
        endcase
    end

Rules:
- Always include a default case
- Each case item executes one statement
- Use begin...end if you need multiple statements per case
- First matching case wins (order matters)

Case vs if/else:
    if/else  → best for 2-3 conditions or range checks
    case     → best for many specific values (muxes, decoders, FSMs)

---

## Concept 7 — casez with Don't-Care Bits
casez lets you use z (or ?) as a wildcard — match any bit.

    casez (in)
        4'bzzz1: pos = 0;  // bit 0 is 1, bits 3-1 can be anything
        4'bzz10: pos = 1;  // bit 1 is 1, bit 0 is 0, others anything
        4'bz100: pos = 2;
        4'b1000: pos = 3;
        default: pos = 0;
    endcase

Without casez: 4-bit input needs 16 cases
With casez:    4-bit input needs only 4 cases
For 8-bit:     256 cases → 8 cases with casez

Used for:
- Priority encoders
- Instruction decoders
- Address decoders
- Any pattern matching circuit

---

## Concept 8 — Default Values Before Case
Clean pattern to avoid latches with multiple outputs.
Set everything to 0 first, then override only what changes.

    always @(*) begin
        // Step 1: assign default to ALL outputs
        up=0; down=0; left=0; right=0;

        // Step 2: override only the ones that need to change
        case(scancode)
            16'he075: up    = 1;
            16'he072: down  = 1;
            16'he06b: left  = 1;
            16'he074: right = 1;
        endcase
    end

Benefits:
- No latches possible
- No need for default case
- Much less typing
- Used in instruction decoders, control units, FSM outputs

---

## Problems Solved Today
| # | Problem | Concept Used |
|---|---------|-------------|
| 1 | AND gate two ways | assign vs always @(*) |
| 2 | XOR gate three ways | assign, comb always, clocked always |
| 3 | 2to1 mux | if/else in always block |
| 4 | Latch fix | Missing else clause |
| 5 | 6to1 mux | case statement with default |
| 6 | 4-bit priority encoder | case with all 16 combinations |
| 7 | 8-bit priority encoder | casez with don't-care bits |
| 8 | Keyboard decoder | Default values before case |

---

## The Three Always Block Rules
1. always @(*)           → use =   (blocking)
2. always @(posedge clk) → use <=  (non-blocking)
3. Always assign every output in every condition (no latches)

---

## What's Next (Day 4)
- HDLBits: More Verilog Features
- for loops and generate blocks
- Conditional operators
- Constants and parameters
