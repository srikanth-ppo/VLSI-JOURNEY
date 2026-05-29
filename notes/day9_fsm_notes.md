# Day 9 — Finite State Machines (29 May 2026)
## Q1 - RTL Mastery | HDLBits FSM Section

---

## What is an FSM?
A Finite State Machine is a sequential circuit that:
- Has a finite number of states
- Transitions between states based on inputs
- Produces outputs based on state (and sometimes inputs)

Every digital protocol, CPU control unit, and
interface controller is an FSM at its core.

---

## Two Types of FSMs

MOORE FSM:
    Output depends ONLY on current state
    out = f(state)

    Advantages: simpler, glitch-free outputs
    Used for: most digital control circuits

MEALY FSM:
    Output depends on state AND inputs
    out = f(state, in)

    Advantages: faster response (1 cycle earlier)
    Used for: protocols needing immediate response

---

## Concept 1 — The 3-Block FSM Template

Every Moore FSM uses exactly this structure:

    // Block 1: State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) state <= RESET_STATE;
        else        state <= next_state;
    end

    // Block 2: Next state logic (combinational)
    always @(*) begin
        case (state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S1 : S2;
            ...
        endcase
    end

    // Block 3: Output logic (combinational, Moore)
    assign out = (state == TARGET_STATE);
    // or use always @(*) with case statement

This separation is the professional standard.
Never mix state register with combinational logic.

---

## Concept 2 — State Encoding

BINARY ENCODING:
    2 states  → 1 bit
    4 states  → 2 bits
    8 states  → 3 bits
    N states  → ceil(log2(N)) bits

    parameter A=2'b00, B=2'b01, C=2'b10, D=2'b11;

    Pros: fewer flip flops, compact
    Cons: more complex decode logic
    Used in: ASICs (area matters)

ONE-HOT ENCODING:
    N states → N bits, exactly one bit high

    parameter A=4'b0001, B=4'b0010,
              C=4'b0100, D=4'b1000;

    Pros: simple decode, fast transitions
    Cons: more flip flops
    Used in: FPGAs (flip flops are cheap)

---

## Concept 3 — One-Hot FSM by Inspection

For each state, find all incoming arrows:

    State A receives from: A(in=0), C(in=0)
    next[A] = state[A]&~in | state[C]&~in

    State B receives from: A(in=1), B(in=1), D(in=1)
    next[B] = state[A]&in | state[B]&in | state[D]&in

Rule: each incoming edge = one AND term.
OR all terms together for each state's next bit.

Output = just the state bit:
    assign out = state[D];  // no decode needed!

---

## Concept 4 — Sync vs Async Reset

ASYNC RESET (immediate):
    always @(posedge clk or posedge areset)
        if (areset) state <= RESET_STATE;

SYNC RESET (at clock edge only):
    always @(posedge clk)
        if (reset) state <= RESET_STATE;

Rule of thumb:
    Use async for power-on reset
    Use sync for normal operation reset

---

## Concept 5 — Sequence Detector FSM

The 4-state FSM (A,B,C,D) detects pattern "101":

    ASCII state diagram:
    
    reset
      ↓
    [A]--in=1-->[B]--in=0-->[C]--in=1-->[D] out=1
     ↑              in=1↗    ↓in=0       ↓in=1↗
     └──in=0─────────────[A]            [C]
                                         ↓in=0
                                        [A]

    Sequence: ...1 0 1...
    State:    A→B→C→D (output=1 when D reached)

This is the most common FSM interview question.
Know how to build a sequence detector from scratch.

---

## Concept 6 — Real World FSM (Water Reservoir)

Multi-output FSM with history-dependent behaviour:

States track BOTH current level AND direction:
    A3 = above S3 (full)
    A2 = between S3&S2, rising
    A1 = between S2&S1, rising
    A0 = below S1 (empty)
    B2 = between S3&S2, falling
    B1 = between S2&S1, falling

Key insight: same sensor reading can mean different
flow rates depending on whether water is rising or
falling. This requires HISTORY → needs separate states.

Outputs:
    FR1 = 1 in all states except A3
    FR2 = 1 when level is low (A0, A1, B1)
    FR3 = 1 only when completely empty (A0)
    DFR = 1 when falling or empty (A0, B1, B2)

---

## FSM Design Checklist

When designing any FSM:
1. List all states (what conditions need to be remembered?)
2. Define reset state
3. Draw state transition diagram
4. Write state transition table
5. Choose encoding (binary or one-hot)
6. Implement 3-block template
7. Verify all states have valid transitions

---

## Common FSM Mistakes to Avoid

1. Missing states in case statement
   → add default: next_state = RESET_STATE;

2. Latches in next state logic
   → always use default assignment or complete case

3. Mixing blocking/non-blocking
   → state register: always use <=
   → combinational blocks: always use =

4. Output depending on next_state instead of state
   → Moore output = f(state), never f(next_state)

5. Forgetting reset state
   → always define what happens on reset

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | 2-state Moore async | Basic FSM template |
| 2 | 2-state Moore sync | Sync reset version |
| 3 | JK FSM async | 2-input FSM = JK flip flop |
| 4 | JK FSM sync | Sync reset version |
| 5 | Combinational only | next_state + output only |
| 6 | One-hot FSM | By inspection method |
| 7 | 4-state FSM async | Sequence detector 101 |
| 8 | 4-state FSM sync | Sync reset version |
| 9 | Water reservoir | Real-world multi-output FSM |

---

## The Golden Rule of Day 9
An FSM is just a register (state) + combinational logic.
The state remembers HISTORY.
The combinational logic decides what to do NEXT.
Keep them separate — always use 3 blocks.

---

## What's Next (Day 10)
- HDLBits: Lemmings FSM problems
- Multi-part complex FSM design
- These are the hardest HDLBits problems
- Perfect interview preparation
