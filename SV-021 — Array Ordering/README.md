\# 021 — SV-021 — Array Ordering



\## Introduction



SystemVerilog provides built-in methods for rearranging elements of an unpacked array.



The four important array ordering methods are:



| Method      | Purpose                            |

| ----------- | ---------------------------------- |

| `sort()`    | Sorts elements in ascending order  |

| `rsort()`   | Sorts elements in descending order |

| `reverse()` | Reverses the current element order |

| `shuffle()` | Randomly rearranges the elements   |



These methods are useful in verification when test data or transactions need to be sorted, reversed, or randomly reordered.



\## `sort()`



`sort()` arranges the elements in ascending order.



```systemverilog id="j6q2mv"

data.sort();

```



Example:



```text id="c4x8nb"

{40, 10, 60, 20, 50, 30}

```



becomes:



```text id="t7k3pz"

{10, 20, 30, 40, 50, 60}

```



\## `rsort()`



`rsort()` arranges the elements in descending order.



```systemverilog id="v9m1dk"

data.rsort();

```



Result:



```text id="z5q8hw"

{60, 50, 40, 30, 20, 10}

```



\## `reverse()`



`reverse()` reverses the current ordering of the elements.



```systemverilog id="r3p7fx"

data.reverse();

```



For example:



```text id="0d9wqa"

{60, 50, 40, 30, 20, 10}

```



becomes:



```text id="n8k2mc"

{10, 20, 30, 40, 50, 60}

```



It does \*\*not\*\* sort the array; it simply reverses its current order.



\## `shuffle()`



`shuffle()` randomly rearranges the elements:



```systemverilog id="h4v6sy"

data.shuffle();

```



The exact result can differ between simulation runs.



For example:



```text id="b1x5qk"

{30, 60, 10, 50, 20, 40}

```



The elements remain the same, but their order changes.



\## Verification Relevance



Array ordering methods are useful for:



\* Sorting expected transaction data.

\* Organizing test data.

\* Reversing transaction sequences.

\* Randomizing the order of stimulus.

\* Preparing arrays for comparison.

\* Creating varied transaction sequences during verification.



The `shuffle()` result is intentionally not fixed because it randomly rearranges the elements on each simulation run.



\## Key Takeaways



\* `sort()` → ascending order.

\* `rsort()` → descending order.

\* `reverse()` → reverses the current order.

\* `shuffle()` → randomly rearranges elements.

\* These methods modify the array directly.

\* `shuffle()` can produce a different ordering on different simulation runs.

\* Array ordering methods are useful for efficient stimulus and transaction manipulation in verification.



