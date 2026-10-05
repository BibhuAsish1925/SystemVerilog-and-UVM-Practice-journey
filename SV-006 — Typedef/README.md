# 006 — SV-006 — Typedef

## Concept

`typedef` is used to create a **user-defined name for an existing
data type**.

Instead of repeatedly writing a complex type, we can define it once
and use a shorter, meaningful name.

## Basic `typedef`

Example:

```systemverilog id="p0w2b7"
typedef logic [7:0] data_t;
```

Now `data_t` represents:

```text id="uyy3p6"
logic [7:0]
```

Variables can be declared using the new type:

```systemverilog id="4sm8qf"
data_t data;
```

This improves readability and makes the type easier to reuse.

## User-Defined Types

Multiple types can be defined using `typedef`.

```systemverilog id="t7kz7v"
typedef logic [7:0] data_t;
typedef int unsigned count_t;
```

These names can then be used throughout the code:

```systemverilog id="9f3z5q"
data_t  data;
count_t count;
```

The underlying data types remain `logic [7:0]` and
`int unsigned`, but the new names describe their purpose more clearly.

## `typedef enum`

`typedef enum` creates a named enumeration type.

Example:

```systemverilog id="v4j3z6"
typedef enum {
    IDLE,
    START,
    DONE
} state_t;
```

Now `state_t` is a user-defined enum type.

A variable can be declared:

```systemverilog id="3c4w2p"
state_t state;
```

and assigned one of its named values:

```systemverilog id="l5o1ry"
state = IDLE;
state = START;
state = DONE;
```

Enums are much more readable than representing states with raw
numbers such as `0`, `1`, and `2`.

## Enum `.name()`

An enum variable can use the `.name()` method to return its
enumeration name as a string.

Example:

```systemverilog id="5d4qtc"
$display("%s", state.name());
```

For `state = START`, the output is:

```text id="b4tv7m"
START
```

## Verification Relevance

`typedef` is heavily used in SystemVerilog verification to create
meaningful and reusable types for:

* Transaction fields
* Protocol data
* Counters
* Configuration values
* FSM/protocol states
* Testbench states
* UVM sequence items and related types

`typedef enum` is particularly useful when verification code needs
to represent a finite set of meaningful states.

## Key Points to Remember

* `typedef` creates a new name for an existing type.
* User-defined types improve readability and reuse.
* The `_t` suffix is commonly used for type names.
* `typedef enum` creates a named enumeration type.
* Enum values provide readable symbolic names.
* `.name()` returns the current enum value as a string.
* Enums are useful for FSM and protocol state representation.
