# 051 — SV-051 — Randomization Failure

The SystemVerilog `randomize()` method returns a status value indicating whether randomization was successful.

```systemverilog id="q0p4te"
if (trans.randomize())
    // Randomization succeeded
else
    // Randomization failed
```

### Return Value

| Return value | Meaning |
|---|---|
| `1` | Randomization succeeded |
| `0` | Randomization failed |

A failure occurs when the active constraints cannot be satisfied simultaneously.

### Example

Consider:

```systemverilog id="5r5y7j"
constraint valid_range {
    data >= 10;
    data <= 20;
}

constraint impossible_range {
    data > 50;
}
```

The solver would need to find a value satisfying:

```text id="1wq7zk"
10 <= data <= 20
data > 50
```

No such value exists, so `randomize()` returns `0`.

### Why checking the return value matters

A verification environment should check the result of `randomize()` before using the generated transaction. This allows the testbench to detect invalid constraint combinations instead of silently continuing with an unusable transaction.

### Complete Runnable Code

```systemverilog id="sv051_complete"
module sv_051_randomization_failure;

    class transaction;

        rand int data;

        // Conflicting constraints
        constraint valid_range {
            data >= 10;
            data <= 20;
        }

        constraint impossible_range {
            data > 50;
        }

    endclass


    transaction trans;
    bit status;

    initial begin

        trans = new();

        // Try to randomize
        status = trans.randomize();

        if (status) begin
            $display("Randomization SUCCESS");
            $display("data = %0d", trans.data);
        end
        else begin
            $display("Randomization FAILED");
            $display("No value satisfies all constraints");
        end

    end

endmodule
```

### Expected Output

```text
Randomization FAILED
No value satisfies all constraints
```

**Key concepts:** `randomize()` return value, successful randomization, failed randomization, conflicting constraints, checking solver status.