# 079 — SV-079 — Semaphore

A SystemVerilog **semaphore** is used to control access to shared resources between concurrent processes.

A semaphore contains a number of **keys**. A process acquires keys before accessing a shared resource and returns them when it is finished.

### Creating a Semaphore

A semaphore is declared using:

```systemverilog id="q2k7m4"
semaphore sem;
```

It is created using `new()`:

```systemverilog id="p8v3n6"
sem = new(2);
```

The value `2` means that the semaphore initially contains two keys.

### Semaphore Methods

| Method      | Purpose                                               |
| ----------- | ----------------------------------------------------- |
| `new()`     | Creates the semaphore with a specified number of keys |
| `get()`     | Acquires one or more keys; may block                  |
| `put()`     | Returns one or more keys                              |
| `try_get()` | Attempts to acquire keys without blocking             |

For example:

```systemverilog id="a5m9r2"
sem.get(1);
```

acquires one key.

After the resource is no longer needed:

```systemverilog id="k6x1c8"
sem.put(1);
```

returns the key.

`try_get()` does not wait:

```systemverilog id="t4j8p3"
if (sem.try_get(1))
    $display("Key acquired");
else
    $display("Key unavailable");
```

### Complete Runnable Example

```systemverilog id="z7n3q5"
module sv_079_semaphore;

    semaphore sem;

    initial begin

        // Create semaphore with 2 keys
        sem = new(2);

        fork

            begin
                $display("[%0t] Process 1 requesting 1 key", $time);

                sem.get(1);

                $display("[%0t] Process 1 acquired key", $time);

                #10;

                sem.put(1);

                $display("[%0t] Process 1 returned key", $time);
            end

            begin
                #2;

                $display("[%0t] Process 2 requesting 1 key", $time);

                if (sem.try_get(1)) begin

                    $display("[%0t] Process 2 acquired key", $time);

                    #5;

                    sem.put(1);

                    $display("[%0t] Process 2 returned key", $time);

                end
                else begin

                    $display("[%0t] Process 2 could not acquire key",
                             $time);

                end
            end

        join

        $display("[%0t] All processes completed", $time);

    end

endmodule
```

### Expected Output

With a 1-ps simulator time resolution:

```text
[0] Process 1 requesting 1 key
[0] Process 1 acquired key
[2000] Process 2 requesting 1 key
[2000] Process 2 acquired key
[7000] Process 2 returned key
[10000] Process 1 returned key
[10000] All processes completed
```

The semaphore starts with two keys, so both processes can acquire one key.

If the semaphore is changed to:

```systemverilog id="b2f7k9"
sem = new(1);
```

only one process can hold the available key at a time. A `try_get()` call made while the key is unavailable returns failure immediately.

### Verification Relevance

Semaphores are useful when multiple verification processes need controlled access to a shared resource.

For example:

```text
Process 1 ──┐
            ├──> Shared Resource
Process 2 ──┘
```

A semaphore can limit how many processes access that resource simultaneously.

This is different from a mailbox: a **mailbox primarily transfers data between processes**, while a **semaphore controls access to a shared resource using keys**.
