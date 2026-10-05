# 012 — SV-012 — System Functions

SystemVerilog provides several built-in system functions for determining the **size, width, and boundaries** of data objects and arrays.

The important functions in this topic are:

* `$bits`
* `$size`
* `$clog2`
* `$left`
* `$right`
* `$high`
* `$low`

These functions are particularly useful in verification because they reduce hard-coded widths and array boundaries.

## `$bits`

`$bits` returns the number of bits required to represent a data type or expression.

```systemverilog
$bits(data)
```

For example:

```systemverilog
logic [7:0] data;
```

has 8 bits:

```text
$bits(data) = 8
```

For:

```systemverilog
logic [15:4] range_data;
```

there are 12 bits:

```text
15 - 4 + 1 = 12
```

So:

```text
$bits(range_data) = 12
```

## `$size`

`$size` returns the number of elements in an array.

For:

```systemverilog
int array [0:4];
```

there are five elements:

```text
0, 1, 2, 3, 4
```

Therefore:

```text
$size(array) = 5
```

## `$clog2`

`$clog2` returns the **ceiling of log base 2** of its argument.

```systemverilog
$clog2(10)
```

Since:

```text
2^3 = 8
2^4 = 16
```

the smallest power of two that is at least 10 is 16.

Therefore:

```text
$clog2(10) = 4
```

It is commonly used to calculate address widths and counter widths.

For example:

```systemverilog
localparam int ADDR_WIDTH = $clog2(DEPTH);
```

## `$left` and `$right`

These functions return the leftmost and rightmost index of an array or packed/unpacked dimension.

For:

```systemverilog
int array [0:4];
```

the results are:

```text
$left(array)  = 0
$right(array) = 4
```

The result depends on the declared direction of the dimension.

For example, a descending range would behave differently:

```systemverilog
logic [7:0] data;
```

Here:

```text
$left(data)  = 7
$right(data) = 0
```

## `$high` and `$low`

`$high` returns the highest index of a dimension.

`$low` returns the lowest index of a dimension.

For:

```systemverilog
int array [0:4];
```

the results are:

```text
$high(array) = 4
$low(array)  = 0
```

Unlike `$left` and `$right`, `$high` and `$low` describe the numerical highest and lowest index.

For example:

```systemverilog
logic [7:0] data;
```

has:

```text
$left(data)  = 7
$right(data) = 0
$high(data)  = 7
$low(data)   = 0
```

## `$left` / `$right` vs `$high` / `$low`

| Function | Meaning                   |
| -------- | ------------------------- |
| `$left`  | Leftmost declared index   |
| `$right` | Rightmost declared index  |
| `$high`  | Numerically highest index |
| `$low`   | Numerically lowest index  |

This distinction becomes important when working with both ascending and descending ranges.

## Why These Functions Matter in Verification

These system functions are useful for:

* Automatically determining signal widths
* Calculating address widths
* Handling arrays without hard-coded sizes
* Writing reusable testbench code
* Iterating through different array ranges
* Making verification code parameterized and scalable

## Key Syntax

```systemverilog
$bits(expression)
$size(array)
$clog2(value)
$left(array)
$right(array)
$high(array)
$low(array)
```

The main idea is to use these functions to **query dimensions and calculate sizes dynamically instead of hard-coding them**.
