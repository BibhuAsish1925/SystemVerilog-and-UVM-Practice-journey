
# 112 — SV-112 — Immediate Assert/Else

### Concept

An immediate assertion checks a Boolean expression during procedural execution.

The basic form is:

```systemverilog
assert (expression)
    else statement;
````

The `else` statement executes only when the assertion expression evaluates to false.

The four important elements in this topic are:

* `assert` — checks the condition.
* `else` — specifies the failure action.
* `$error` — reports an error and normally allows simulation to continue.
* `$fatal` — reports a fatal error and terminates the simulation.

### `$error` Example

```systemverilog
assert (valid == 1'b1)
    else $error("ERROR: valid is 0");
```

If `valid` is `0`, `$error` is executed. The simulation can continue after the error.

### `$fatal` Example

```systemverilog
assert (data == 8'hA5)
    else $fatal(1, "FATAL: data is not A5");
```

If the condition is false, `$fatal` terminates the simulation.

### `$error` vs `$fatal`

| Action   | Purpose                   | Simulation         |
| -------- | ------------------------- | ------------------ |
| `$error` | Report verification error | Normally continues |
| `$fatal` | Report critical failure   | Terminates         |

Therefore, `$error` is useful for detecting a problem while allowing other checks to execute, whereas `$fatal` is useful when continuing the test would no longer be meaningful.

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_112_immediate_assert_else_tb;

    logic [7:0] data;
    logic       valid;

    initial begin

        // Passing assertion
        data  = 8'hA5;
        valid = 1'b1;

        assert (valid == 1'b1)
            else $error("ERROR: valid is not 1");

        assert (data == 8'hA5)
            else $error("ERROR: data is not A5");

        $display("[%0t] PASS: Initial checks completed",
                 $time);

        // Failed assertion handled by $error
        valid = 1'b0;

        assert (valid == 1'b1)
            else $error("ERROR: valid is 0");

        $display("[%0t] Simulation continues after $error",
                 $time);

        // Failed assertion handled by $fatal
        data = 8'h00;

        assert (data == 8'hA5)
            else $fatal(1, "FATAL: data is not A5");

        // This line is not reached
        $display("[%0t] This message will not execute",
                 $time);

        $finish;

    end

endmodule
```

### Expected Output

The exact XSim formatting can vary, but the behavior is similar to:

```text
[0] PASS: Initial checks completed
ERROR: ERROR: valid is 0
[0] Simulation continues after $error
FATAL: FATAL: data is not A5
```

The important execution sequence is:

```text
Assertion passes
      ↓
Simulation continues

Assertion fails
      ↓
$error
      ↓
Simulation continues

Assertion fails
      ↓
$fatal
      ↓
Simulation terminates
```

### Verification Relevance

Immediate assertions with explicit failure actions are useful for controlling the severity of verification checks.

For example:

```systemverilog
assert (data <= 8'hFF)
    else $error("Data value is invalid");

assert (reset === 1'b0)
    else $fatal(1, "Reset condition is invalid");
```

This allows a testbench to distinguish between an error that should be reported and a critical condition that should terminate the test.

