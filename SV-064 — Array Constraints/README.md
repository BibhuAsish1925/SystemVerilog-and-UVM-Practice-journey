# 064 — SV-064 — Array Constraints

## Concept

SystemVerilog constraints can control the **size and elements of arrays** and can also define relationships between different arrays.

For a dynamic array, its size can be constrained using:

```systemverilog id="k8m3qn"
data.size() == 4;
```

Array elements can be constrained with `foreach`:

```systemverilog id="d2x7pv"
foreach (data[i])
    data[i] inside {[10:50]};
```

Relationships between corresponding elements of two arrays can also be defined:

```systemverilog id="r5c9jw"
foreach (data[i])
    expected[i] == data[i] + 100;
```

This means every `expected[i]` is calculated from the corresponding `data[i]`.

### Important points

* Dynamic-array size can be constrained using `size()`.
* `foreach` applies constraints to each array element.
* Multiple arrays can be constrained together.
* Array relationships can be expressed using the same index.
* All constraints must be satisfied during `randomize()`.
* In this Vivado/XSim example, dynamic arrays are used to demonstrate the concept in a form that XSim can successfully solve.


## Verification Relevance

Array constraints are useful when verification transactions contain collections of related values such as:

* burst data
* packet payloads
* expected results
* address/data sequences
* memory values

For example:

```systemverilog id="w6v0tc"
foreach (data[i])
    expected[i] == data[i] + 100;
```

allows the verification environment to generate `expected` values automatically from the randomized `data` values.

This is useful for creating structured and self-consistent randomized transactions.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and verify the dynamic-array sizes, value ranges, and relationship between `data` and `expected` in the simulator console.
