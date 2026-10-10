
# Phase 13 — Universal Verification Methodology (UVM) ✅

## Overview

This phase introduces the Universal Verification Methodology (UVM) for building structured, reusable, and scalable SystemVerilog verification environments. It begins with a smoke test to verify the basic UVM simulation setup, then progresses through UVM architecture, components, sequences, TLM communication, configuration, factory mechanisms, and advanced verification features. The phase concludes with complete UVM-based FIFO, APB-RAM, and AXI4-Lite verification projects.

## Topics Covered

### 1. UVM Setup and Fundamentals

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-000 | Smoke Test ✅ | Basic UVM setup, test execution, simulation startup, and initial environment validation |
| UVM-001 | UVM Architecture ✅ | Test, environment, agent, sequencer, driver, monitor, scoreboard |
| UVM-002 | Component Hierarchy ✅ | `uvm_component`, parent/child hierarchy |
| UVM-003 | Object vs Component ✅ | `uvm_object`, `uvm_component` |
| UVM-004 | UVM Macros ✅ | `uvm_component_utils`, `uvm_object_utils` |
| UVM-005 | Sequence Item ✅ | `uvm_sequence_item` |
| UVM-006 | Transaction ✅ | Fields, randomization, methods |

### 2. Sequences and Core Components

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-007 | Sequence ✅ | Sequence, `body()` |
| UVM-008 | Sequencer ✅ | `uvm_sequencer` |
| UVM-009 | Driver ✅ | `uvm_driver`, `get_next_item`, `item_done` |
| UVM-010 | Monitor ✅ | Sampling DUT transactions |
| UVM-011 | Agent ✅ | Driver, sequencer, monitor |
| UVM-012 | Environment ✅ | `uvm_env` |
| UVM-013 | Test ✅ | `uvm_test`, `run_test` |
| UVM-014 | Scoreboard ✅ | `uvm_scoreboard` |

### 3. TLM Communication and DUT Connectivity

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-015 | Analysis Port ✅ | `uvm_analysis_port` |
| UVM-016 | Analysis Export ✅ | `uvm_analysis_export` |
| UVM-017 | TLM FIFO ✅ | `uvm_tlm_fifo` |
| UVM-018 | TLM Communication ✅ | `put`, `get`, `peek` |
| UVM-019 | Virtual Interface ✅ | Interface connection through `config_db` |
| UVM-020 | Config DB ✅ | `uvm_config_db::set`, `uvm_config_db::get` |

### 4. Phases, Factory, and Object Utilities

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-021 | Objections ✅ | `raise_objection`, `drop_objection` |
| UVM-022 | UVM Phases ✅ | Build, connect, end of elaboration, run, and other phases |
| UVM-023 | Runtime Phases ✅ | Reset, configure, main, shutdown |
| UVM-024 | Factory ✅ | Type registration, factory creation |
| UVM-025 | Factory Override ✅ | Type override, instance override |
| UVM-026 | Field Macros ✅ | Integers, enums, arrays, objects |
| UVM-027 | Copy/Clone ✅ | `copy`, `clone`, `create` |
| UVM-028 | Compare ✅ | `compare`, `do_compare` |
| UVM-029 | Print ✅ | `print`, `sprint`, `do_print` |
| UVM-030 | Pack/Unpack ✅ | `pack`, `unpack`, `do_pack`, `do_unpack` |

### 5. Reporting and Advanced UVM Features

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-031 | Reporting ✅ | `uvm_info`, `uvm_warning`, `uvm_error`, `uvm_fatal` |
| UVM-032 | Callbacks ✅ | Callback mechanism |
| UVM-033 | Sequence Arbitration ✅ | Sequence priority, arbitration |
| UVM-034 | Virtual Sequences ✅ | Multiple agents, multiple sequencers |
| UVM-035 | Register Model ✅ | `uvm_reg`, register abstraction |

### 6. Complete UVM Verification Projects

| No. | Topic | Concepts Covered |
|---|---|---|
| UVM-036 | Complete UVM FIFO ✅ | Complete agent, environment, test, scoreboard |
| UVM-037 | UVM APB-RAM ✅ | Protocol, memory subsystem |
| UVM-038 | UVM AXI4-Lite ✅ | AXI4-Lite master/slave, verification environment |

## Key Learning Areas

- **UVM setup:** Validate the simulation environment with an initial smoke test.
- **UVM architecture:** Understand how tests, environments, agents, sequencers, drivers, monitors, and scoreboards work together.
- **Sequence-based stimulus:** Create sequence items, generate transactions, and control stimulus through sequences and sequencers.
- **Component communication:** Connect verification components using TLM interfaces, analysis ports, exports, and FIFOs.
- **DUT connectivity:** Connect virtual interfaces and configure components using `uvm_config_db`.
- **Simulation control:** Manage UVM phases and objections to control test execution.
- **Factory mechanisms:** Register UVM types and apply type-based and instance-based overrides.
- **Object utilities:** Use field macros and implement copy, clone, compare, print, pack, and unpack operations.
- **Advanced verification:** Apply reporting, callbacks, sequence arbitration, virtual sequences, and register abstraction.
- **Protocol verification:** Build complete verification environments for FIFO, APB-RAM, and AXI4-Lite designs.

## Practical Work

Practice each topic through focused UVM examples, progressing from the initial smoke test and individual components to integrated verification environments. The final projects combine stimulus generation, DUT connectivity, transaction monitoring, scoreboard checking, and protocol-specific verification.

## Learning Outcomes

After completing this phase, you should be able to:

- Run a basic UVM smoke test and validate the simulation setup.
- Explain UVM architecture and component hierarchy.
- Create sequence items, sequences, sequencers, drivers, and monitors.
- Build agents, environments, tests, and scoreboards.
- Connect components through TLM communication mechanisms.
- Configure DUT interfaces and components using `uvm_config_db`.
- Control simulation using UVM phases and objections.
- Apply factory registration, overrides, and object utility methods.
- Use reporting macros, callbacks, arbitration, and virtual sequences.
- Understand register abstraction through the UVM register model.
- Develop complete UVM verification environments for FIFO, APB-RAM, and AXI4-Lite.

## Tools

- **Language:** SystemVerilog
- **Methodology:** Universal Verification Methodology (UVM)
- **Simulator:** AMD Vivado with supported UVM libraries
- **Practice:** Runnable code examples, simulation outputs, verification components, and GitHub learning notes
