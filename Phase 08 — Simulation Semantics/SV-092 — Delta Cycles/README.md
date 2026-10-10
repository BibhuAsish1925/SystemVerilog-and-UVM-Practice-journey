
# 092 — SV-092 — Delta Cycles

## Introduction

A **delta cycle** is a zero-time simulation step used by the SystemVerilog simulator to process events and signal updates.

Delta cycles are important for understanding:

- Nonblocking assignments (`<=`)
- Simulation scheduling
- Event controls
- RTL/testbench synchronization
- Race-condition avoidance

A simulator can perform several scheduling steps at the same simulation timestamp without advancing simulation time.

---

## Running Code

**Code type:** SystemVerilog simulation demo / testbench

```systemverilog
module sv_092_delta_cycles_tb;

    logic a;
    logic b;
    logic c;

    initial begin

        a = 1'b0;
        b = 1'b0;
        c = 1'b0;

        $display("[%0t] Initial: a=%b b=%b c=%b",
                 $time, a, b, c);

        // Blocking assignment updates immediately
        a = 1'b1;

        // Nonblocking assignments are scheduled
        b <= a;
        c <= b;

        // Still the same simulation time,
        // but NBA updates have not executed yet.
        $display("[%0t] Before NBA: a=%b b=%b c=%b",
                 $time, a, b, c);

        // #0 advances to another delta cycle
        #0;

        $display("[%0t] After #0: a=%b b=%b c=%b",
                 $time, a, b, c);

        #1;

        $display("[%0t] After #1: a=%b b=%b c=%b",
                 $time, a, b, c);

        $finish;

    end

endmodule
````

---

## Expected Output

```text
[0] Initial: a=0 b=0 c=0
[0] Before NBA: a=1 b=0 c=0
[0] After #0: a=1 b=1 c=0
[1000] After #1: a=1 b=1 c=0
```

The important point is that `#0` does not advance simulation time. It allows the simulator to move through another scheduling step.

The sequence is:

```text
Simulation time: 0 ──────────────────────────────── 1
                  │
                  ├─ Delta cycle
                  ├─ NBA update
                  └─ More event processing
```

`b <= a` updates `b` after the current active processing, while `c <= b` uses the old value of `b`.

Therefore:

```text
a = 1
b = 1
c = 0
```

after the NBA update.

Vivado/XSim may display `#1` as `1000` because the simulator can report time in picoseconds depending on the simulation time resolution.

---

## Important Concepts

### 1. Zero-Time Progression

A delta cycle changes the simulator's scheduling state without changing `$time`.

### 2. Nonblocking Assignment

```systemverilog
b <= a;
```

The assignment is scheduled for a later simulation region rather than updating `b` immediately.

### 3. `#0` Delay

```systemverilog
#0;
```

Moves execution to another scheduling step at the same simulation time.

It does **not** mean that physical time has advanced.

### 4. Why Delta Cycles Matter

Delta-cycle behavior is important when analyzing:

* Sequential RTL
* Testbench synchronization
* Clocking
* Nonblocking assignments
* Event-driven simulation
* Race conditions

---

## Vivado Usage

1. Add the file under **Simulation Sources**.
2. Set `sv_092_delta_cycles_tb` as the simulation top.
3. Run **Run Simulation → Run Behavioral Simulation**.
4. Observe the console output.
5. Compare the values before and after `#0`.

---

## Key Takeaway

**Delta cycles allow the simulator to progress through event-scheduling regions without advancing simulation time.**

Understanding delta cycles is essential for correctly predicting how SystemVerilog RTL and testbench code execute during simulation.

