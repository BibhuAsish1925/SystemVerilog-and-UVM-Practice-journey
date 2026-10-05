# 003 — SV-003 — Signed/Unsigned

## Concept

SystemVerilog values can be declared as either **signed** or
**unsigned**.

This affects how the same binary bits are interpreted during:

* Arithmetic
* Comparisons
* Assignments
* Size conversion
* Sign extension

### Signed

A signed value uses its **most significant bit (MSB)** as the sign bit.

```systemverilog
logic signed [7:0] value;
```

For an 8-bit signed value:

```text
00000101 → +5
11111011 → -5
```

### Unsigned

An unsigned value treats all bits as magnitude.

```systemverilog
logic [7:0] value;
```

Therefore:

```text
11111011 → 251
```

The same 8-bit pattern can therefore represent different numbers:

```text
Signed   → -5
Unsigned → 251
```

## Sign Extension

When a signed value is expanded to a larger width, the sign bit
is copied into the newly added upper bits.

Example:

```text
8-bit  -5:
11111011

16-bit after sign extension:
1111111111111011
```

The value remains `-5`.

For a positive signed value, the upper bits are filled with `0`.

```text
8-bit  +5:
00000101

16-bit:
0000000000000101
```

This preserves the original signed value.

## Arithmetic

Signedness affects arithmetic interpretation.

For example:

```text
8'b11111011
```

is:

```text
-5    → signed
251   → unsigned
```

Therefore arithmetic performed using these values can produce
different numerical results.

## Syntax

Signed declaration:

```systemverilog
logic signed [7:0] a;
```

Unsigned declaration:

```systemverilog
logic unsigned [7:0] b;
```

`unsigned` is also the default for `logic` unless `signed` is specified.

## Verification Relevance

Signedness is important in verification because transaction fields,
counters, arithmetic calculations, comparisons, and reference models
may contain both positive and negative values.

Incorrect signedness can cause:

* Unexpected arithmetic results
* Incorrect comparisons
* Incorrect sign extension
* Scoreboard mismatches
* Incorrect reference-model calculations

## Key Points to Remember

* `signed` interprets the MSB as a sign bit.
* `unsigned` treats all bits as magnitude.
* `logic` is unsigned by default unless declared `signed`.
* The same binary pattern can represent different signed and
  unsigned values.
* Sign extension copies the signed value's MSB into the new bits.
* Zero extension fills added upper bits with `0`.
* Always check signedness and width when performing arithmetic.
