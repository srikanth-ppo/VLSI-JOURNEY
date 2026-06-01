# Day 12 — FSM and Sequential Problems (01 Jun 2026)
## Q1 - RTL Mastery | HDLBits FSM Section

---

## Concept 1 — One-Hot by Inspection (Review + Extension)

For each target state, find ALL incoming arrows:

    Y_target = OR of (source_state & condition) for each incoming edge

Example - D is "w=0 collector":
    D receives from B,C,E,F all on w=0
    Y_D = ~w & (y_B | y_C | y_E | y_F)

Example - D is "w=1 collector":
    D receives from B,C,E,F all on w=1
    Y_D = w & (y_B | y_C | y_E | y_F)

These collector patterns appear often in FSMs where
one state is a "hub" that many states transition to.

Key: one-hot encoding makes output trivial:
    z = state_E | state_F
    No decode logic needed — just OR the output states.

---

## Concept 2 — Priority Arbiter FSM

Controls shared resource access with priority ordering.

4 states: A(idle), B(grant1), C(grant2), D(grant3)

State A logic (priority encoded as if-elseif):
    if (r[1])      → B  (highest priority)
    else if (r[2]) → C
    else if (r[3]) → D  (lowest priority)
    else           → A  (no requests)

States B,C,D: stay while request active, return to A when done
    B: r[1]=1 → B, r[1]=0 → A
    C: r[2]=1 → C, r[2]=0 → A
    D: r[3]=1 → D, r[3]=0 → A

Outputs: Moore (depends only on state)
    g[1] = (state==B)
    g[2] = (state==C)
    g[3] = (state==D)

Real world use: bus arbiters, memory controllers,
CPU interrupt controllers, DMA controllers.

Priority arbiter is one of the most common FSMs
in real chip design — every shared bus needs one.

---

## Concept 3 — Multi-Phase FSM

Some FSMs have distinct sequential phases:

Motor controller example:
    Phase 1: f=1 for exactly ONE cycle (state B)
    Phase 2: detect "101" sequence on x (states C,D,E)
    Phase 3: monitor y for up to 2 cycles (states F,G)
    Terminal: g=1 forever (H) or g=0 forever (I)

Design approach:
    1. Identify the phases
    2. Design each phase independently
    3. Connect phases with state transitions

Terminal states (H and I):
    next_state = same_state  (self-loop)
    Only exit on reset
    Used when behaviour is permanent until reset

ASCII state flow:
    A→B→C→D→E→F→H (success path)
              ↓    ↓
              C    G→H (y seen in cycle 2)
                   ↓
                   I (y not seen, g=0 forever)

---

## Concept 4 — UART with Parity (Improved Version)

Key improvements over basic UART:

1. Parity reset strategy:
    Reset parity in ALL non-receiving states:
    rst_par = IDLE | WAIT | DONE | reset
    Prevents stale parity from previous frames

2. Combined stop+parity check:
    STOP: in ? (odd ? DONE : IDLE) : WAIT
    Both framing AND parity checked simultaneously
    Clean single-state decision point

3. No separate START state:
    IDLE → B0 directly when in=0
    Start bit consumed in IDLE state

State flow:
    IDLE → B0→B1→...→B7 → PAR → STOP → DONE
                                  ↓
                                 WAIT (bad stop bit)

Done condition: state==DONE
    Reached only when: stop bit=1 AND odd parity=1

---

## Concept 5 — Boolean Simplification of Complex Circuits

Sometimes a complex multi-module circuit simplifies
to a single gate after boolean algebra.

Example mt2015_q4:
    4 submodules + OR + AND + XNOR
    → simplifies to: z = x | ~y

Steps:
    1. Identify submodule logic (A=AND, B=XOR)
    2. Write full boolean expression
    3. Apply boolean algebra / De Morgan's
    4. Simplify to minimal form

This is what synthesis tools do automatically.
Understanding it manually shows depth of knowledge.

---

## Problems Solved Today
| # | Problem | Concept |
|---|---------|---------|
| 1 | One-hot Y2,Y4 | D as w=1 collector state |
| 2 | 6-state FSM | Full implementation from diagram |
| 3 | 6-state FSM v2 | Different diagram same structure |
| 4 | One-hot Y1,Y3 | D as w=0 collector state |
| 5 | Priority arbiter | if-elseif priority chain |
| 6 | Motor controller | Multi-phase FSM + terminal states |
| 7 | UART with parity | Improved parity reset strategy |
| 8 | Circuit simplify | Boolean algebra → x\|~y |

---

## FSM Design Summary — All Patterns

PATTERN 1: Simple 2-state toggle
    Used for: on/off, direction control

PATTERN 2: Sequence detector
    Used for: protocol framing, pattern matching

PATTERN 3: Priority arbiter
    Used for: bus control, interrupt handling

PATTERN 4: Counter embedded in states
    Used for: timing, cycle counting

PATTERN 5: Multi-phase controller
    Used for: motor control, handshake protocols

PATTERN 6: Protocol parser (UART, PS/2, HDLC)
    Used for: serial communication receivers

PATTERN 7: FSM + datapath
    Used for: capturing data during protocol reception

---

## Progress Update
HDLBits sections completed:
    Vectors ✅, Modules ✅, Procedures ✅
    More Features ✅, Combinational ✅
    Flip Flops ✅, Counters ✅, Shift Registers ✅
    FSMs ✅ (mostly complete)

Remaining: More sequential logic problems
Target: Complete HDLBits in ~1 more week
Then: Start RISC-V ALU project (Month 1 milestone)

---

## What's Next (Day 13)
- Remaining HDLBits problems
- More sequential logic section
- Getting closer to project phase!
