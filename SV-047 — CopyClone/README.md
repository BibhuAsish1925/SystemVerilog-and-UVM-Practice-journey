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

| Method    | Purpose                                 |
| --------- | --------------------------------------- |
| `copy()`  | Copies data into an existing object     |
| `clone()` | Creates and returns a new copied object |

The actual copying behavior is user-defined. If a class contains nested class handles, the `copy()` implementation must explicitly create nested objects when a **deep copy** is required.

### Why it matters in verification

Transaction objects are frequently passed between verification components. User-defined `copy()` and `clone()` methods allow a testbench to create independent transaction objects without accidentally modifying the original transaction.

**Key concepts:** user-defined `copy()`, user-defined `clone()`, existing destination object, new cloned object, independent transaction objects, verification transaction handling.
