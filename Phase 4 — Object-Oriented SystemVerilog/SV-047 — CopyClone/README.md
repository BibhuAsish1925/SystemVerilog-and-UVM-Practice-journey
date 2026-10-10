# 047 — SV-047 — Copy/Clone

SystemVerilog does not provide a universal built-in `copy()` or `clone()` method for every user-defined class. In verification environments, these methods are commonly written by the verification engineer to define how an object should be copied.

### `copy()`

A user-defined `copy()` method normally copies the contents of one object into an **existing destination object**.

```systemverilog id="copy-method"
function void copy(transaction rhs);
    this.data = rhs.data;
    this.name = rhs.name;
endfunction
```

Usage:

```systemverilog id="copy-usage"
copied = new();
copied.copy(original);
```

The destination object already exists before `copy()` is called.

### `clone()`

A user-defined `clone()` method normally creates a **new object**, copies the current object's contents into it, and returns the new object.

```systemverilog id="clone-method"
function transaction clone();
    transaction copy_obj;

    copy_obj = new();
    copy_obj.copy(this);

    return copy_obj;
endfunction
```

Usage:

```systemverilog id="clone-usage"
cloned = original.clone();
```

### Copy vs Clone

| Method | Purpose |
|---|---|
| `copy()` | Copies data into an existing object |
| `clone()` | Creates and returns a new copied object |

The actual copying behavior is user-defined. If a class contains nested class handles, the `copy()` implementation must explicitly create nested objects when a **deep copy** is required.

### Why it matters in verification

Transaction objects are frequently passed between verification components. User-defined `copy()` and `clone()` methods allow a testbench to create independent transaction objects without accidentally modifying the original transaction.

### Complete Runnable Code

```systemverilog id="sv047_complete"
module sv_047_copy_clone;

    class transaction;

        int data;
        string name;

        function new(int data = 0, string name = "");
            this.data = data;
            this.name = name;
        endfunction

        // User-defined copy()
        function void copy(transaction rhs);
            this.data = rhs.data;
            this.name = rhs.name;
        endfunction

        // User-defined clone()
        function transaction clone();
            transaction copy_obj;

            copy_obj = new();
            copy_obj.copy(this);

            return copy_obj;
        endfunction

        function void display(string label);
            $display("%s | Name = %s | Data = %0d",
                     label, name, data);
        endfunction

    endclass


    transaction original;
    transaction copied;
    transaction cloned;

    initial begin

        // Create original object
        original = new(100, "Original");

        // Copy into an existing object
        copied = new();
        copied.copy(original);

        // Clone into a new object
        cloned = original.clone();

        // Modify copied and cloned objects
        copied.data = 200;
        cloned.data = 300;

        // Display all objects
        original.display("Original");
        copied.display("Copied");
        cloned.display("Cloned");

    end

endmodule
```

### Expected Output

```text
Original | Name = Original | Data = 100
Copied | Name = Original | Data = 200
Cloned | Name = Original | Data = 300
```

**Key concepts:** user-defined `copy()`, user-defined `clone()`, existing destination object, new cloned object, independent transaction objects, verification transaction handling.