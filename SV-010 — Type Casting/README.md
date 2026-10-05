# 010 — SV-010 — Type Casting

## Type Casting

Type casting is the process of converting a value from one SystemVerilog data type to another.

SystemVerilog supports **static casting** using the target type followed by an apostrophe:

```systemverilog
int'(expression)
logic'(expression)
```

The conversion happens at the point where the expression is evaluated.

### Static Casting

The general syntax is:

```systemverilog
target_type'(expression)
```

For example:

```systemverilog
int_value = int'(data);
```

This explicitly converts `data` to an `int` before assigning it.

Another example:

```systemverilog
logic_value = logic'(1'b1);
```

Here, the expression is explicitly converted to the `logic` type.

### `int'`

`int'` converts an expression to the SystemVerilog `int` type.

```systemverilog
int_value = int'(data);
```

For example, an 8-bit value:

```text
8'hA5
```

has the unsigned decimal value:

```text
165
```

when converted to `int`.

### `logic'`

`logic'` explicitly converts an expression to the `logic` type.

```systemverilog
logic_value = logic'(1'b1);
```

The result is a 4-state `logic` value.

### Type Conversion and Width

Casting can also be used when converting between expressions of different widths.

```systemverilog
extended_data = int'(data);
```

The 8-bit value is converted to `int` and then assigned to the 16-bit destination.

For:

```text
data = 8'hA5
```

the resulting 16-bit value is:

```text
00A5
```

### Why Type Casting Matters in Verification

Explicit casting is useful when:

* Converting transaction fields between types
* Controlling signed/unsigned interpretation
* Handling different signal widths
* Passing values to functions/tasks with specific types
* Avoiding unintended implicit conversions
* Making testbench code easier to understand

The important syntax to remember is:

```systemverilog
target_type'(expression)
```

## Expected Output

```text id="j7b8pq"
Original data    = a5
int'(data)       = 165
logic'(1'b1)     = 1
Extended data    = 00a5
```

## Key Syntax

```systemverilog
int'(expression)
logic'(expression)
```

General form:

```systemverilog
target_type'(expression)
```

For example:

```systemverilog
int_value = int'(data);
logic_value = logic'(1'b1);
```

Static casting gives explicit control over how a value is interpreted or converted instead of relying only on implicit type conversion.
