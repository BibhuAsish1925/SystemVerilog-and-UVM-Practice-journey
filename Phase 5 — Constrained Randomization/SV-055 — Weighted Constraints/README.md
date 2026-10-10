# 055 — SV-055 — Weighted Constraints

SystemVerilog provides the `dist` constraint to control the **relative probability** of randomized values.

### Basic Syntax

```systemverilog
data dist {
    value_or_range := weight
};
```

Two important operators are:

- `:=` — the weight is assigned to **each value** in the item or range.
- `:/` — the weight is **distributed across** all values in the item or range.

### `:=`

For:

```systemverilog
data dist {
    [1:3] := 2;
};
```

each value receives weight `2`:

```text
1 → 2
2 → 2
3 → 2
```

### `:/`

For:

```systemverilog
data dist {
    [1:3] :/ 3;
};
```

the total weight `3` is distributed across the three values:

```text
1 → 1
2 → 1
3 → 1
```

Therefore, `:=` and `:/` behave differently when applied to ranges.

### Example

```systemverilog
data dist {
    0       := 1,
    [1:3]   := 2,
    [4:6]   :/ 3
};
```

The resulting relative weights are:

```text
0 → 1
1 → 2
2 → 2
3 → 2
4 → 1
5 → 1
6 → 1
```

The solver uses these weights to influence the probability of selecting each value.

### Why it matters in verification

Weighted constraints are useful when some scenarios should occur more frequently than others. For example, common protocol operations can be given higher probability while less common operations remain possible.

The weights describe **relative probability**, not an exact occurrence count. A small number of randomizations may not reflect the expected statistical distribution.

### Complete Runnable Code

```systemverilog
module sv_055_weighted_constraints;

    class transaction;

        rand int data;

        // Weighted distribution
        constraint data_weight {
            data dist {
                0       := 1,
                [1:3]   := 2,
                [4:6]   :/ 3
            };
        }

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        trans = new();

        for (count = 1; count <= 10; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule
```

### Expected Output

The exact sequence varies between simulations.

Example:

```text
Transaction 1: data = 2
Transaction 2: data = 5
Transaction 3: data = 1
Transaction 4: data = 3
Transaction 5: data = 4
Transaction 6: data = 2
Transaction 7: data = 6
Transaction 8: data = 1
Transaction 9: data = 5
Transaction 10: data = 3
```

**Key concepts:** `dist`, weighted randomization, `:=`, `:/`, range weighting, relative probability.