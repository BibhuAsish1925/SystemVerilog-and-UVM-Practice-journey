
# Phase 2 — Arrays and Collections ✅

## Overview
This phase explores SystemVerilog array types and collection operations used to store, access, modify, and process multiple values. It covers fixed arrays, dynamic arrays, queues, associative arrays, and built-in array methods commonly used in testbench development and verification.

## Topics Covered

### 1. Array Types and Operations

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-013 | Fixed Arrays ✅ | 1D arrays, multidimensional arrays, initialization |
| SV-014 | Dynamic Arrays ✅ | `new[]`, resizing, `delete`, `size` |
| SV-015 | Dynamic Array Copying ✅ | `new[size](array)`, preserving elements |
| SV-016 | Queue ✅ | `[$]`, `push_front`, `push_back`, `pop_front`, `pop_back` |
| SV-017 | Queue Methods ✅ | `insert`, `delete`, `size`, indexing |
| SV-018 | Associative Arrays ✅ | Integer indexing, string indexing, sparse storage |
| SV-019 | Associative Array Methods ✅ | `first`, `last`, `next`, `prev`, `exists`, `num`, `delete` |
| SV-020 | Array Locator Methods ✅ | `find`, `find_index`, `find_first`, `find_last` |
| SV-021 | Array Ordering ✅ | `sort`, `rsort`, `reverse`, `shuffle` |
| SV-022 | Array Reduction ✅ | `sum`, `product`, `and`, `or`, `xor` |
| SV-023 | Array Iteration ✅ | `foreach`, iterator variables, array traversal |
| SV-024 | Assignment Patterns ✅ | `'{ }`, nested assignment patterns |

## Key Learning Areas

- **Array management:** Declare, initialize, access, and modify fixed and dynamic arrays.
- **Dynamic storage:** Resize arrays, preserve existing elements, and manage array memory.
- **Collection handling:** Use queues for ordered data and associative arrays for key-based, sparse storage.
- **Array processing:** Locate elements, reorder collections, and perform reduction operations.
- **Iteration:** Traverse array elements using `foreach` and iterator variables.
- **Data initialization:** Use assignment patterns to initialize arrays and nested collections efficiently.

## Practical Work

Each topic is practiced through runnable SystemVerilog examples. Vivado simulation is used to observe array operations, inspect outputs, and verify expected behavior.

## Learning Outcomes

After completing this phase, you should be able to:
- Choose suitable array and collection types for different requirements.
- Perform array resizing, copying, insertion, deletion, and indexing.
- Apply built-in locator, ordering, and reduction methods.
- Traverse and process collections efficiently.
- Initialize arrays using simple and nested assignment patterns.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
