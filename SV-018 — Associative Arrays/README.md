# 018 — SV-018 — Associative Arrays

## Introduction

An **associative array** is a SystemVerilog collection that stores elements using an index or key. Unlike fixed and dynamic arrays, its indexes do not need to form a continuous range.

Associative arrays are especially useful when the index space is large or **sparse**, because storage is allocated for the entries that are actually used.

## Integer Indexing

An associative array can use an integer as its index:

```systemverilog id="p8h4vz"
int scores[int];

scores[10]  = 95;
scores[25]  = 88;
scores[100] = 76;
```

The keys can be `10`, `25`, and `100` without requiring elements for all values between them.

## String Indexing

A string can also be used as the key:

```systemverilog id="x3n7ka"
int marks[string];

marks["Math"]    = 95;
marks["Physics"] = 88;
marks["Verilog"] = 92;
```

This allows data to be associated with meaningful names rather than numeric indexes.

## Sparse Storage

Associative arrays are useful for sparse data because only the entries that are actually assigned need to be stored.

For example:

```text id="f5m1qz"
scores[10]  = 95
scores[25]  = 88
scores[100] = 76
```

contains only three stored entries even though the highest index is `100`.

The `size()` method returns the number of stored entries:

```systemverilog id="w6c9rt"
scores.size()
```

## Verification Relevance

Associative arrays are useful in verification for:

- Lookup tables.
- Mapping IDs to transactions.
- Storing expected values using transaction IDs.
- Maintaining sparse data sets.
- Associating meaningful string names with values.
- Scoreboards and reference-model data structures.

## Complete Runnable Code

```systemverilog id="n2k7fd"
module sv_018_associative_arrays;

    // Integer-indexed associative array
    int scores[int];

    // String-indexed associative array
    int marks[string];

    initial begin
        // Integer indexing
        scores[10] = 95;
        scores[25] = 88;
        scores[100] = 76;

        $display("Integer-indexed array:");
        $display("scores[10]  = %0d", scores[10]);
        $display("scores[25]  = %0d", scores[25]);
        $display("scores[100] = %0d", scores[100]);

        // String indexing
        marks["Math"]    = 95;
        marks["Physics"] = 88;
        marks["Verilog"] = 92;

        $display("\nString-indexed array:");
        $display("marks[Math]    = %0d", marks["Math"]);
        $display("marks[Physics] = %0d", marks["Physics"]);
        $display("marks[Verilog] = %0d", marks["Verilog"]);

        // Sparse storage
        $display("\nSparse storage:");
        $display("scores.size() = %0d", scores.size());
        $display("marks.size()  = %0d", marks.size());
    end

endmodule
```

## Expected Output

```text id="c0w4bn"
Integer-indexed array:
scores[10]  = 95
scores[25]  = 88
scores[100] = 76

String-indexed array:
marks[Math]    = 95
marks[Physics] = 88
marks[Verilog] = 92

Sparse storage:
scores.size() = 3
marks.size()  = 3
```

## Key Takeaways

- Associative arrays use **keys/indexes** rather than fixed positions.
- `int array[int]` creates an integer-indexed associative array.
- `int array[string]` creates a string-indexed associative array.
- Keys do not have to be consecutive.
- This makes associative arrays suitable for **sparse storage**.
- `size()` returns the number of currently stored entries.
- Associative arrays are particularly valuable in verification for lookup tables, transaction tracking, and scoreboard/reference-model data.