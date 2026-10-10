# 066 — SV-066 — Constraint Override

## Concept

Constraint override describes how a derived class can change the constraint behavior inherited from a base class.

A derived constraint normally does **not** automatically replace a base constraint. If both constraints are enabled, they are combined.

For example:

```text
Base constraint:     data = 10–50
Derived constraint:  data = 30–40
Effective range:    data = 30–40
```

This is called **constraint extension**.

To replace the inherited constraint for a derived object, the inherited constraint can be disabled using `constraint_mode(0)`.

## Important Syntax

### Constraint extension

```systemverilog
constraint write_range {
    data inside {[30:40]};
}
```

The inherited base constraint remains active, so both constraints participate in randomization.

### Disable inherited constraint

```systemverilog
base_range.constraint_mode(0);
```

This disables the inherited constraint for that object.

### Constraint replacement

After disabling the base constraint, the derived constraint becomes the effective restriction.

```text
Base constraint:     disabled
Derived constraint:  active
```

## Verification Relevance

Constraint extension is useful when specialized transactions need stricter rules than the base transaction.

Constraint replacement is useful when a derived transaction needs a completely different legal range from the base transaction.

## Complete Runnable Code

```systemverilog
module sv_066_constraint_override;

    // Base class
    class transaction;

        rand int data;

        // Base constraint
        constraint base_range {
            data inside {[10:50]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    // Derived class
    class write_transaction extends transaction;

        // Derived constraint
        constraint write_range {
            data inside {[60:80]};
        }

        function void disable_base_constraint();
            base_range.constraint_mode(0);
        endfunction

    endclass


    transaction base_trans;
    write_transaction write_trans;

    initial begin

        // Base class uses its own constraint
        base_trans = new();

        if (base_trans.randomize())
            base_trans.display("Base transaction");
        else
            $display("Base randomization failed");


        // Derived class
        write_trans = new();

        // Disable inherited constraint
        write_trans.disable_base_constraint();

        if (write_trans.randomize())
            write_trans.display("Write transaction");
        else
            $display("Write randomization failed");

    end

endmodule
```

## Example Output

```text
Base transaction: data = 27
Write transaction: data = 73
```

The exact values vary because they are randomized.