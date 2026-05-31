# Day 11 — More FSM Problems (31 May 2026)
## Q1 - RTL Mastery | HDLBits More FSM Section

---

## Concept 1 — Mealy vs Moore Revisited

MEALY FSM:
    Output = f(state, input)
    Output changes immediately when input changes
    Needs fewer states (input encoded in transition)
    z = (state == S2) & x   ← depends on both

MOORE FSM:
    Output = f(state) only
    Output changes only at clock edge
    Needs more states (output encoded in state)
    z = (state == B)        ← depends on state only

For 2's complement example:
    Mealy: 2 states (A, B)
    Moore: 3 states (A, B, C) — needs extra state for z=1

RULE: Mealy is more compact. Moore is safer (glitch-free).
Most real designs use Moore for outputs, Mealy for speed.

---

## Concept 2 — Active-Low Reset

Active-low reset triggers on FALLING edge:
    always @(posedge clk or negedge aresetn)
        if (~aresetn) state <= RESET_STATE;

Note: negedge aresetn in sensitivity list
      ~aresetn as the condition (true when aresetn=0)

Common naming convention:
    reset   = active high (reset when =1)
    resetn  = active low  (reset when =0)
    areset  = async active high
    aresetn = async active low

---

## Concept 3 — Serial 2's Complement FSM

2's complement rule (LSB first):
    Copy bits until first 1 (inclusive)
    Invert all bits after first 1

Example:
    Input:  0 0 1 0 1 1 0
    Output: 0 0 1 1 0 0 1
                ↑
           first 1 — copy it, then invert

MEALY (2 states):
    A: copy mode  → z = x
    B: invert mode → z = ~x
    A→B on first x=1

MOORE (3 states):
    A: z=0, waiting
    B: z=1, first 1 just received
    C: z=0, inverting (past first 1)
    One cycle output delay vs Mealy

ONE-HOT MEALY:
    state[0]=A, state[1]=B
    next[0] = state[0] & ~x
    next[1] = (state[0] & x) | state[1]
    z = (state[0] & x) | (state[1] & ~x)

---

## Concept 4 — Counting in FSM States

Encode the accumulator value INTO state names:
    Instead of: separate counter + FSM
    Use: state name encodes count so far

Example — count exactly 2 ones in 3 cycles:
    B0/B1: start (0 ones seen / ready for z=1)
    C0/C1: after cycle 1 (0 ones / 1 one)
    D0/D1/D2: after cycle 2 (0/1/2 ones)

Transition from D back to B:
    D1 w=1 → B1 (total=2 ✅)
    D1 w=0 → B0 (total=1 ✗)
    D2 w=0 → B1 (total=2 ✅)
    D2 w=1 → B0 (total=3 ✗)

Output: z = (state == B1)

ADVANTAGE: Pure FSM, no datapath needed.
The count is implicit in the state — no register required.

---

## Concept 5 — State Assigned Tables

When states are pre-encoded with binary values:
    Just implement the table directly in case statement

    case (state)
        3'b000: next_state = x ? 3'b001 : 3'b000;
        3'b001: next_state = x ? 3'b100 : 3'b001;
        ...
    endcase

Output from table:
    Find which states have output=1
    assign z = (state == 3'b011) | (state == 3'b100);

Always add default for unused states:
    default: next_state = 3'b000;

---

## Concept 6 — Deriving Logic Equations from State Table

When asked for just one output bit (Y[0], Y[2] etc):
    Build truth table for that bit
    Find all input combinations where output=1
    Write SOP expression

For Y[0] (LSB of next state):
    List all (current_state, input) → next_state[0]
    Y[0]=1 rows become AND terms
    OR all terms → SOP expression

This is what synthesis tools do automatically.
Knowing it manually shows understanding of FSM internals.

---

## Concept 7 — One-Hot FSM by Inspection (Review)

For each state bit, find incoming edges:

    next[i] = OR of all (source_state & condition) terms
              where condition leads to state i

    Example:
    State B(010) receives from:
        A(000) with w=0
        E(100) with w=1

    next_state_B = (y==000 & ~w) | (y==100 & w)

Output in one-hot is trivial:
    z = state[E] | state[F]
    (just OR the output states)

---

## Slowing Down — New Pace Plan

7 problems per day (was 9-12)
Focus on understanding over completion

Remaining HDLBits sections:
    - More sequential logic
    - Timing (if applicable)
    
After HDLBits completion (~2 weeks):
    Month 1 Project: Pipelined RISC-V ALU
    Month 2 Project: UVM Testbench for ALU
    Month 3 Project: CNN layer on HLS (FPGA)

Why projects matter more than problems:
    Recruiters look at GitHub projects not HDLBits scores
    Projects show you can build something complete
    Each project = one interview story

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | Mealy 101 detector | Active-low reset, overlapping |
| 2 | Moore 2s complement | 3 states needed for Moore |
| 3 | Mealy 2s complement one-hot | One-hot Mealy by inspection |
| 4 | Count 2 ones in 3 cycles | Count encoded in state names |
| 5 | State table FSM | Direct table implementation |
| 6 | Y[0] and z equations | SOP from state table |
| 7 | Y[2] next state logic | One bit equation derivation |

---

## What's Next (Day 12)
- Continue remaining HDLBits FSM problems
- Then move to More Sequential Logic section
- Target: finish HDLBits within 2 weeks
- Then start RISC-V ALU project
