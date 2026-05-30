# Day 10 — Advanced FSMs (30 May 2026)
## Q1 - RTL Mastery | HDLBits Advanced FSM Section

---

## What was covered today?
Complex multi-state FSMs with:
- Multiple inputs and outputs
- FSM + counter combination
- FSM + datapath combination
- Protocol parsers (PS/2, UART, HDLC)
- One-hot encoding by inspection

---

## Concept 1 — Lemmings FSM Evolution

Built up a complex FSM in 4 steps:

STEP 1: Walk left/right (2 states)
    LEFT, RIGHT
    bump_left → turn right, bump_right → turn left

STEP 2: Add falling (4 states)
    + FALL_L, FALL_R
    Key: separate fall states remember direction before fall

STEP 3: Add digging (6 states)
    + DIG_L, DIG_R
    Priority: fall > dig > bump > walk
    Implemented as nested ternary chain:
    next = ~ground ? FALL : dig ? DIG : bump ? TURN : STAY

STEP 4: Add splat (7 states)
    + SPLAT terminal state
    FSM + counter: count fall cycles
    fall_count >= 20 AND landing → SPLAT
    SPLAT is terminal — no exit except reset

KEY LESSON: Use separate states to encode history.
Same physical situation (falling) needs different states
(FALL_L vs FALL_R) to remember what happened before.

---

## Concept 2 — FSM + Counter Pattern

When time or count matters, combine FSM with counter:

    // Counter controlled by FSM
    always @(posedge clk) begin
        if (state == FALL_L || state == FALL_R)
            count <= count + 1;
        else
            count <= 0;
    end

    // FSM uses counter value
    FALL_L: next = ground ? (count >= 20 ? SPLAT : LEFT) : FALL_L;

Used in: timeouts, watchdog timers, protocol timing,
debounce circuits, PWM generators.

---

## Concept 3 — PS/2 Protocol Parser

4-state FSM to detect 3-byte messages:
    BYTE1 → wait for in[3]=1 (message start marker)
    BYTE2 → accept any byte
    BYTE3 → accept any byte
    DONE  → assert done=1 for one cycle

Key insight: DONE state creates one-cycle pulse.
Without it, done would be high for entire BYTE3 duration.

Add datapath to capture bytes:
    Use next_state (not state) to capture at right time:
    case (next_state)
        BYTE2: out[23:16] <= in;  // byte1 just arrived
        BYTE3: out[15:8]  <= in;  // byte2 just arrived
        DONE:  out[7:0]   <= in;  // byte3 just arrived

---

## Concept 4 — UART Serial Receiver

11 states for full UART receiver:
    IDLE → START → D0→D1→...→D7 → STOP → back to IDLE
                                  ↓ (no stop bit)
                                 ERR → wait for line high

Key rules:
    IDLE: line high when idle, in=0 is start bit
    START: consume start bit, don't capture it
    D0-D7: capture 8 data bits (LSB first)
    STOP: in=1 → done=1, in=0 → error
    ERR: wait for in=1 before next byte

Back-to-back bytes handled by STOP state:
    STOP: in=0 → START (immediate! new start bit)
    STOP: in=1 → IDLE

Datapath - two methods:

METHOD 1 - Shift register (LSB first):
    shreg <= {in, shreg[7:1]};  // shift right, new bit at MSB
    After 8 shifts: shreg[0]=bit0, shreg[7]=bit7

METHOD 2 - Direct bit assignment:
    BIT0: data[0] <= in;
    BIT1: data[1] <= in;
    ...cleaner but more lines

---

## Concept 5 — UART with Parity

Add parity bit after 8 data bits:
    D0→D1→...→D7→PAR→STOP

Use parity module (T flip flop):
    - Reset during START state
    - Counts 1s through D0-D7-PAR (9 bits)
    - odd=1 means odd number of 1s = correct parity

Done condition:
    done = (state == STOP) & odd;
    Both conditions must be true.

---

## Concept 6 — HDLC Bit Stuffing

10-state FSM counting consecutive 1s:
    NONE→ONE→TWO→THREE→FOUR→FIVE→SIX→ERROR

From FIVE (5 consecutive 1s):
    0 → DISCARD (disc=1, stuffed bit)
    1 → SIX

From SIX (6 consecutive 1s):
    0 → FLAG (flag=1, frame boundary)
    1 → ERROR (err=1, 7+ ones)

After DISCARD or FLAG: resume counting from NONE/ONE
ERROR: stays until 0 received

Real world: HDLC used in PPP, ISDN, X.25 protocols.
Every router implements this FSM in hardware.

---

## FSM Design Patterns Summary

PATTERN 1: Priority chain
    next = cond1 ? S1 : cond2 ? S2 : cond3 ? S3 : STAY;
    First true condition wins.

PATTERN 2: Terminal state (absorbing state)
    SPLAT: next_state = SPLAT;
    No exit except reset. Used for error/done states.

PATTERN 3: One-cycle pulse
    Use dedicated state (DONE, FLAG, DISCARD)
    Output=1 only in that state → one cycle pulse

PATTERN 4: FSM + counter
    Counter incremented/reset based on FSM state
    FSM transitions based on counter value

PATTERN 5: FSM + datapath
    FSM controls WHEN to capture
    Datapath captures WHAT
    Use next_state for capture timing

---

## Problems Solved Today
| # | Problem | States | Key Concept |
|---|---------|--------|-------------|
| 1 | Lemmings 1 | 2 | Basic direction FSM |
| 2 | Lemmings 2 | 4 | Fall states preserve direction |
| 3 | Lemmings 3 | 6 | Priority: fall>dig>bump |
| 4 | Lemmings 4 | 7 | FSM+counter, terminal SPLAT |
| 5 | One-hot 10-state | 10 | By inspection method |
| 6 | PS/2 parser | 4 | Protocol message framing |
| 7 | PS/2 with datapath | 4 | next_state capture timing |
| 8 | UART receiver | 11 | Serial protocol FSM |
| 9 | UART with data | 11 | Shift register datapath |
| 10 | UART with parity | 13 | FSM+parity module |
| 11 | HDLC bit stuffing | 10 | Counting consecutive bits |

---

## The Golden Rule of Day 10
Complex FSMs are just simple FSMs composed together.
Break the problem into:
1. What needs to be remembered? (states)
2. What triggers transitions? (inputs)
3. What needs to be measured? (counters)
4. What needs to be captured? (datapath)
Then wire them together.

---

## What's Next
- HDLBits: More FSM problems (sequence detection)
- Then: Move to building the RISC-V ALU (Month 1 milestone)
- The FSM knowledge from Days 9-10 directly applies
  to the control unit of the RISC-V processor
