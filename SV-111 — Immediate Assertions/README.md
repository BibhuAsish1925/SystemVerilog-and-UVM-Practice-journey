# 111 — SV-111 — Immediate Assertions

### Concept

An immediate assertion checks a Boolean expression at the exact point where the assertion is executed.

Basic syntax:

```systemverilog
assert (expression);
````

An optional `else` block can report an assertion failure:

```systemverilog
assert (expression)
    else $error("Assertion failed");
```

If the expression evaluates to `1`, the assertion passes.

If the expression evaluates to `0`, the assertion fails and the `else` statement is executed.

Immediate assertions are useful for checking:

* Data validity
* Control signals
* Configuration values
* Simple protocol conditions
* Testbench assumptions
* Internal design conditions

### Important Difference

Immediate assertions are **procedural**. They execute when the surrounding procedural statement is reached.

They are different from **concurrent assertions**, which are used to verify behavior across clock cycles and temporal sequences.

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_111_immediate_assertions_tb;

    logic [7:0] data;
    logic       valid;

    initial begin

        // Assertion passes
        data  = 8'hA5;
        valid = 1'b1;

        assert (valid == 1'b1)
            else $error("Assertion failed: valid is not 1");

        assert (data == 8'hA5)
            else $error("Assertion failed: data is not A5");

        $display("[%0t] First assertions passed",
                 $time);

        // Assertion intentionally fails
        valid = 1'b0;

        assert (valid == 1'b1)
            else $error("Assertion failed: valid is 0");

        $display("[%0t] Simulation continues after assertion",
                 $time);

        $finish;

    end

endmodule
```

### Expected Output

The exact XSim diagnostic formatting may vary, but the result is conceptually:

```text
[0] First assertions passed
ERROR: Assertion failed: valid is 0
[0] Simulation continues after assertion
$finish called at time : 0 ns
```

The failed assertion does not automatically stop the simulation because `$error` is used.

For a fatal failure, `$fatal` can be used:

```systemverilog
assert (valid == 1'b1)
    else $fatal("Fatal assertion failure");
```

### Verification Relevance

Immediate assertions provide a simple way to detect invalid conditions during simulation.

They are especially useful for local checks such as:

```systemverilog
assert (data <= 8'hFF);
assert (valid == 1'b1);
assert (addr < 16);
```

They form the foundation for learning SystemVerilog Assertions before moving to concurrent assertions and temporal properties.

