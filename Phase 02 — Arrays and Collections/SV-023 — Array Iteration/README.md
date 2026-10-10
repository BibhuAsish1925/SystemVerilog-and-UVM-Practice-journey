# 023 — SV-023 — Array Iteration

## Introduction

SystemVerilog provides the `foreach` loop for traversing array elements conveniently.

Instead of manually writing an index-based loop such as:

```systemverilog id="q6v3mx"
for (int i = 0; i < 5; i++)
```

`foreach` automatically iterates over the valid indexes of the array.

## `foreach`

Basic syntax:

```systemverilog id="h2k8pd"
foreach (array[index]) begin
    // statements
end
```

For example:

```systemverilog id="r9m4qw"
foreach (data[i])
    $display("data[%0d] = %0d", i, data[i]);
```

Here, `i` is the **iterator variable**. During each iteration, it represents the current index.

For:

```text id="m5x7nb"
data = {10, 20, 30, 40, 50}
```

the iterator takes the values:

```text id="z3k1fc"
i = 0
i = 1
i = 2
i = 3
i = 4
```

## Iterator Variables

The iterator variable is declared by the `foreach` statement:

```systemverilog id="w8p2js"
foreach (data[i])
```

It can then be used to access both the current index and element:

```systemverilog id="e4n6vk"
data[i]
```

For multidimensional arrays, multiple iterator variables can be used:

```systemverilog id="b7q3mz"
foreach (matrix[i, j])
    $display("%0d", matrix[i][j]);
```

## Array Traversal

`foreach` automatically visits every valid element of the array.

This makes it useful for:

- Displaying array contents.
- Calculating values.
- Checking elements.
- Modifying elements.
- Processing transaction arrays in verification.

For example, calculating a sum:

```systemverilog id="k5v9cx"
sum = 0;

foreach (data[i])
    sum += data[i];
```

## Verification Relevance

Array iteration is frequently used in verification for:

- Traversing transaction arrays.
- Checking expected values.
- Processing stimulus.
- Calculating reference-model results.
- Inspecting queues and other SystemVerilog collections.
- Writing concise testbench code without manually managing indexes.

## Complete Runnable Code

```systemverilog id="n8q4fd"
module sv_023_array_iteration;

    int data[5] = '{10, 20, 30, 40, 50};
    int sum;

    initial begin
        $display("Array traversal:");

        // Iterator variable i represents the array index
        foreach (data[i]) begin
            $display("data[%0d] = %0d", i, data[i]);
        end

        // Use iterator to calculate the sum
        sum = 0;

        foreach (data[i]) begin
            sum += data[i];
        end

        $display("\nSum = %0d", sum);
    end

endmodule
```

## Expected Output

```text id="t2x6qm"
Array traversal:
data[0] = 10
data[1] = 20
data[2] = 30
data[3] = 40
data[4] = 50

Sum = 150
```

## Key Takeaways

- `foreach` provides convenient array traversal.
- The variable inside `foreach` acts as the **iterator variable**.
- The iterator represents the current array index.
- `data[i]` accesses the current element.
- Multiple iterator variables can be used for multidimensional arrays.
- `foreach` is widely used in verification because it produces concise and readable array-processing code.