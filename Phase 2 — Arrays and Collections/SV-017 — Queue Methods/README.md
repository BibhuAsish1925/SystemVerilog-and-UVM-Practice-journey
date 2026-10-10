# 017 — SV-017 — Queue Methods

## Introduction

SystemVerilog queues provide methods for inserting, deleting, and inspecting elements. Queue indexing can also be used to access a specific element directly.

These operations are useful in verification for dynamically managing collections of transactions or expected data.

## Important Queue Methods

| Method / Syntax | Purpose |
|---|---|
| `insert(index, value)` | Inserts `value` at the specified index |
| `delete(index)` | Removes the element at the specified index |
| `size()` | Returns the current number of elements |
| `queue[index]` | Accesses an element at a specific index |

## Indexing

Queue indexes start from `0`.

For example:

```systemverilog id="p4b1s7"
int queue[$] = '{10, 20, 30, 40};

queue[0]  // 10
queue[2]  // 30
```

## Insert

```systemverilog id="y0k3f2"
queue.insert(2, 25);
```

Before:

```text
{10, 20, 30, 40}
```

After:

```text
{10, 20, 25, 30, 40}
```

The element at index `2` and subsequent elements are shifted toward the end.

## Delete

```systemverilog id="a8v6cd"
queue.delete(3);
```

The element at index `3` is removed and subsequent elements shift toward the beginning.

## Size

```systemverilog id="w2m9kx"
queue.size()
```

returns the current number of elements in the queue.

## Verification Relevance

Queue methods are useful for:

- Managing expected transactions.
- Inserting transactions at specific positions.
- Removing processed transactions.
- Accessing individual transactions by index.
- Tracking the current number of pending transactions.

## Complete Runnable Code

```systemverilog id="n7k2qm"
module sv_017_queue_methods;

    int queue[$];
    int value;

    initial begin
        // Initialize queue
        queue = '{10, 20, 30, 40};

        $display("Initial queue:");
        $display("queue = %p", queue);

        // Indexing
        $display("\nIndexing:");
        $display("queue[0] = %0d", queue[0]);
        $display("queue[2] = %0d", queue[2]);

        // Insert 25 at index 2
        queue.insert(2, 25);

        $display("\nAfter insert(2, 25):");
        $display("queue = %p", queue);

        // Delete element at index 3
        value = queue[3];
        queue.delete(3);

        $display("\nDeleted value = %0d", value);
        $display("After delete(3):");
        $display("queue = %p", queue);

        // Queue size
        $display("\nQueue size = %0d", queue.size());
    end

endmodule
```

## Expected Output

```text
Initial queue:
queue = '{10, 20, 30, 40}

Indexing:
queue[0] = 10
queue[2] = 30

After insert(2, 25):
queue = '{10, 20, 25, 30, 40}

Deleted value = 30
After delete(3):
queue = '{10, 20, 25, 40}

Queue size = 4
```

## Key Takeaways

- `queue[index]` accesses an individual element.
- `insert(index, value)` adds an element at a specific position.
- `delete(index)` removes an element from a specific position.
- `size()` returns the current queue length.
- These methods make queues flexible for SystemVerilog verification environments.