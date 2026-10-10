
# Phase 1 — SystemVerilog Fundamentals ✅

## Overview
This phase introduces the fundamental building blocks of SystemVerilog, focusing on data types, type definitions, type conversion, and built-in system functions. These concepts form the foundation for writing readable, reusable, and reliable RTL and verification code.

## Topics Covered

### 1. Data Types and Type Operations

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-001 | Data Types ✅ | `bit`, `logic`, `reg`, `byte`, `shortint`, `int`, `longint`, `integer`, `time` |
| SV-002 | 2-State vs 4-State ✅ | `bit` vs `logic`, X/Z values and their behavior |
| SV-003 | Signed/Unsigned ✅ | `signed`, `unsigned`, sign extension, arithmetic behavior |
| SV-004 | Strings ✅ | Declaration, assignment, string methods, comparison, formatting |
| SV-005 | Parameters ✅ | `parameter`, `localparam`, parameterized values |
| SV-006 | Typedef ✅ | User-defined types, `typedef`, `typedef enum` |
| SV-007 | Enum ✅ | `enum`, `first`, `last`, `next`, `prev`, `name`, `num` |
| SV-008 | Struct ✅ | `struct`, packed structures, unpacked structures |
| SV-009 | Union ✅ | `union`, packed unions, shared storage |
| SV-010 | Type Casting ✅ | Static casting, `int'`, `logic'`, type conversion |
| SV-011 | `$cast` ✅ | Dynamic casting, safe casting, class handles |
| SV-012 | System Functions ✅ | `$bits`, `$size`, `$clog2`, `$left`, `$right`, `$high`, `$low` |

## Key Learning Areas

- **Data representation:** Understand SystemVerilog data types and the differences between 2-state and 4-state values.
- **Type behavior:** Learn signed and unsigned arithmetic, sign extension, and type conversion.
- **Custom types:** Create reusable definitions using `typedef`, `enum`, `struct`, and `union`.
- **String handling:** Perform common string operations and formatting.
- **Type safety:** Understand static casting and dynamic casting with `$cast`.
- **System functions:** Use built-in functions to inspect data widths, array dimensions, and ranges.

## Practical Work

Each topic is practiced through SystemVerilog code examples, with simulation in Vivado to observe language behavior and verify expected outputs.

## Learning Outcomes

After completing this phase, you should be able to:
- Select appropriate SystemVerilog data types.
- Explain X/Z behavior and signed/unsigned arithmetic.
- Define and use custom data types.
- Apply type casting and common system functions.
- Write and simulate basic SystemVerilog programs.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, expected outputs, and GitHub learning notes
