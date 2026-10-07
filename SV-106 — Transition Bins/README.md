
# 106 — SV-106 — Transition Bins

## 1. Concept

Transition bins measure changes between values or states across consecutive coverage samples.

A normal coverage bin answers:

> Did this value occur?

A transition bin answers:

> Did the signal change from this value to another value?

For example:

```systemverilog
bins idle_to_active = (2'b00 => 2'b01);
````

checks for the transition:

`00 → 01`

Transition coverage is particularly useful for FSMs and protocol state machines.

## 2. Important Syntax

```systemverilog
coverpoint state {

    bins idle_to_active = (2'b00 => 2'b01);
    bins active_to_done = (2'b01 => 2'b10);

}
```

The `=>` operator specifies a transition between consecutive samples.

For example:

```systemverilog
state = 2'b00;
cg.sample();

state = 2'b01;
cg.sample();
```

creates the transition:

```text
00 → 01
```

The transition bin is considered covered when that sequence occurs.

## 3. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_106_transition_bins_tb;

    logic [1:0] state;

    covergroup state_cg;

        coverpoint state {

            // Individual state values
            bins idle   = {2'b00};
            bins active = {2'b01};
            bins done   = {2'b10};

            // State transitions
            bins idle_to_active = (2'b00 => 2'b01);
            bins active_to_done = (2'b01 => 2'b10);
            bins done_to_idle   = (2'b10 => 2'b00);

        }

    endgroup

    state_cg cg;

    initial begin

        cg = new();

        // IDLE -> ACTIVE
        state = 2'b00;
        cg.sample();

        state = 2'b01;
        cg.sample();

        // ACTIVE -> DONE
        state = 2'b10;
        cg.sample();

        // DONE -> IDLE
        state = 2'b00;
        cg.sample();

        $display("[%0t] Transition coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 4. Expected Result

```text
[0] Transition coverage = 100.00%
$finish called at time : 0 ns
```

The sampled state sequence is:

```text
IDLE → ACTIVE → DONE → IDLE
```

Therefore:

| Transition | Covered |
| ---------- | ------- |
| `00 → 01`  | Yes     |
| `01 → 10`  | Yes     |
| `10 → 00`  | Yes     |

All three transition bins are covered.

## 5. Verification Relevance

Transition bins are useful for verifying:

* FSM state transitions.
* Protocol state changes.
* Control-signal sequences.
* Power-mode transitions.
* Valid/ready behavior.
* Required state-to-state paths.

The key distinction is:

`bins` → checks values.

`transition bins` → checks sequences of values.

The basic syntax is:

```systemverilog
bins transition_name = (value1 => value2);
```


