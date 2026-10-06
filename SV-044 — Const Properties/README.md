# 044 — SV-044 — Const Properties

A **`const` class property** is a data member whose value cannot be modified after it has been initialized.

It is declared using the `const` keyword:

```systemverilog id="k6m2q8"
const int transaction_id;
```

A common approach is to initialize the property through the class constructor.

## 1. Const Property

Example:

```systemverilog id="p9v4x3"
class transaction;

    const int transaction_id;

    function new(int id);
        transaction_id = id;
    endfunction

endclass
```

The constructor initializes the property:

```systemverilog id="z7r2mc"
trans1 = new(101);
```

After initialization, the value cannot be reassigned.

## 2. Why Use Const Properties?

A const property is useful when a value should remain fixed throughout the lifetime of an object.

For example, a transaction identifier can be initialized once:

```text id="c4n8qp"
Object creation
      ↓
transaction_id = 101
      ↓
Value remains 101
```

This prevents accidental modification later in the verification flow.


### Key Concepts

| Concept                 | Meaning                                                  |
| ----------------------- | -------------------------------------------------------- |
| `const`                 | Prevents modification of a property after initialization |
| Const property          | Fixed data member of a class object                      |
| Constructor             | Common place to initialize a const property              |
| `new()`                 | Creates the object and provides the initial value        |
| Instance const property | Each object can have its own fixed value                 |

### Important Point

A `const` property is different from a `static` property:

```text id="v8m3qp"
const
  ↓
Each object can have its own value
  ↓
Value cannot be changed after initialization


static
  ↓
One shared value for the class
```

Const properties are useful when verification objects contain information that should remain **immutable after construction**.
