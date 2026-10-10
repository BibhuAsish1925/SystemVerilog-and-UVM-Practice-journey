# 022 — SV-022 — Array Reduction

## Introduction

SystemVerilog array reduction methods combine all elements of an array into a single result.

The five important reduction methods are:

| Method | Operation |
|---|---|
| `sum()` | Adds all elements |
| `product()` | Multiplies all elements |
| `and()` | Bitwise AND of all elements |
| `or()` | Bitwise OR of all elements |
| `xor()` | Bitwise XOR of all elements |

## `sum()`

`sum()` adds all elements:

```systemverilog id="q7m3kd"
sum_result = data.sum();
```

For:

```text
{12, 10, 6}
```

the result is:

```text
12 + 10 + 6 = 28
```

## `product()`

`product()` multiplies all elements:

```systemverilog id="r5x9nb"
product_result = data.product();
```

For the same array:

```text
12 × 10 × 6 = 720
```

## `and()`

`and()` performs a bitwise AND across all elements:

```systemverilog id="t2v6hf"
and_result = data.and();
```

For the example:

```text
1100
1010
0110
----
0000
```

Therefore:

```text
and = 0000
```

## `or()`

`or()` performs a bitwise OR across all elements:

```systemverilog id="w8k4mc"
or_result = data.or();
```

```text
1100
1010
0110
----
1110
```

Therefore:

```text
or = 1110
```

## `xor()`

`xor()` performs a bitwise XOR across all elements:

```systemverilog id="p3n7qx"
xor_result = data.xor();
```

```text
1100
1010
0110
----
0000
```

Therefore:

```text
xor = 0000
```

## Verification Relevance

Array reduction methods are useful in verification for:

- Calculating totals of transaction fields.
- Generating expected arithmetic results.
- Checking combined bit conditions.
- Calculating parity-like values with XOR.
- Creating compact reference-model calculations.
- Reducing repetitive loops in testbench code.

## Complete Runnable Code

```systemverilog id="m6q2vz"
module sv_022_array_reduction;

    logic [3:0] data[3] = '{4'b1100, 4'b1010, 4'b0110};

    int sum_result;
    int product_result;
    logic [3:0] and_result;
    logic [3:0] or_result;
    logic [3:0] xor_result;

    initial begin
        $display("Array:");
        foreach (data[i])
            $display("data[%0d] = %b", i, data[i]);

        // Arithmetic reductions
        sum_result     = data.sum();
        product_result = data.product();

        // Bitwise reductions
        and_result = data.and();
        or_result  = data.or();
        xor_result = data.xor();

        $display("\nReduction Results:");
        $display("sum     = %0d", sum_result);
        $display("product = %0d", product_result);
        $display("and     = %b", and_result);
        $display("or      = %b", or_result);
        $display("xor     = %b", xor_result);
    end

endmodule
```

## Expected Output

```text
Array:
data[0] = 1100
data[1] = 1010
data[2] = 0110

Reduction Results:
sum     = 28
product = 720
and     = 0000
or      = 1110
xor     = 0000
```

## Key Takeaways

- `sum()` → adds all array elements.
- `product()` → multiplies all array elements.
- `and()` → bitwise AND across all elements.
- `or()` → bitwise OR across all elements.
- `xor()` → bitwise XOR across all elements.
- Reduction methods provide concise alternatives to manually iterating through arrays.
- They are useful for arithmetic calculations and bit-level checks in verification.