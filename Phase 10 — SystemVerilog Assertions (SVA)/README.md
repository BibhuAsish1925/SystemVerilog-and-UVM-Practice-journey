
# Phase 10 — SystemVerilog Assertions (SVA) ✅

## Overview
This phase introduces SystemVerilog Assertions (SVA) for checking design behavior over time. It covers immediate and concurrent assertions, properties, sequences, temporal operators, and protocol-level checks. These concepts help detect functional errors and verify timing and handshake requirements.

## Topics Covered

### 1. Assertion Fundamentals

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-111 | Immediate Assertions ✅ | `assert(expression)` |
| SV-112 | Immediate Assert/Else ✅ | `assert`, `else`, `$error`, `$fatal` |
| SV-113 | Concurrent Assertions ✅ | `assert property` |
| SV-114 | Properties ✅ | `property...endproperty` |
| SV-115 | Sequences ✅ | `sequence...endsequence` |

### 2. Temporal Logic and Operators

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-116 | Implication ✅ | `\|->`, `\|=>` |
| SV-117 | Delay Operators ✅ | `##`, cycle delays |
| SV-118 | Repetition ✅ | `[*]`, `[+]`, `[->]` |
| SV-119 | Boolean Operators ✅ | `and`, `or`, `intersect` |
| SV-120 | Temporal Operators ✅ | `throughout`, `within`, `until` |
| SV-121 | SVA System Functions ✅ | `$past`, `$rose`, `$fell`, `$stable`, `$changed` |
| SV-122 | `disable iff` ✅ | Reset/disable conditions |

### 3. Assertion Control and Protocol Checking

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-123 | Assertion Intent ✅ | `assert property`, `assume property`, `cover property` |
| SV-124 | `bind` ✅ | Attach assertions externally to DUT |
| SV-125 | Protocol Assertions ✅ | Valid/ready, handshake, FIFO properties |

## Key Learning Areas

- **Assertion fundamentals:** Write immediate and concurrent assertions to check design behavior.
- **Temporal checking:** Define properties and sequences that describe behavior across clock cycles.
- **Operator usage:** Apply implication, delay, repetition, Boolean, and temporal operators.
- **Signal history:** Use sampled-value functions to check transitions and stability.
- **Assertion control:** Disable checks during reset and distinguish assertions, assumptions, and coverage properties.
- **Protocol verification:** Check handshake rules, valid/ready behavior, and FIFO requirements.

## Practical Work

Each topic is practiced through SystemVerilog assertion examples and Vivado simulation to observe successful checks, assertion failures, temporal behavior, and protocol violations.

## Learning Outcomes

After completing this phase, you should be able to:
- Write immediate and concurrent assertions.
- Define reusable properties and sequences.
- Express cycle-based timing requirements.
- Check signal history, stability, and transitions.
- Apply assertions to protocol and FIFO verification.
- Interpret assertion failures to identify design issues.

## Tools
- **Language:** SystemVerilog Assertions (SVA)
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
