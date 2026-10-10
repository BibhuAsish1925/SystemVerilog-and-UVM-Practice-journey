# 063 — SV-063 — Unique Constraints

## Concept

A **unique constraint** requires a group of randomized values to be different from each other.

The standard SystemVerilog syntax is:

```systemverilog
unique {data};
```

For example:

```systemverilog
unique {data[0], data[1], data[2]};
```

requires the specified values to be pairwise different.

However, **Vivado XSim 2025.1 does not currently support unique constraints for simulation**. Therefore, this runnable example uses equivalent pairwise inequality constraints:

```systemverilog
data[0] != data[1];
data[0] != data[2];
```

and so on.

This produces the same uniqueness requirement for the five array elements while remaining compatible with XSim.

### Important points

- `unique { }` is the standard SystemVerilog unique-constraint construct.
- It requires the specified values to be different.
- XSim 2025.1 does not currently support `unique { }` constraints for simulation.
- Pairwise `!=` constraints can express the same requirement.
- `foreach` is still used to constrain every array element to the range `1` to `10`.
- Both constraints must be satisfied during randomization.

## Complete Runnable Code

```systemverilog
module sv_063_unique_constraints;

    class transaction;

        rand int data[5];

        // XSim-compatible equivalent of unique {data}
        constraint unique_data {
            data[0] != data[1];
            data[0] != data[2];
            data[0] != data[3];
            data[0] != data[4];

            data[1] != data[2];
            data[1] != data[3];
            data[1] != data[4];

            data[2] != data[3];
            data[2] != data[4];

            data[3] != data[4];
        }

        // Keep all values within the range 1 to 10
        constraint data_range {
            foreach (data[i])
                data[i] inside {[1:10]};
        }

        function void display();
            foreach (data[i])
                $display("data[%0d] = %0d", i, data[i]);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        if (trans.randomize())
            trans.display();
        else
            $display("Randomization failed");

    end

endmodule
```

## Verification Relevance

Unique values are useful when verification requires non-repeating:

- transaction IDs
- addresses
- packet fields
- test selections
- randomized array elements

For example, the following standard SystemVerilog construct expresses the concept directly:

```systemverilog
unique {data};
```

For this Vivado/XSim learning environment, equivalent pairwise inequalities are used so that the example can actually be simulated.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and verify that all five generated array elements are within `1–10` and are different from each other.