# 016 — SV-016 — Queue

## Introduction

A **queue** in SystemVerilog is an ordered collection whose size can change dynamically during simulation. Queues are declared using `[$]` and are commonly used in verification environments to store transactions, stimulus, expected data, or pending operations.

### Queue Declaration

```systemverilog
int queue[$];
```

Here:

* `int` is the element type.
* `queue` is the queue variable.
* `[$]` indicates an unbounded queue.

### Important Queue Operations

| Operation           | Purpose                                |
| ------------------- | -------------------------------------- |
| `push_front(value)` | Adds an element at the beginning       |
| `push_back(value)`  | Adds an element at the end             |
| `pop_front()`       | Removes and returns the first element  |
| `pop_back()`        | Removes and returns the last element   |
| `size()`            | Returns the current number of elements |

### Operation Example

Starting with an empty queue:

```text
push_back(20)  → {20}
push_back(30)  → {20, 30}
push_front(10) → {10, 20, 30}

pop_front()    → returns 10 → {20, 30}
pop_back()     → returns 30 → {20}
```

`pop_front()` and `pop_back()` both **remove an element and return its value**, which makes queues useful for FIFO/LIFO-style verification operations.

## Verification Relevance

Queues are frequently used in verification to:

* Store generated transactions.
* Maintain expected results.
* Implement FIFO-like behavior.
* Pass stimulus between verification components.
* Compare received transactions against previously stored expected transactions.

## Key Takeaways

* `[$]` declares an unbounded queue.
* `push_front()` inserts at the beginning.
* `push_back()` inserts at the end.
* `pop_front()` removes and returns the first element.
* `pop_back()` removes and returns the last element.
* `size()` reports the current queue size.
* Queues are particularly useful for storing and managing verification transactions.
