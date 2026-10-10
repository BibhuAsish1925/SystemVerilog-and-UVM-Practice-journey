# 059 — SV-059 — `rand_mode()`

## Concept

`rand_mode()` controls whether an individual `rand` variable participates in randomization.

Syntax:

```systemverilog
variable.rand_mode(0);  // Disable
variable.rand_mode(1);  // Enable
```

When randomization is disabled for a variable, calling `randomize()` does not generate a new value for that variable. Its existing value is retained.

For example:

```systemverilog
trans.data.rand_mode(0);
```

disables randomization of `data`.

It can later be enabled again:

```systemverilog
trans.data.rand_mode(1);
```

### Important points

- `rand_mode(1)` enables randomization.
- `rand_mode(0)` disables randomization.
- The setting applies to the specific random variable.
- A disabled variable keeps its current value during subsequent `randomize()` calls.
- Other enabled random variables continue to randomize normally.
- `rand_mode()` is useful when a test needs precise control over which transaction fields are randomized.

## Complete Runnable Code

```systemverilog
module sv_059_rand_mode;

    class transaction;

        rand int data;
        rand int address;

        constraint data_range {
            data inside {[10:20]};
        }

        constraint address_range {
            address inside {[100:200]};
        }

        function void display(string label);
            $display("%s: data = %0d | address = %0d",
                     label, data, address);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Both variables are randomized
        trans.randomize();
        trans.display("Both enabled");


        // Disable randomization of data
        trans.data.rand_mode(0);

        // Only address is randomized
        trans.randomize();
        trans.display("Data disabled");


        // Re-enable randomization of data
        trans.data.rand_mode(1);

        // Both variables are randomized again
        trans.randomize();
        trans.display("Both enabled again");

    end

endmodule
```

## Verification Relevance

`rand_mode()` is useful when a verification environment needs to randomize most transaction fields while keeping a particular field fixed.

For example, a test can generate a random transaction first and then disable one field:

```systemverilog
trans.data.rand_mode(0);
```

The next `randomize()` call can change other enabled fields while preserving the existing `data` value.

This provides selective control over constrained-random stimulus generation.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the transaction values in the simulator console.