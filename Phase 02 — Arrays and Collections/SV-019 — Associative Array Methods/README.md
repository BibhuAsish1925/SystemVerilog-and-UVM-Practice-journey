# 019 — SV-019 — Associative Array Methods

## Introduction

SystemVerilog provides built-in methods for inspecting, traversing, and modifying associative arrays.

These methods are especially useful because associative-array indexes can be sparse and are not necessarily consecutive.

## Important Methods

| Method | Purpose |
|---|---|
| `first()` | Returns the first index |
| `last()` | Returns the last index |
| `next(index)` | Returns the next index after the specified index |
| `prev(index)` | Returns the previous index before the specified index |
| `exists(index)` | Returns `1` if the index exists, otherwise `0` |
| `num()` | Returns the number of stored elements |
| `delete(index)` | Deletes the element at the specified index |

## `first()` and `last()`

For an associative array:

```systemverilog id="a7r2mc"
data[10] = 100;
data[20] = 200;
data[50] = 500;
data[80] = 800;
```

```systemverilog id="m3v8kp"
data.first()  // returns 10
data.last()   // returns 80
```

These methods provide the boundary indexes without requiring knowledge of the indexes beforehand.

## `next()` and `prev()`

`next(index)` finds the next existing index.

For example:

```systemverilog id="n5d9qx"
data.next(20)
```

returns `50`.

Similarly:

```systemverilog id="w8c4sz"
data.prev(50)
```

returns `20`.

These methods can be used to traverse an associative array in index order.

## `exists()`

`exists(index)` checks whether a particular index is present:

```systemverilog id="p6k1vb"
data.exists(20)  // 1
data.exists(30)  // 0
```

This is useful before accessing an associative-array element when the index may not exist.

## `num()`

`num()` returns the number of currently stored elements:

```systemverilog id="t2m7hf"
data.num()
```

If four entries are stored, `num()` returns `4`.

## `delete()`

An individual entry can be removed using:

```systemverilog id="q9x3kd"
data.delete(50);
```

After deletion, index `50` no longer exists.

## Verification Relevance

Associative-array methods are useful in verification for:

- Traversing sparse transaction databases.
- Checking whether transaction IDs exist.
- Finding the first or last pending transaction.
- Moving between transaction indexes.
- Removing processed transactions.
- Managing scoreboard and reference-model data.

## Complete Runnable Code

```systemverilog id="h4v7pn"
module sv_019_associative_array_methods;

    int data[int];
    int index;

    initial begin
        // Create sparse associative array
        data[10] = 100;
        data[20] = 200;
        data[50] = 500;
        data[80] = 800;

        $display("Initial number of elements = %0d", data.num());

        // first() and last() update the index variable
        data.first(index);
        $display("First index = %0d", index);

        data.last(index);
        $display("Last index  = %0d", index);

        // Check whether an index exists
        $display("\nExists:");
        $display("data[20] exists = %0d", data.exists(20));
        $display("data[30] exists = %0d", data.exists(30));

        // Traverse using first() and next()
        $display("\nForward traversal:");

        data.first(index);

        while (1) begin
            $display("data[%0d] = %0d", index, data[index]);

            if (!data.next(index))
                break;
        end

        // Previous index
        index = 50;

        if (data.prev(index))
            $display("\nPrevious index before 50 = %0d", index);

        // Delete one entry
        data.delete(50);

        $display("\nAfter delete(50):");
        $display("Number of elements = %0d", data.num());
        $display("Exists(50) = %0d", data.exists(50));
    end

endmodule
```

## Expected Output

```text
Initial number of elements = 4
First index = 10
Last index  = 80

Exists:
data[20] exists = 1
data[30] exists = 0

Forward traversal:
data[10] = 100
data[20] = 200
data[50] = 500
data[80] = 800

Previous index before 50 = 20

After delete(50):
Number of elements = 3
Exists(50) = 0
```

## Key Takeaways

- `first()` and `last()` find the boundary indexes.
- `next()` and `prev()` allow traversal through existing indexes.
- `exists()` checks whether a specific index is present.
- `num()` returns the number of stored entries.
- `delete(index)` removes a specific associative-array entry.
- `first()` + `next()` is a useful pattern for forward traversal of sparse associative arrays.
- These methods are important for verification data structures such as scoreboards, transaction tracking, and reference models.