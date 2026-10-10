# 061 — SV-061 — Conditional Constraints

## Concept

SystemVerilog allows `if/else` statements inside constraint blocks to create **conditional constraints**.

Syntax:

```systemverilog id="q1m7sa"
constraint name {
    if (condition)
        constraint_expression_1;
    else
        constraint_expression_2;
}
```

The selected constraint depends on the value of the condition.

For example:

```systemverilog id="h7m3qc"
if (write)
    data inside {[10:20]};
else
    data inside {[80:90]};
```

If `write` is `1`, `data` must be between `10` and `20`.

If `write` is `0`, `data` must be between `80` and `90`.

### Important points

- `if/else` can be used inside constraint blocks.
- The condition determines which constraint expression applies.
- Conditional constraints are useful when one transaction field controls another field.
- The condition itself can also be a randomized variable.
- All active constraints must still be satisfied by the final randomized values.

## Complete Runnable Code

```systemverilog id="m7v2kp"
module sv_061_conditional_constraints;

    class transaction;

        rand bit write;
        rand int data;

        // Conditional constraint
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

Conditional constraints are important in constrained-random verification because transaction fields often depend on each other.

For example, a verification environment may generate different legal data ranges depending on whether a transaction represents a read or write operation.

This allows one transaction class to generate multiple valid scenarios while maintaining protocol-specific relationships between fields.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the randomized transactions in the simulator console.