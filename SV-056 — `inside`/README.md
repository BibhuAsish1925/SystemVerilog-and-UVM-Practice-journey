# 056 — SV-056 — `inside`

The SystemVerilog `inside` operator checks whether a value belongs to a specified **set of values or ranges**.

It is particularly useful inside constraints for defining the legal values of a randomized variable.

### Basic Syntax

For individual values:

```systemverilog id="h0a6sd"
data inside {5, 10, 15}
```

For ranges:

```systemverilog id="j6w3p2"
data inside {[10:20]}
```

Multiple values and ranges can be combined:

```systemverilog id="m4jv8c"
data inside {5, 10, [20:25], [40:45]}
```

This allows `data` to take only values from the specified set.

### Value Sets

Individual values can be listed directly:

```systemverilog id="q3c9r5"
data inside {5, 10, 20}
```

Valid values are:

```text
5, 10, 20
```

### Ranges

A range is specified using:

```systemverilog id="k7h2ws"
[lower:upper]
```

For example:

```systemverilog id="n8m5qa"
data inside {[20:25]}
```

allows:

```text
20, 21, 22, 23, 24, 25
```

### Why it matters in verification

`inside` provides a compact and readable way to define legal transaction values. It is useful when a protocol or design allows only specific values or groups of valid ranges.


**Key concepts:** `inside`, value sets, ranges, legal value selection, constrained randomization.
