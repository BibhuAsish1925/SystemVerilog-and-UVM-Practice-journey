# 054 — SV-054 — Inline Constraints

An **inline constraint** allows additional constraints to be specified directly during a `randomize()` call.

### Syntax

```systemverilog
object.randomize() with {
    constraint_expression;
};
```

For example:

```systemverilog
trans.randomize() with {
    data >= 40;
    data <= 60;
};
```

The inline constraint applies to that particular randomization call.

### Class Constraint + Inline Constraint

A class can have a permanent constraint:

```systemverilog
constraint data_range {
    data >= 0;
    data <= 100;
}
```

An inline constraint can then further restrict the same variable:

```systemverilog
trans.randomize() with {
    data >= 40;
    data <= 60;
};
```

The generated value must satisfy **both** the class constraint and the inline constraint.

The inline constraint does not permanently modify the class constraint.

### Why it matters in verification

Inline constraints are useful when different tests need different temporary stimulus requirements. Instead of creating separate classes or permanently changing the base constraint, a test can specialize a particular randomization call.

### Complete Runnable Code

```systemverilog id="sv054_complete"
module sv_054_inline_constraints;

    class transaction;

        rand int data;

        // Base constraint
        constraint data_range {
            data >= 0;
            data <= 100;
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Normal randomization using class constraint
        if (trans.randomize())
            trans.display("Base constraint");
        else
            $display("Randomization failed");


        // Inline constraint: 40 to 60
        if (trans.randomize() with {
            data >= 40;
            data <= 60;
        })
            trans.display("Inline constraint");
        else
            $display("Randomization failed");


        // Inline constraint: exact value
        if (trans.randomize() with {
            data == 75;
        })
            trans.display("Exact value");
        else
            $display("Randomization failed");

    end

endmodule
```

### Expected Output

Example:

```text
Base constraint: data = 37
Inline constraint: data = 54
Exact value: data = 75
```

The exact randomized values can vary, but:

```text
Base constraint  → 0 <= data <= 100
Inline constraint → 40 <= data <= 60
Exact value       → data = 75
```

**Key concepts:** `randomize() with {}`, inline constraints, temporary constraints, class constraints, combined constraint solving.