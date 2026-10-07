# 062 — SV-062 — `foreach` Constraints

## Concept

SystemVerilog allows `foreach` to be used inside a constraint block to apply a constraint to **each element of an array**.

Syntax:

```systemverilog
constraint name {
    foreach (array[i])
        array[i] constraint_expression;
}
```

For example:

```systemverilog
foreach (data[i])
    data[i] inside {[10:50]};
```

applies the same range constraint to every element of `data`.

### Important points

* `foreach` iterates through array elements during constraint solving.
* It avoids writing separate constraints for every array index.
* It is useful for fixed, dynamic, and other supported array types.
* The array elements can be randomized when declared as `rand`.
* Each element must satisfy the specified constraint.

## Verification Relevance

`foreach` constraints are important when verification transactions contain arrays such as:

* burst data
* packet payloads
* register values
* byte arrays
* memory data

For example:

```systemverilog
foreach (data[i])
    data[i] inside {[10:50]};
```

allows the same constraint to be applied to every randomized element without manually specifying each index.

## Vivado

Use this as a **Simulation Source** with no DUT. Run **Behavioral Simulation** and observe the randomized array elements in the simulator console.
