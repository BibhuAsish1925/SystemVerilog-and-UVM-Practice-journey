# 055 — SV-055 — Weighted Constraints

SystemVerilog provides the `dist` constraint to control the **relative probability** of randomized values.

### Basic Syntax

```systemverilog
data dist {
    value_or_range := weight
};
```

Two important operators are:

* `:=` — the weight is assigned to **each value** in the item or range.
* `:/` — the weight is **distributed across** all values in the item or range.

### `:=`

For:

```systemverilog
data dist {
    [1:3] := 2;
};
```

each value receives weight `2`:

```text
1 → 2
2 → 2
3 → 2
```

### `:/`

For:

```systemverilog
data dist {
    [1:3] :/ 3;
};
```

the total weight `3` is distributed across the three values:

```text
1 → 1
2 → 1
3 → 1
```

Therefore, `:=` and `:/` behave differently when applied to ranges.

### Example

```systemverilog
data dist {
    0       := 1,
    [1:3]   := 2,
    [4:6]   :/ 3
};
```

The resulting relative weights are:

```text
0 → 1
1 → 2
2 → 2
3 → 2
4 → 1
5 → 1
6 → 1
```

The solver uses these weights to influence the probability of selecting each value.

### Why it matters in verification

Weighted constraints are useful when some scenarios should occur more frequently than others. For example, common protocol operations can be given higher probability while less common operations remain possible.

The weights describe **relative probability**, not an exact occurrence count. A small number of randomizations may not reflect the expected statistical distribution.


**Key concepts:** `dist`, weighted randomization, `:=`, `:/`, range weighting, relative probability.
