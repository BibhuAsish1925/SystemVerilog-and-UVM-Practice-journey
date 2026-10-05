# 020 — SV-020 — Array Locator Methods

## Introduction

SystemVerilog array locator methods search an array using a specified condition. They provide a concise alternative to manually iterating through an array with a loop.

The main methods covered here are:

| Method         | Purpose                                  |
| -------------- | ---------------------------------------- |
| `find()`       | Returns all matching elements            |
| `find_index()` | Returns indexes of all matching elements |
| `find_first()` | Returns the first matching element       |
| `find_last()`  | Returns the last matching element        |

The search condition is specified using a `with` clause.

## `find()`

`find()` returns a queue containing **all elements** that satisfy the condition.

```systemverilog id="a6m2qk"
found = data.find(x) with (x >= 30);
```

For:

```text
{10, 25, 30, 45, 50, 65}
```

the result is:

```text
{30, 45, 50, 65}
```

## `find_index()`

`find_index()` returns a queue containing the **indexes** of all matching elements.

```systemverilog id="p8v4nd"
indexes = data.find_index(x) with (x >= 30);
```

The matching indexes are:

```text
{2, 3, 4, 5}
```

## `find_first()`

`find_first()` returns the **first element** that satisfies the condition.

```systemverilog id="r3k7wx"
first_value = data.find_first(x) with (x >= 30);
```

Result:

```text
30
```

## `find_last()`

`find_last()` returns the **last element** that satisfies the condition.

```systemverilog id="m9c2hf"
last_value = data.find_last(x) with (x >= 30);
```

Result:

```text
65
```

## The `with` Clause

The expression inside `with` defines the search condition:

```systemverilog id="q5t8az"
data.find(x) with (x >= 30);
```

Here, `x` represents each array element being examined.

Other conditions can also be used:

```systemverilog id="v1n6bs"
data.find(x) with (x == 50);
data.find(x) with (x < 30);
data.find(x) with ((x % 2) == 0);
```

## Verification Relevance

Array locator methods are useful in verification for:

* Searching transaction collections.
* Finding expected values.
* Locating matching data.
* Checking whether specific conditions are satisfied.
* Quickly identifying the first or last matching transaction.
* Reducing manual search loops in testbench code.

## Key Takeaways

* `find()` returns a queue of **matching values**.
* `find_index()` returns a queue of **matching indexes**.
* `find_first()` returns the **first matching value**.
* `find_last()` returns the **last matching value**.
* The `with` clause defines the search condition.
* Array locator methods make verification code more concise when searching transactions, expected data, or other collections.
