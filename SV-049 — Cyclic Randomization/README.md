# 049 — SV-049 — Cyclic Randomization

SystemVerilog provides the `randc` keyword for **cyclic randomization**.

A `randc` variable generates its possible values in a randomized order, but it does not repeat a value until all possible values in the current cycle have been used.

### `randc` Syntax

```systemverilog
randc logic [1:0] data;
```

A 2-bit variable has four possible values:

```text
0, 1, 2, 3
```

A possible cyclic sequence is:

```text
2, 0, 3, 1
```

After all four values have been generated, a new cycle begins and the values can appear again in another randomized order.

### `rand` vs `randc`

| Feature                            | `rand`                 | `randc`                           |
| ---------------------------------- | ---------------------- | --------------------------------- |
| Random values                      | Yes                    | Yes                               |
| Cyclic behavior                    | No                     | Yes                               |
| Prevents repetition within a cycle | No                     | Yes                               |
| Useful for                         | General random testing | Ensuring all values are exercised |

### Why it matters in verification

`randc` is useful when verification needs to exercise every possible value before repeating values. This can help provide systematic coverage of small finite value spaces such as opcodes, modes, states, or small configuration fields.

Each group of four successful randomizations contains all four possible values exactly once.

**Key concepts:** `randc`, cyclic randomization, randomized ordering, no repetition within a cycle, value-space coverage.
