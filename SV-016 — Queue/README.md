\# 016 — SV-016 — Queue



\## Introduction



A \*\*queue\*\* in SystemVerilog is an ordered collection whose size can change dynamically during simulation. Queues are declared using `\[$]` and are commonly used in verification environments to store transactions, stimulus, expected data, or pending operations.



\### Queue Declaration



```systemverilog

int queue\[$];

```



Here:



\* `int` is the element type.

\* `queue` is the queue variable.

\* `\[$]` indicates an unbounded queue.



\### Important Queue Operations



| Operation           | Purpose                                |

| ------------------- | -------------------------------------- |

| `push\_front(value)` | Adds an element at the beginning       |

| `push\_back(value)`  | Adds an element at the end             |

| `pop\_front()`       | Removes and returns the first element  |

| `pop\_back()`        | Removes and returns the last element   |

| `size()`            | Returns the current number of elements |



\### Operation Example



Starting with an empty queue:



```text

push\_back(20)  → {20}

push\_back(30)  → {20, 30}

push\_front(10) → {10, 20, 30}



pop\_front()    → returns 10 → {20, 30}

pop\_back()     → returns 30 → {20}

```



`pop\_front()` and `pop\_back()` both \*\*remove an element and return its value\*\*, which makes queues useful for FIFO/LIFO-style verification operations.



\## Verification Relevance



Queues are frequently used in verification to:



\* Store generated transactions.

\* Maintain expected results.

\* Implement FIFO-like behavior.

\* Pass stimulus between verification components.

\* Compare received transactions against previously stored expected transactions.



\## Expected Output



```text

After push operations:

queue = '{10, 20, 30}



pop\_front = 10

queue     = '{20, 30}



pop\_back  = 30

queue     = '{20}



After adding again:

queue = '{5, 20, 40}

size  = 3

```



\## Key Takeaways



\* `\[$]` declares an unbounded queue.

\* `push\_front()` inserts at the beginning.

\* `push\_back()` inserts at the end.

\* `pop\_front()` removes and returns the first element.

\* `pop\_back()` removes and returns the last element.

\* `size()` reports the current queue size.

\* Queues are particularly useful for storing and managing verification transactions.



