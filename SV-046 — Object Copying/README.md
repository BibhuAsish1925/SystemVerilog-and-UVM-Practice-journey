## 046 — SV-046 — Object Copying

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


**Key concepts:** class handles, handle copy, shallow copy, deep copy, nested objects, independent transaction objects.
