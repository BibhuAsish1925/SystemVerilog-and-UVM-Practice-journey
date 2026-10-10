# 058 — SV-058 — `solve...before`

## Concept

SystemVerilog provides `solve...before` to specify the **constraint solving order** of randomized variables.

Syntax:

```systemverilog
solve variable_a before variable_b;
```

This tells the constraint solver to solve `variable_a` before `variable_b`.

For example:

```systemverilog
solve write before data;
```

means that `write` should be solved before `data`.

This is useful when the value or distribution of one randomized variable affects another variable.

### Important points

- `solve...before` controls **solving order**.
- It does not by itself create a constraint relationship.
- Other constraints must define how one variable depends on another.
- It is useful for controlling randomization behavior when variables are related.
- The order can affect the resulting random distribution even when the same legal values are generated.

## Complete Runnable Code

```systemverilog
module sv_058_solve_before;

    class transaction;

        rand bit write;
        rand int data;

        // Solve write before data
        constraint solve_order {
            solve write before data;
        }

        // Data depends on write
        constraint data_rule {
            if (write)
                data inside {[10:20]};
            else
                data inside {[80:90]};
        }

        function void display(int count);
            $display("Transaction %0d: write = %0d | data = %0d",
                     count, write, data);
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

## Verification Relevance

`solve...before` is useful when creating constrained-random verification scenarios where one variable logically determines the valid range or distribution of another.

For example, a transaction may first determine whether it is a read or write operation and then constrain the remaining fields according to that operation.

The important distinction is:

```systemverilog
solve write before data;
```

controls **how the solver handles the variables**, while:

```systemverilog
if (write)
    data inside {[10:20]};
else
    data inside {[80:90]};
```

defines the actual **legal relationship** between them.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the randomized values in the simulator console.