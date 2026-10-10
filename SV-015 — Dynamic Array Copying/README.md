# 015 — SV-015 — Dynamic Array Copying

## Dynamic Array Copying

SystemVerilog allows a dynamic array to be allocated with a specific size while copying elements from an existing dynamic array.

The syntax is:

```systemverilog
new[size](array)
```

For example:

```systemverilog
copy = new[8](source);
```

This creates a new dynamic array with **8 elements** and copies the existing elements from `source` into it.

## `new[size](array)`

Consider a source array containing:

```text
10, 20, 30, 40, 50
```

If we execute:

```systemverilog
copy = new[8](source);
```

the new array contains:

```text
10, 20, 30, 40, 50, 0, 0, 0
```

The existing five elements are preserved, while the additional elements receive their default value.

Therefore:

```text
Source size = 5
New size    = 8
```

## Preserving Elements

The important feature of:

```systemverilog
new[new_size](existing_array)
```

is that the existing elements are copied into the newly allocated array.

For example:

```systemverilog
source = new[5];

foreach (source[i])
    source[i] = (i + 1) * 10;

copy = new[8](source);
```

The resulting array is:

```text
copy[0] = 10
copy[1] = 20
copy[2] = 30
copy[3] = 40
copy[4] = 50
copy[5] = 0
copy[6] = 0
copy[7] = 0
```

The original `source` array is not resized or modified by this operation.

## Increasing the Array Size

If the new size is larger than the source:

```systemverilog
copy = new[8](source);
```

existing elements are preserved and additional elements are initialized to their default value.

## Decreasing the Array Size

The same mechanism can reduce the number of elements:

```systemverilog
copy = new[3](source);
```

If `source` contains:

```text
10, 20, 30, 40, 50
```

then `copy` contains:

```text
10, 20, 30
```

Only the elements that fit into the new array are preserved.

## Why This Matters in Verification

Dynamic array copying is useful when:

- Test data needs to grow during simulation
- Existing transaction data must be preserved
- Variable-length packets are being constructed
- Test vectors need resizing
- A larger or smaller working array is required

The key concept is:

> **`new[size](array)` allocates a new dynamic array and copies the existing elements into it, up to the available size.**

## Complete Runnable Code

**Code type:** SystemVerilog simulation/demo — no DUT.

```systemverilog
module sv_015_dynamic_array_copying;

    int source[];
    int copy[];

    initial begin
        // Create and initialize source array
        source = new[5];

        foreach (source[i])
            source[i] = (i + 1) * 10;

        $display("Source array:");
        foreach (source[i])
            $display("source[%0d] = %0d", i, source[i]);

        // Copy source into a larger dynamic array
        copy = new[8](source);

        $display("\nCopied array:");
        foreach (copy[i])
            $display("copy[%0d] = %0d", i, copy[i]);

        $display("\nSource size = %0d", source.size());
        $display("Copy size   = %0d", copy.size());
    end

endmodule
```

## Expected Output

```text
Source array:
source[0] = 10
source[1] = 20
source[2] = 30
source[3] = 40
source[4] = 50

Copied array:
copy[0] = 10
copy[1] = 20
copy[2] = 30
copy[3] = 40
copy[4] = 50
copy[5] = 0
copy[6] = 0
copy[7] = 0

Source size = 5
Copy size   = 8
```

## Key Syntax

### Allocate and copy

```systemverilog
copy = new[8](source);
```

### Increase size while preserving elements

```systemverilog
array = new[larger_size](array);
```

### Decrease size while preserving elements that fit

```systemverilog
array = new[smaller_size](array);
```

Remember:

```text
new[size](array)
     │      │
     │      └── existing array to copy
     └───────── new array size
```

This operation creates a **new dynamic array** and preserves the source elements that fit within the requested size.