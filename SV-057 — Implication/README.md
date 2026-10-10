# 057 — SV-057 — Implication

## Concept

SystemVerilog implication `->` is used inside constraints to create a **conditional relationship**.

The general syntax is:

```systemverilog
condition -> required_condition;
```

This means:

> If the left-hand condition is true, the right-hand condition must also be true.

For example:

```systemverilog
write -> data inside {[10:50]};
```

means that whenever `write` is `1`, `data` must be within the range `10` to `50`.

If `write` is `0`, the implication does not impose a restriction on `data`.

### Important points

- `->` is commonly used for **conditional constraints**.
- The left side is the **condition**.
- The right side is the **requirement** when that condition is true.
- If the left side is false, the implication does not constrain the right side.
- It is especially useful for modeling transaction-dependent rules during constrained randomization.

## Complete Runnable Code

```systemverilog
module sv_057_implication;

    class transaction;

        rand bit write;
        rand int data;

        // If write is 1, data must be between 10 and 50
        constraint write_data {
            write -> data inside {[10:50]};
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

Implication is important in verification because many transaction rules are conditional.

For example:

```systemverilog
read -> address inside {[100:200]};
```

can express a rule where a particular address restriction applies only to read transactions.

This makes constrained-random transaction generation more realistic while keeping the constraint reusable.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the randomized values in the simulator console.