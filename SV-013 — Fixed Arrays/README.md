# 013 — SV-013 — Fixed Arrays

## Fixed Arrays

A fixed array has a size that is determined at compile time and remains constant during simulation.

SystemVerilog supports one-dimensional and multidimensional fixed arrays.

Fixed arrays are commonly used in verification for:

* Test data
* Expected results
* Lookup tables
* Memory models
* Groups of related values
* Transaction data

## 1D Fixed Array

A one-dimensional fixed array uses one index.

```systemverilog
int numbers [5];
```

This creates five elements:

```text
numbers[0]
numbers[1]
numbers[2]
numbers[3]
numbers[4]
```

The size is fixed at `5`.

### Initialization

A fixed array can be initialized using an array assignment pattern:

```systemverilog
numbers = '{10, 20, 30, 40, 50};
```

The values are assigned to the array elements in order.

## Multidimensional Fixed Array

A multidimensional array uses multiple indices.

```systemverilog
int matrix [2][3];
```

This creates:

* 2 rows
* 3 columns
* 6 total elements

The elements are accessed using two indices:

```systemverilog
matrix[0][0]
matrix[0][1]
matrix[0][2]

matrix[1][0]
matrix[1][1]
matrix[1][2]
```

It can be initialized using nested assignment patterns:

```systemverilog
matrix = '{
    '{1, 2, 3},
    '{4, 5, 6}
};
```

## `foreach`

The `foreach` loop provides a convenient way to iterate through array elements.

For a 1D array:

```systemverilog
foreach (numbers[i])
    $display("%0d", numbers[i]);
```

For a 2D array:

```systemverilog
foreach (matrix[i, j])
    $display("%0d", matrix[i][j]);
```

The loop variables automatically represent the valid indices of the array.

## `$size`

`$size` can be used to determine the number of elements in an array.

For a 1D array:

```systemverilog
$size(numbers)
```

returns:

```text
5
```

For a multidimensional array, the dimension can be specified:

```systemverilog
$size(matrix, 1)
```

returns the size of the first dimension:

```text
2
```

and:

```systemverilog
$size(matrix, 2)
```

returns the size of the second dimension:

```text
3
```

## Why Fixed Arrays Matter in Verification

Fixed arrays are useful when the required size is known beforehand.

Examples include:

```text
Expected data:     10, 20, 30, 40, 50
Memory model:      2D/3D storage
Packet data:       Fixed number of bytes
Test vectors:      Predefined input values
Lookup tables:     Constant-size reference data
```

They provide predictable storage and straightforward indexing.

## Key Syntax

### 1D Fixed Array

```systemverilog
data_type array_name [size];
```

Example:

```systemverilog
int numbers [5];
```

### 2D Fixed Array

```systemverilog
data_type array_name [rows][columns];
```

Example:

```systemverilog
int matrix [2][3];
```

### Array Initialization

```systemverilog
numbers = '{10, 20, 30, 40, 50};
```

### Multidimensional Initialization

```systemverilog
matrix = '{
    '{1, 2, 3},
    '{4, 5, 6}
};
```

### Iteration

```systemverilog
foreach (array[i])
    ...
```

For multidimensional arrays:

```systemverilog
foreach (array[i, j])
    ...
```

### Important Point

A **fixed array has a compile-time-defined size**. Its number of elements does not change during simulation.

This is the foundation for the next SystemVerilog array types, where we will move from fixed-size storage to more flexible collections.
