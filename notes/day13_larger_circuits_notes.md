# Day 13 — FSM Sequential Section (02 June 2026)

## Q1 - RTL Mastery | HDLBits FSM Sequential Problems

---

## What was covered today?

Sequential RTL design involving:

* Counters
* Shift registers
* Sequence detector FSMs
* Timer FSMs
* One-hot FSM logic
* FSM + datapath integration

---

## Concept 1 — Mod-1000 Counter

Built a synchronous counter:
0 → 1 → 2 → ... → 999 → 0

Key concepts:

* Synchronous reset
* Counter rollover
* Sequential counting

Applications:

* Timers
* Delay generators
* Frequency division

---

## Concept 2 — Shift Register + Down Counter

Implemented a 4-bit register that:

1. Shifts serial data
2. Works as a down counter

Key concepts:

* MSB-first shifting
* Shared datapath
* Sequential storage
* Counter decrement logic

---

## Concept 3 — 1101 Sequence Detector FSM

Designed FSM to detect:
1101

State progression:
S → S1 → S11 → S110 → DETECT

Key concepts:

* Moore FSM
* Sequence detection
* State transition logic
* Overlapping detection

Applications:

* Protocol detection
* Serial communication
* Pattern recognition

---

## Concept 4 — FSM Controlled Shift Enable

Generated shift_ena for exactly 4 clock cycles.

Key concepts:

* Timed enable generation
* Sequential timing logic
* Cycle counting

Applications:

* Serial loaders
* Timed operations
* Data shifting systems

---

## Concept 5 — Combined Timer FSM

Built timer control FSM with states:
SEARCH → SHIFT → COUNT → WAIT

Operations:

1. Detect sequence
2. Shift delay bits
3. Start counting
4. Wait for completion
5. Generate done signal
6. Wait for acknowledgement

Key concepts:

* FSM + datapath integration
* Timer control systems
* Sequential control logic

---

## Concept 6 — Full Timer System

Implemented programmable timer:
(delay + 1) × 1000 clock cycles

Architecture:

* Sequence detector FSM
* Shift register
* Mod-1000 counter
* Delay counter
* Timer control FSM

Key concepts:

* Multi-cycle delay systems
* Counter hierarchy
* Programmable timing systems

---

## Concept 7 — One-Hot FSM by Inspection

Implemented next-state equations directly from state diagram.

Key concepts:

* One-hot encoding
* Combinational FSM equations
* Output equation derivation
* FPGA-friendly FSM implementation

Advantages:

* Faster hardware
* Simpler logic equations
* Easier debugging

---

## Problems Solved Today

| # | Problem                  | Key Concept             |
| - | ------------------------ | ----------------------- |
| 1 | Mod-1000 Counter         | Sequential counting     |
| 2 | Shift Register + Counter | Shared datapath         |
| 3 | 1101 Sequence FSM        | Pattern detection       |
| 4 | Shift Enable FSM         | Timed enable            |
| 5 | Combined Timer FSM       | Control-path design     |
| 6 | Full Timer System        | Datapath integration    |
| 7 | One-Hot FSM Logic        | By-inspection equations |

---

## The Golden Rule of Day 13

Complex sequential systems are built by combining:

1. FSMs
2. Counters
3. Shift registers
4. Datapaths

Understanding how these blocks interact is the foundation
of FPGA and RTL design.
