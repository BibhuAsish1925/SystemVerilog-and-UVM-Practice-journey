# 048 — SV-048 — Basic Randomization

SystemVerilog provides **constrained randomization** to automatically generate test values for verification.

A class property declared with the `rand` keyword becomes a **random variable**.

### `rand`

```systemverilog
rand int data;
```

This tells SystemVerilog that `data` can be randomized.

### `randomize()`

The `randomize()` method generates a random value for the `rand` properties of the object.

```systemverilog
if (trans.randomize())
    $display("Randomization successful");
else
    $display("Randomization failed");
```

`randomize()` returns:

- `1` when randomization succeeds.
- `0` when randomization fails.

At this basic stage there are no constraints, so the `rand` variable can take values from its legal data-type range.

### Why it matters in verification

Randomization allows a verification environment to automatically generate different transaction values instead of manually writing every test value. This becomes especially useful when combined with constraints to generate meaningful legal test scenarios.

### Complete Runnable Code

```systemverilog
module sv_048_basic_randomization;

    class transaction;

        // Random variable
        rand int data;

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        // Create transaction object
        trans = new();

        // Generate five random transactions
        for (count = 1; count <= 5; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule
```

### Expected Output

The exact values vary because they are randomly generated.

Example:

```text
Transaction 1: data = 184739201
Transaction 2: data = -93652741
Transaction 3: data = 572819304
Transaction 4: data = -38192017
Transaction 5: data = 726193501
```

**Key concepts:** `rand`, random variable, `randomize()`, randomization success/failure, randomized verification data.