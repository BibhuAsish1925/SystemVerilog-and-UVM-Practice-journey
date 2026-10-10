
# Phase 5 — Constrained Randomization ✅

## Overview
This phase explores SystemVerilog constrained randomization for generating valid and varied test stimulus. It covers random variables, constraint blocks, solver behavior, callbacks, distributions, conditional rules, and constraint reuse—important concepts for building effective verification testbenches.

## Topics Covered

### 1. Randomization Fundamentals

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-048 | Basic Randomization ✅ | `rand`, `randomize()` |
| SV-049 | Cyclic Randomization ✅ | `randc` |
| SV-050 | Basic Constraints ✅ | Constraint blocks, relational constraints |
| SV-051 | Randomization Failure ✅ | `randomize()` return value |
| SV-052 | `pre_randomize()` ✅ | Pre-randomization callback |
| SV-053 | `post_randomize()` ✅ | Post-randomization callback |

### 2. Constraint Rules and Solver Control

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-054 | Inline Constraints ✅ | `randomize() with { }` |
| SV-055 | Weighted Constraints ✅ | `dist`, `:=`, `:/` |
| SV-056 | `inside` ✅ | Value sets, ranges |
| SV-057 | Implication ✅ | `->` |
| SV-058 | `solve...before` ✅ | Constraint solving order |
| SV-059 | `rand_mode()` ✅ | Enable/disable random variables |
| SV-060 | `constraint_mode()` ✅ | Enable/disable constraints |
| SV-061 | Conditional Constraints ✅ | `if/else` inside constraints |

### 3. Array and Advanced Constraints

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-062 | `foreach` Constraints ✅ | Array element constraints |
| SV-063 | Unique Constraints ✅ | `unique { }` |
| SV-064 | Array Constraints ✅ | Dynamic arrays, queues, array relationships |
| SV-065 | Constraint Inheritance ✅ | Base/derived class constraints |
| SV-066 | Constraint Override ✅ | Constraint replacement, constraint extension |
| SV-067 | Soft Constraints ✅ | `soft`, default constraints |
| SV-068 | Constraint Layering ✅ | Class constraints, inline constraints |

## Key Learning Areas

- **Stimulus generation:** Use `rand` and `randc` to generate randomized values.
- **Constraint definition:** Define legal value ranges and relationships between variables.
- **Solver control:** Handle randomization failures and control variable or constraint activation.
- **Distribution and conditions:** Apply weighted distributions, `inside`, implication, and conditional constraints.
- **Array randomization:** Constrain array elements, uniqueness, sizes, and relationships.
- **Constraint reuse:** Organize constraints through inheritance, extension, soft constraints, and inline rules.

## Practical Work

Each topic is practiced through runnable SystemVerilog examples and Vivado simulation to inspect randomized results, validate constraints, and understand how different rules affect generated stimulus.

## Learning Outcomes

After completing this phase, you should be able to:
- Generate randomized and cyclic test data.
- Define and combine constraints for valid stimulus.
- Detect and handle randomization failures.
- Control random variables and constraints.
- Apply constraints to arrays and inherited classes.
- Build reusable constraint models for verification scenarios.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
