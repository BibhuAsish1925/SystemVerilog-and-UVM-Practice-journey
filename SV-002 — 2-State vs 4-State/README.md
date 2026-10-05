# 002 — SV-002 — 2-State vs 4-State

## Concept

SystemVerilog data types can be broadly classified as **2-state**
or **4-state** types.

### 2-State Types

A 2-state type can represent only:

```text
0
1
```

Example:

```systemverilog
bit signal;
```

`bit` does not retain `X` or `Z`.

### 4-State Types

A 4-state type can represent:

```text
0
1
X
Z
```

Example:

```systemverilog
logic signal;
```

Here:

* `0` → logic low
* `1` → logic high
* `X` → unknown/uninitialized/conflicting value
* `Z` → high-impedance state

### `bit` vs `logic`

| Type    | States             | Typical Use                    |
| ------- | ------------------ | ------------------------------ |
| `bit`   | `0`, `1`           | 2-state verification variables |
| `logic` | `0`, `1`, `X`, `Z` | RTL and verification signals   |

When an `X` or `Z` value is assigned to a `bit`, it cannot retain
that state. The value is converted to a valid 2-state value.

A `logic` variable preserves the `X` or `Z` value.

## Why X/Z Matter

`X` can indicate situations such as:

* An uninitialized signal
* Multiple conflicting drivers
* Unknown hardware state
* A reset or initialization problem

`Z` commonly represents:

* High-impedance
* A disconnected/tri-stated signal
* Tri-state bus behavior

Therefore, 4-state simulation can expose problems that may be hidden
when using only 2-state variables.

## Verification Relevance

Understanding 2-state vs 4-state behavior is important when writing
testbenches, monitors, scoreboards, assertions, and UVM components.

Using `logic` where X/Z behavior matters allows the verification
environment to detect unknown or high-impedance conditions instead of
silently losing that information.

## Key Points to Remember

* `bit` → 2-state: `0/1`.
* `logic` → 4-state: `0/1/X/Z`.
* `X` represents an unknown state.
* `Z` represents high impedance.
* `bit` cannot retain `X` or `Z`.
* `logic` preserves `X` and `Z`.
* 4-state simulation is useful for finding initialization and
  connectivity problems.
