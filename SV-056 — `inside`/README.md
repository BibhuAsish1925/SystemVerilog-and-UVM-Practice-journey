# 056 — SV-056 — `inside`

The SystemVerilog `inside` operator checks whether a value belongs to a specified **set of values or ranges**.

It is particularly useful inside constraints for defining the legal values of a randomized variable.

### Basic Syntax

For individual values:

```systemverilog id="h0a6sd"
data inside {5, 10, 15}
```

For ranges:

```systemverilog id="j6w3p2"
data inside {[10:20]}
```

Multiple values and ranges can be combined:

```systemverilog id="m4jv8c"
data inside {5, 10, [20:25], [40:45]}
```

This allows `data` to take only values from the specified set.

### Value Sets

Individual values can be listed directly:

```systemverilog id="q3c9r5"
data inside {5, 10, 20}
```

Valid values are:

```text
5, 10, 20
```

### Ranges

A range is specified using:

```systemverilog id="k7h2ws"
[lower:upper]
```

For example:

```systemverilog id="n8m5qa"
data inside {[20:25]}
```

allows:

```text
20, 21, 22, 23, 24, 25
```

### Why it matters in verification

`inside` provides a compact and readable way to define legal transaction values. It is useful when a protocol or design allows only specific values or groups of valid ranges.

### Complete Runnable Code

```systemverilog id="sv056_complete"
module sv_056_inside;

    class transaction;

        rand int data;

        // Restrict data to selected values and ranges
        constraint data_values {
            data inside {5, 10, [20:25], [40:45]};
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

The exact values vary because they are randomly generated.

Example:

```text
Transaction 1: data = 23
Transaction 2: data = 5
Transaction 3: data = 42
Transaction 4: data = 10
Transaction 5: data = 25
Transaction 6: data = 21
Transaction 7: data = 44
Transaction 8: data = 40
Transaction 9: data = 24
Transaction 10: data = 45
```

Every generated value belongs to:

```text
5, 10, 20–25, 40–45
```

**Key concepts:** `inside`, value sets, ranges, legal value selection, constrained randomization.