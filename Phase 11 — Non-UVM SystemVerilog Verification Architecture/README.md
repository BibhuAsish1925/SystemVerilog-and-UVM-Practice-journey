
# Phase 11 — Non-UVM SystemVerilog Verification Architecture ✅

## Overview

This phase builds a modular SystemVerilog verification environment without using UVM. It introduces transaction-based verification and the interaction between generator, driver, monitor, scoreboard, reference model, environment, and test classes. It also integrates functional coverage and assertions to create a structured verification flow.

## Topics Covered

### 1. Transactions and Stimulus Generation

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-126 | Transaction ✅ | Transaction class, fields, methods |
| SV-127 | Transaction Randomization ✅ | `rand` fields, constraints |
| SV-128 | Generator ✅ | Transaction generation |
| SV-129 | Generator + Mailbox ✅ | Transaction communication |

### 2. DUT Connectivity and Observation

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-130 | Driver ✅ | Transaction-to-pin conversion |
| SV-131 | Driver + Virtual Interface ✅ | Class-to-DUT connectivity |
| SV-132 | Monitor ✅ | Pin-to-transaction conversion |
| SV-133 | Monitor + Mailbox ✅ | Observed transaction communication |

### 3. Checking and Expected Behavior

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-134 | Scoreboard ✅ | Expected vs actual comparison |
| SV-135 | Reference Model ✅ | Predict expected DUT behavior |

### 4. Environment and Test Control

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-136 | Environment ✅ | Generator, driver, monitor, scoreboard |
| SV-137 | Test Class ✅ | Test control, stimulus |

### 5. Coverage, Assertions, and Complete Verification

| No. | Topic | Concepts Covered |
|---|---|---|
| SV-138 | Coverage Integration ✅ | Monitor-to-coverage connection |
| SV-139 | Assertion Integration ✅ | DUT and SystemVerilog Assertions (SVA) |
| SV-140 | Complete FIFO Verification ✅ | Generator → Driver → DUT → Monitor → Scoreboard |
| SV-141 | Complete Protocol Verification ✅ | APB/AXI/SPI-style verification environment |

## Key Learning Areas

- **Transaction-based verification:** Represent stimulus and observed activity using transaction classes.
- **Stimulus generation:** Generate randomized transactions using `rand` fields and constraints.
- **Communication:** Transfer transactions between verification components using mailboxes.
- **DUT connectivity:** Connect class-based components to DUT signals through a virtual interface.
- **Monitoring:** Observe DUT pin activity and convert it into transactions.
- **Checking:** Compare expected and actual results using a scoreboard and reference model.
- **Environment architecture:** Organize generator, driver, monitor, and scoreboard components under an environment and control them through a test class.
- **Coverage and assertions:** Integrate functional coverage and SVA checks into the verification flow.
- **End-to-end verification:** Combine the components into complete FIFO and protocol verification environments.

## Practical Work

Each topic is practiced through standalone SystemVerilog examples, progressing from transaction classes and component communication to complete verification environments. The final exercises combine stimulus generation, DUT interaction, monitoring, result checking, coverage, and assertions.

## Learning Outcomes

After completing this phase, you should be able to:

- Create transaction classes and generate constrained-random stimulus.
- Build generator, driver, and monitor components.
- Connect class-based components to DUT signals using virtual interfaces.
- Communicate transactions through mailboxes.
- Implement scoreboards and reference models for checking DUT behavior.
- Organize verification components using environment and test classes.
- Integrate functional coverage and assertions.
- Develop complete non-UVM FIFO and protocol verification environments.

## Tools

- **Language:** SystemVerilog
- **Simulator:** AMD Vivado
- **Verification style:** Class-based, non-UVM verification
- **Practice:** Runnable code examples, simulation outputs, and GitHub learning notes
