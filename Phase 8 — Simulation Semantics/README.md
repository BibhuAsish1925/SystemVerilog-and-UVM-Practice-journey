
# Phase 8 — Simulation Semantics ✅

## Overview
This phase explores how SystemVerilog code executes during simulation. It covers blocking and nonblocking assignments, simulation time, event controls, delta cycles, event scheduling regions, and race conditions. Understanding these concepts is essential for writing predictable RTL and reliable verification testbenches.

## Topics Covered

### 1. Assignments and Simulation Timing

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-089 | Assignments ✅ | Blocking `=`, nonblocking `<=` |
| SV-090 | Simulation Time ✅ | `#delay`, `time` |
| SV-091 | Event Control ✅ | `@`, `wait`, event expressions |
| SV-092 | Delta Cycles ✅ | Zero-time simulation progression |

### 2. Event Scheduling and Race Conditions

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-093 | Event Regions ✅ | Preponed, Active, Inactive, NBA, Observed, Reactive, Postponed |
| SV-094 | Race Conditions ✅ | DUT/driver/monitor race examples |
| SV-095 | Race Avoidance ✅ | Clocking blocks, synchronization, NBA |

## Key Learning Areas

- **Assignment behavior:** Understand how blocking and nonblocking assignments update values.
- **Simulation timing:** Use delays, time variables, and event controls to coordinate execution.
- **Delta cycles:** Understand how simulation progresses through zero-time scheduling steps.
- **Event scheduling:** Identify the major SystemVerilog event regions and their roles.
- **Race conditions:** Recognize timing conflicts between the DUT, driver, and monitor.
- **Race prevention:** Apply nonblocking assignments, clocking blocks, and synchronization techniques.

## Practical Work

Each topic is practiced through runnable SystemVerilog examples and Vivado simulation to observe assignment timing, event scheduling, and race conditions.

## Learning Outcomes

After completing this phase, you should be able to:
- Explain blocking and nonblocking assignment behavior.
- Understand simulation time and delta-cycle progression.
- Describe the major event scheduling regions.
- Identify race conditions in RTL and testbenches.
- Apply appropriate techniques to make simulation behavior predictable.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
