# 078 — SV-078 — Mailbox

A SystemVerilog **mailbox** is an inter-process communication mechanism used to exchange data safely between concurrent processes.

A mailbox can be used like a FIFO communication channel between verification components.

### Creating a Mailbox

A typed mailbox can be declared as:

```systemverilog id="g6q4pn"
mailbox #(int) mbx;
```

It is then created using:

```systemverilog id="j9v2kc"
mbx = new(2);
```

The value `2` specifies the mailbox capacity.

### Mailbox Methods

| Method       | Purpose                             | Blocking?     |
| ------------ | ----------------------------------- | ------------- |
| `put()`      | Adds an item                        | Yes, if full  |
| `get()`      | Removes an item                     | Yes, if empty |
| `peek()`     | Reads next item without removing it | Yes, if empty |
| `try_put()`  | Attempts to add an item             | No            |
| `try_get()`  | Attempts to remove an item          | No            |
| `try_peek()` | Attempts to read without removing   | No            |

`put()`, `get()`, and `peek()` can block until the required mailbox condition is available.

The `try_` methods return immediately and indicate whether the operation succeeded.

### Complete Runnable Example

```systemverilog id="b8v5q3"
module sv_078_mailbox;

    mailbox #(int) mbx;

    int value;
    int result;

    initial begin

        mbx = new(2);

        // put()
        mbx.put(10);
        mbx.put(20);

        $display("[%0t] After put(): mailbox size = %0d",
                 $time, mbx.num());

        // peek()
        mbx.peek(value);
        $display("[%0t] peek()    = %0d", $time, value);

        // try_peek()
        if (mbx.try_peek(value))
            $display("[%0t] try_peek() = %0d", $time, value);
        else
            $display("[%0t] try_peek() failed", $time);

        // get()
        mbx.get(value);
        $display("[%0t] get()     = %0d", $time, value);

        // try_get()
        if (mbx.try_get(value))
            $display("[%0t] try_get() = %0d", $time, value);
        else
            $display("[%0t] try_get() failed", $time);

        // try_put()
        if (mbx.try_put(30))
            $display("[%0t] try_put(30) = SUCCESS", $time);
        else
            $display("[%0t] try_put(30) = FAILED", $time);

        // Remove remaining item
        mbx.get(result);

        $display("[%0t] Final get() = %0d", $time, result);
        $display("[%0t] Final mailbox size = %0d",
                 $time, mbx.num());

    end

endmodule
```

### Expected Output

```text
[0] After put(): mailbox size = 2
[0] peek()    = 10
[0] try_peek() = 10
[0] get()     = 10
[0] try_get() = 20
[0] try_put(30) = SUCCESS
[0] Final get() = 30
[0] Final mailbox size = 0
```

`peek()` reads the first item without removing it, while `get()` removes the item.

For example:

```text
Before peek:
10 → 20

peek() → 10

After peek:
10 → 20

get() → 10

After get:
20
```

### Verification Relevance

Mailboxes are important for communication between concurrent verification processes.

A common verification flow is:

```text
Generator
    |
    | transaction
    v
 Mailbox
    |
    v
 Driver
```

A generator can place transactions into a mailbox using `put()`, while a driver retrieves them using `get()`.

This provides synchronization and data transfer between independent processes without requiring the processes to directly call each other.
