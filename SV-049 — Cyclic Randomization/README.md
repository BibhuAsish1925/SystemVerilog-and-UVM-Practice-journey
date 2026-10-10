# 049 — SV-049 — Cyclic Randomization

SystemVerilog provides the `randc` keyword for **cyclic randomization**.

A `randc` variable generates its possible values in a randomized order, but it does not repeat a value until all possible values in the current cycle have been used.

### `randc` Syntax

```systemverilog
randc logic [1:0] data;
```

A 2-bit variable has four possible values:

```text
0, 1, 2, 3
```

A possible cyclic sequence is:

```text
2, 0, 3, 1
```

After all four values have been generated, a new cycle begins and the values can appear again in another randomized order.

### `rand` vs `randc`

| Feature | `rand` | `randc` |
|---|---|---|
| Random values | Yes | Yes |
| Cyclic behavior | No | Yes |
| Prevents repetition within a cycle | No | Yes |
| Useful for | General random testing | Ensuring all values are exercised |

### Why it matters in verification

`randc` is useful when verification needs to exercise every possible value before repeating values. This can help provide systematic coverage of small finite value spaces such as opcodes, modes, states, or small configuration fields.

### Complete Runnable Code

```systemverilog id="sv049_complete"
module sv_049_cyclic_randomization;

    class transaction;

        // 2-bit cyclic random variable
        randc logic [1:0] data;

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        trans = new();

        // Generate two complete cycles
        for (count = 1; count <= 8; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule
```

### Expected Output

The exact order is random.

Example:

```text
Transaction 1: data = 2
Transaction 2: data = 0
Transaction 3: data = 3
Transaction 4: data = 1
Transaction 5: data = 0
Transaction 6: data = 2
Transaction 7: data = 1
Transaction 8: data = 3
```

Each group of four successful randomizations contains all four possible values exactly once.

**Key concepts:** `randc`, cyclic randomization, randomized ordering, no repetition within a cycle, value-space coverage.