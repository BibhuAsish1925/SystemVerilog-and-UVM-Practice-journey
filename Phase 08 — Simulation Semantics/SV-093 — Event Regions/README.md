
# 093 — SV-093 — Event Regions

## Introduction

SystemVerilog simulation is divided into **event regions** that control when different types of simulation activity are evaluated.

The important regions are:

| Region | Purpose |
|---|---|
| Preponed | Samples values before current time-slot updates |
| Active | Executes normal procedural statements and blocking assignments |
| Inactive | Processes `#0` scheduled events |
| NBA | Applies nonblocking assignment (`<=`) updates |
| Observed | Evaluates concurrent assertions |
| Reactive | Executes assertion/program-related reactive code |
| Postponed | Final observation region; `$strobe` executes here |

Understanding event regions is important for:

- RTL simulation
- Testbench synchronization
- Nonblocking assignments
- Race-condition analysis
- Assertions
- Clocking blocks
- UVM scheduling

---

## Running Code

**Code type:** SystemVerilog simulation demo / event-region demonstration

```systemverilog
`timescale 1ns/1ps

module sv_093_event_regions_tb;

    logic a;
    logic b;

    initial begin

        a = 1'b0;
        b = 1'b0;

        $display("[%0t] Active    : a=%b b=%b",
                 $time, a, b);

        // Active region: blocking assignment
        a = 1'b1;

        // NBA region: scheduled update
        b <= a;

        // Active region executes before NBA
        $display("[%0t] Active    : a=%b b=%b",
                 $time, a, b);

        // Inactive region
        #0;
        $display("[%0t] Inactive  : a=%b b=%b",
                 $time, a, b);

        // Postponed region observation
        $strobe("[%0t] Postponed : a=%b b=%b",
                $time, a, b);

        #1;

        $finish;

    end

endmodule
````

---

## Expected Output

Conceptually:

```text
[0] Active    : a=0 b=0
[0] Active    : a=1 b=0
[0] Inactive  : a=1 b=1
[0] Postponed : a=1 b=1
```

The simplified scheduling order is:

```text
Preponed
    ↓
Active
    ↓
Inactive
    ↓
NBA
    ↓
Observed
    ↓
Reactive
    ↓
Postponed
```

The simulator can revisit scheduling regions when new events are generated, so this should not be interpreted as a simple one-pass execution sequence.

### Active Region

Normal procedural statements and blocking assignments execute here.

```systemverilog
a = 1'b1;
```

The value of `a` changes immediately.

### Inactive Region

A zero-delay control such as:

```systemverilog
#0;
```

moves execution to the Inactive region of the same simulation time slot.

### NBA Region

Nonblocking assignments are scheduled for the NBA region.

```systemverilog
b <= a;
```

The update to `b` does not happen immediately.

### Observed Region

Concurrent SystemVerilog assertions are evaluated in the Observed region.

This makes assertion checking occur after the relevant design updates have been processed.

### Reactive Region

Reactive activity is associated with assertion/program-based verification behavior.

It is important when understanding advanced testbench scheduling.

### Postponed Region

The Postponed region is used for final observation of the current time slot.

For example:

```systemverilog
$strobe("b=%b", b);
```

`$strobe` reports the value after the current update activity has completed.

---

## `$display` vs `$strobe`

```text
$display
    → executes immediately when called

$strobe
    → reports values in the Postponed region
```

Therefore `$strobe` is useful when you want to observe the final value after NBA updates and other current-time-slot activity.

---

## Vivado Usage

1. Add `sv_093_event_regions_tb.sv` under **Simulation Sources**.
2. Set `sv_093_event_regions_tb` as the simulation top.
3. Run **Run Simulation → Run Behavioral Simulation**.
4. Observe the console output.
5. Compare `$display` and `$strobe`.

---

## Key Takeaway

SystemVerilog uses event regions to control simulation scheduling.

The simplified flow is:

```text
Preponed → Active → Inactive → NBA → Observed → Reactive → Postponed
```

Knowing these regions helps explain why two statements occurring at the same simulation time can still observe different signal values.

