# 046 — SV-046 — Object Copying

SystemVerilog class variables are **handles** to objects. Assigning one class handle to another does not automatically create a new object.

There are three important copying concepts:

### 1. Handle Copy

```systemverilog id="handle-copy"
handle_copy = original;
```

Only the handle is copied. Both handles refer to the **same object**.

Therefore, modifying the object through either handle affects the same object.

### 2. Shallow Copy

A shallow copy creates a **new outer object**, but nested class handles are copied as handles.

For example:

```text
original
   |
   +----> payload

shallow
   |
   +----> same payload
```

The outer transaction objects are different, but both contain a handle to the same `payload` object.

### 3. Deep Copy

A deep copy creates a new outer object and also creates independent copies of nested class objects.

```text
original
   |
   +----> payload A

deep
   |
   +----> payload B
```

Changes to the nested object in the deep copy do not affect the original nested object.

### Why this matters in verification

Transaction objects are frequently copied between generators, drivers, monitors, scoreboards, and other verification components. Understanding handle, shallow, and deep copies prevents unintended changes to transaction data.

### Complete Runnable Code

```systemverilog id="sv046_complete"
module sv_046_object_copying;

    // Simple nested class
    class payload;

        int value;

        function new(int value);
            this.value = value;
        endfunction

    endclass


    // Transaction class
    class transaction;

        int data;
        payload p;

        function new(int data, int value);
            this.data = data;
            this.p = new(value);
        endfunction

        // Shallow copy
        function transaction shallow_copy();
            transaction copy;

            copy = new(this.data, 0);
            copy.p = this.p;

            return copy;
        endfunction

        // Deep copy
        function transaction deep_copy();
            transaction copy;

            copy = new(this.data, this.p.value);

            return copy;
        endfunction

    endclass


    transaction original;
    transaction handle_copy;
    transaction shallow;
    transaction deep;

    initial begin

        // Original object
        original = new(100, 50);

        // Handle copy
        handle_copy = original;

        // Modify through handle copy
        handle_copy.data = 200;

        $display("Handle Copy:");
        $display("original.data     = %0d", original.data);
        $display("handle_copy.data  = %0d", handle_copy.data);


        // Shallow copy
        shallow = original.shallow_copy();

        // Both objects share the same nested payload
        shallow.p.value = 75;

        $display("\nShallow Copy:");
        $display("original.p.value = %0d", original.p.value);
        $display("shallow.p.value  = %0d", shallow.p.value);


        // Deep copy
        deep = original.deep_copy();

        // Deep copy has its own nested payload
        deep.p.value = 100;

        $display("\nDeep Copy:");
        $display("original.p.value = %0d", original.p.value);
        $display("deep.p.value     = %0d", deep.p.value);

    end

endmodule
```

### Expected Output

```text
Handle Copy:
original.data     = 200
handle_copy.data  = 200

Shallow Copy:
original.p.value = 75
shallow.p.value  = 75

Deep Copy:
original.p.value = 75
deep.p.value     = 100
```

**Key concepts:** class handles, handle copy, shallow copy, deep copy, nested objects, independent transaction objects.