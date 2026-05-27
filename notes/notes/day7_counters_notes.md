# Day 7 — Counters (27 May 2026)
## Q1 - RTL Mastery | HDLBits Counters Section

---

## What is a Counter?
A counter is a register that increments itself every clock cycle.
It is the simplest form of sequential logic with feedback.

    always @(posedge clk)
        q <= q + 1;   // feeds output back as input

Counters are used in:
- Digital clocks and timers
- Memory address generators
- Clock dividers and frequency dividers
- PWM controllers
- Sequence generators
- State machines

---

## Concept 1 — Basic Binary Counter

4-bit counter counts 0→15→0 automatically:

    always @(posedge clk) begin
        if (reset) q <= 4'b0;
        else       q <= q + 1;
    end

ASCII timing diagram:
    clk: ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑
    q:   0  1  2  3  4  5  6  7  8  9 ...→ 15 → 0

When q=4'b1111 (15), q+1 overflows back to 0 automatically.
No extra logic needed — binary arithmetic handles the wrap.

---

## Concept 2 — Modulo Counter (custom wrap point)

Decade counter (0-9), wraps at 9:

    always @(posedge clk) begin
        if (reset || q == 4'd9) q <= 4'b0;
        else                    q <= q + 1;
    end

ASCII timing diagram:
    clk: ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑
    q:   0  1  2  3  4  5  6  7  8  9  0  1...

Formula for any modulo counter:
    if (reset || q == MAX_VALUE) q <= START_VALUE;
    else                         q <= q + 1;

Common counters:
    Mod-10 (0-9):   wrap at 9,  reset to 0  (BCD digit)
    Mod-10 (1-10):  wrap at 10, reset to 1
    Mod-12 (1-12):  wrap at 12, reset to 1  (hours)
    Mod-60 (0-59):  wrap at 59, reset to 0  (minutes/seconds)

---

## Concept 3 — Counter with Enable

Counter only increments when enable=1. Holds when enable=0.

    always @(posedge clk) begin
        if (reset)        q <= 0;
        else if (enable)  q <= q + 1;
        // no else = holds value when enable=0
    end

Priority order (always follows this):
    1. reset    → highest priority
    2. enable   → count if enabled
    3. (nothing)→ hold value

ASCII timing diagram:
    clk:    ↑  ↑  ↑  ↑  ↑  ↑  ↑  ↑
    enable: 1  1  0  0  1  1  0  1
    q:      0  1  2  2  2  3  4  4  5

---

## Concept 4 — Counter with Parallel Load

Use a counter module's LOAD input to implement custom wrap:

    assign c_load = reset | (enable & (Q == MAX));
    assign c_d    = START_VALUE;

    count4 ctr (clk, c_enable, c_load, c_d, Q);

When c_load=1 → Q becomes c_d on next clock edge
When c_load=0 → Q counts normally

Key rule: load has HIGHER priority than enable.
So checking enable in c_load condition prevents
unwanted loads when counter is paused.

    WRONG: c_load = reset | (Q == 4'd12)
           (loads even when paused at 12)

    RIGHT: c_load = reset | (enable & (Q == 4'd12))
           (only loads when actually running)

---

## Concept 5 — Cascaded Counters (Frequency Division)

Chain multiple counters to divide frequency:

    1000 Hz → Counter0 (÷10) → 100 Hz
    100 Hz  → Counter1 (÷10) → 10 Hz
    10 Hz   → Counter2 (÷10) → 1 Hz

Enable each counter only when all previous counters are at 9:

    c_enable[0] = 1              (always runs)
    c_enable[1] = (Q0 == 9)      (runs when ones=9)
    c_enable[2] = (Q0==9)&(Q1==9) (runs when ones=tens=9)

ASCII timing diagram (simplified):
    clk:  ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
    Q0:   0 1 2 3 4 5 6 7 8 9 0 1...
    Q1:   0 0 0 0 0 0 0 0 0 0 1 1...
                               ↑
                    Q1 only increments here

OneHertz pulse: Q0=Q1=Q2=9 (once every 1000 clocks)

---

## Concept 6 — BCD Counter (multi-digit)

Each digit is a separate 4-bit decade counter.
Upper digits enabled by lower digit carry.

    ones:     always counts
    tens:     counts when ones==9
    hundreds: counts when ones==9 AND tens==9
    thousands:counts when ones==9 AND tens==9 AND hundreds==9

ASCII timing diagram:
    ones:     0 1 2 3 4 5 6 7 8 9 0 1...
    tens:     0 0 0 0 0 0 0 0 0 0 1 1...
    hundreds: 0 0 0 0 0 0 0 0 0 0 0 0...

BCD packing: each digit uses 4 bits in a wide register:
    q[3:0]   = ones
    q[7:4]   = tens
    q[11:8]  = hundreds
    q[15:12] = thousands

---

## Concept 7 — 12-Hour Clock Rollover Rules

Special rules for 12-hour clock:
    Seconds: 00 → 59 → 00
    Minutes: 00 → 59 → 00 (when seconds roll)
    Hours:   01 → 12 → 01 (NOT 00! skip zero)
    PM:      flips when 11 → 12 (NOT when 12 → 01)

ASCII timing diagram around midnight/noon:
    hh:  11  11  11  12  12  12  01
    mm:  59  59  59  00  00  00  00
    ss:  58  59  00  00  01  59  00
    pm:   0   0   0   1   1   1   1
                   ↑
             flips here (11→12)

Rollover signals:
    ss_roll = ss == 8'h59
    mm_roll = ss_roll AND mm == 8'h59
    pm_flip = mm_roll AND hh == 8'h11  (at 11:59:59)

---

## Problems Solved Today
| # | Problem | Key Concept |
|---|---------|------------|
| 1 | 4-bit binary counter | q <= q+1, overflow wraps naturally |
| 2 | Decade counter 0-9 | wrap at 9 |
| 3 | Decade counter 1-10 | wrap at 10, reset to 1 |
| 4 | Counter with enable | hold when enable=0 |
| 5 | 1-12 counter | parallel load to wrap |
| 6 | 1Hz from 1000Hz | cascaded BCD ÷10 ÷10 ÷10 |
| 7 | 4-digit BCD counter | 4 cascaded decade counters |
| 8 | 12-hour clock | complex rollover + PM flip |

---

## Counter Design Checklist
When building any counter, answer these questions:
1. What value does it start/reset at?
2. What value does it wrap at?
3. Does it need an enable?
4. Does it need synchronous or async reset?
5. Is it driven by another counter's carry?

---

## The Golden Rule of Day 7
A counter is just a register that adds 1 to itself.
All complexity comes from controlling WHEN it adds 1
and WHAT VALUE it resets to.

---

## What's Next (Day 8)
- HDLBits: Shift Registers
- Serial to parallel conversion
- Linear Feedback Shift Registers (LFSR)
- These are used in UART, SPI, error correction, encryption
