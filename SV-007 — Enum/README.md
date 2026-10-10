# 007 — SV-007 — Enum

## Concept

An `enum` (enumeration) defines a set of named values.

Instead of using unexplained numeric values:

```text
0 → IDLE
1 → START
2 → ACTIVE
3 → DONE
```

we can use meaningful names directly:

```systemverilog
state = ACTIVE;
```

This makes RTL and verification code easier to understand and debug.

## Enum Declaration

An enum can be declared using:

```systemverilog
typedef enum {
    IDLE,
    START,
    ACTIVE,
    DONE
} state_t;
```

Then a variable of this enum type can be declared:

```systemverilog
state_t state;
```

By default, enum values are assigned increasing values starting
from `0`.

Therefore:

```text
IDLE   → 0
START  → 1
ACTIVE → 2
DONE   → 3
```

## Enum Methods

SystemVerilog provides built-in methods for examining and navigating
enum values.

### `first()`

Returns the **first enum value**.

```systemverilog
state.first()
```

For the example:

```text
IDLE
```

### `last()`

Returns the **last enum value**.

```systemverilog
state.last()
```

For the example:

```text
DONE
```

### `next()`

Returns the **next enum value** relative to the current value.

If:

```text
state = ACTIVE
```

then:

```text
state.next() → DONE
```

### `prev()`

Returns the **previous enum value** relative to the current value.

If:

```text
state = ACTIVE
```

then:

```text
state.prev() → START
```

### `name()`

Returns the name of the current enum value as a string.

```systemverilog
state.name()
```

If:

```text
state = ACTIVE
```

then:

```text
state.name() → "ACTIVE"
```

This is particularly useful for readable debug messages.

### `num()`

Returns the total number of values in the enum.

For:

```text
IDLE, START, ACTIVE, DONE
```

the result is:

```text
4
```

## Complete Example

```systemverilog
module sv_007_enum;

    typedef enum {
        IDLE,
        START,
        ACTIVE,
        DONE
    } state_t;

    state_t state;

    initial begin
        state = ACTIVE;

        $display("Current = %s", state.name());
        $display("First   = %s", state.first().name());
        $display("Last    = %s", state.last().name());
        $display("Next    = %s", state.next().name());
        $display("Previous= %s", state.prev().name());
        $display("Number  = %0d", state.num());
    end

endmodule
```

## Expected Output

```text
Current = ACTIVE
First   = IDLE
Last    = DONE
Next    = DONE
Previous= START
Number  = 4
```

## Verification Relevance

Enums are useful for representing a fixed set of meaningful states,
such as:

- FSM states
- Protocol states
- Transaction states
- Testbench modes
- Driver/monitor states
- UVM-related state information

The enum methods are especially useful for writing readable debug
messages and navigating through defined states.

## Key Points to Remember

- `enum` defines a fixed set of named values.
- Enum values are assigned in declaration order by default.
- `first()` returns the first enum value.
- `last()` returns the last enum value.
- `next()` returns the next value.
- `prev()` returns the previous value.
- `name()` returns the current enum value as a string.
- `num()` returns the total number of enum values.
- Enums make FSM and verification code more readable than raw numbers.