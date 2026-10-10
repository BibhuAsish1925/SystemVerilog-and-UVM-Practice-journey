
# Phase 6 — Concurrent Processes & Synchronization ✅

## Overview
This phase explores concurrent execution and process synchronization in SystemVerilog. It covers parallel process control, event-based coordination, process management, and inter-process communication mechanisms such as mailboxes and semaphores. These concepts are essential for coordinating testbench activities and managing concurrent verification processes.

## Topics Covered

### 1. Parallel Process Control

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-069 | `fork...join` ✅ | Parallel processes |
| SV-070 | `fork...join_any` ✅ | Continue after the first process finishes |
| SV-071 | `fork...join_none` ✅ | Background processes |
| SV-072 | `wait fork` ✅ | Wait for spawned processes |
| SV-073 | `disable fork` ✅ | Terminate spawned processes |

### 2. Events and Process Management

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-074 | Events ✅ | `event`, `->event`, `@event`, `triggered` |
| SV-075 | Process Class ✅ | `process`, `self()`, `status()` |
| SV-076 | Process Control ✅ | `kill`, `suspend`, `resume`, `await` |
| SV-077 | `wait_order` ✅ | Ordered event synchronization |

### 3. Inter-Process Communication

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-078 | Mailbox ✅ | `put`, `get`, `try_put`, `try_get`, `peek`, `try_peek` |
| SV-079 | Semaphore ✅ | `new()`, `get()`, `put()`, `try_get()` |

## Key Learning Areas

- **Parallel execution:** Run multiple processes using `fork...join`, `fork...join_any`, and `fork...join_none`.
- **Process coordination:** Wait for, terminate, and manage spawned processes.
- **Event synchronization:** Coordinate activities using events and ordered event controls.
- **Process management:** Inspect and control processes using the SystemVerilog `process` class.
- **Communication:** Exchange data between concurrent processes using mailboxes.
- **Resource synchronization:** Use semaphores to manage access to shared resources.

## Practical Work

Each topic is practiced through runnable SystemVerilog examples and Vivado simulation to observe process execution order, synchronization behavior, and communication between concurrent activities.

## Learning Outcomes

After completing this phase, you should be able to:
- Create and control concurrent processes.
- Coordinate execution using events and process synchronization.
- Inspect and manage process states.
- Exchange data through mailboxes.
- Control shared-resource access using semaphores.

## Tools
- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
