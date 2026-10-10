# SystemVerilog & UVM — My Learning Journey

A hands-on journey through **SystemVerilog, verification concepts, and UVM**, from fundamentals to complete verification environments.

## 📚 Repository Structure

```text
SystemVerilog-and-UVM/
│
├── README.md
│
├── Phase 01 — Data Types and Fundamentals/
│   ├── SV-001 — Data Types
│   ├── SV-002 — 2-State vs 4-State Data Types
│   ├── SV-003 — Signed and Unsigned Data
│   ├── SV-004 — Strings
│   ├── SV-005 — Parameters and Local Parameters
│   ├── SV-006 — Typedef
│   ├── SV-007 — Enumerations and Enum Methods
│   ├── SV-008 — Structures
│   ├── SV-009 — Unions
│   ├── SV-010 — Type Casting
│   ├── SV-011 — $cast
│   └── SV-012 — System Functions
│
├── Phase 02 — Arrays and Collections/
│   ├── SV-013 — Fixed Arrays
│   ├── SV-014 — Dynamic Arrays
│   ├── SV-015 — Dynamic Array Copying
│   ├── SV-016 — Queues
│   ├── SV-017 — Queue Methods
│   ├── SV-018 — Associative Arrays
│   ├── SV-019 — Associative Array Methods
│   ├── SV-020 — Array Locator Methods
│   ├── SV-021 — Array Ordering Methods
│   ├── SV-022 — Array Reduction Methods
│   ├── SV-023 — Foreach and Iteration
│   └── SV-024 — Assignment Patterns
│
├── Phase 03 — Functions, Tasks and Packages/
│   ├── SV-025 — Functions
│   ├── SV-026 — Tasks
│   ├── SV-027 — Argument Directions
│   │   ├── input
│   │   ├── output
│   │   ├── inout
│   │   └── ref
│   ├── SV-028 — Variable Lifetime
│   │   ├── Static Lifetime
│   │   └── Automatic Lifetime
│   ├── SV-029 — Void Functions
│   ├── SV-030 — Packages
│   └── SV-031 — Packages with Shared Definitions
│       ├── Typedefs
│       ├── Enumerations
│       ├── Classes
│       └── Functions
│
├── Phase 04 — Object-Oriented Programming/
│   ├── SV-032 to SV-047 — OOP Learning Series
│   ├── Classes and Objects
│   ├── Class Properties and Methods
│   ├── Constructors and Object Initialization
│   ├── Object Handles
│   ├── Object Creation and Assignment
│   ├── Encapsulation and Access Control
│   ├── Inheritance
│   ├── Base and Derived Classes
│   ├── Method Overriding
│   ├── Polymorphism
│   ├── Virtual Methods
│   ├── Virtual and Abstract Classes
│   ├── Static Properties and Methods
│   ├── Object Relationships
│   ├── Shallow Copying
│   └── Deep Copying and Cloning
│
├── Phase 05 — Randomization and Constraints/
│   ├── SV-048 to SV-068 — Randomization Learning Series
│   ├── rand Variables
│   ├── randc Variables
│   ├── Basic Constraints
│   ├── Constraint Blocks
│   ├── Randomization Success and Failure
│   ├── pre_randomize() and post_randomize()
│   ├── Inline Constraints
│   ├── Distribution Constraints — dist
│   ├── Set Membership Constraints — inside
│   ├── Implication Constraints
│   ├── solve-before Ordering
│   ├── rand_mode()
│   ├── constraint_mode()
│   ├── Conditional Constraints
│   ├── foreach Constraints
│   ├── Unique Constraints
│   └── Array Constraints
│
├── Phase 06 — IPC and Synchronization/
│   └── SV-069 to SV-079 — Synchronization Learning Series
│       ├── Inter-Process Communication Concepts
│       ├── Event-Based Synchronization
│       ├── Process Coordination
│       ├── Shared-Data Coordination
│       └── Synchronization Practice
│
├── Phase 07 — Interfaces/
│   └── SV-080 to SV-088 — Interface Learning Series
│       ├── Interface Fundamentals
│       ├── Interface Signals
│       ├── Modports
│       ├── Clocking Blocks
│       ├── Interface-Based Testbench Connections
│       └── Virtual Interface Concepts
│
├── Phase 08 — Simulation Semantics/
│   └── SV-089 to SV-095 — Simulation Learning Series
│       ├── Event Scheduling
│       ├── Simulation Time
│       ├── Scheduling Regions
│       ├── Blocking and Nonblocking Assignment Timing
│       ├── Race Conditions
│       └── Simulation Behaviour
│
├── Phase 09 — Functional Coverage/
│   └── SV-096 to SV-110 — Coverage Learning Series
│       ├── Functional Coverage Fundamentals
│       ├── Covergroups
│       ├── Coverpoints
│       ├── Coverage Bins
│       ├── Cross Coverage
│       ├── Sampling
│       └── Coverage-Based Verification Practice
│
├── Phase 10 — SystemVerilog Assertions/
│   └── SV-111 to SV-125 — Assertion Learning Series
│       ├── Assertion Fundamentals
│       ├── Immediate Assertions
│       ├── Concurrent Assertions
│       ├── Sequences
│       ├── Properties
│       ├── Temporal Checks
│       └── Assertion-Based Verification Practice
│
├── Phase 11 — Non-UVM Verification/
│   └── SV-126 to SV-141 — Verification Learning Series
│       ├── Testbench Organization
│       ├── Transaction-Based Stimulus
│       ├── Driver Concepts
│       ├── Monitor Concepts
│       ├── Data Checking
│       ├── Scoreboard Concepts
│       └── Self-Checking Testbench Practice
│
├── Phase 12 — Advanced SystemVerilog/
│   └── SV-142 to SV-148 — Advanced Language and Verification Series
│       ├── Advanced SystemVerilog Concepts
│       ├── Advanced Testbench Techniques
│       └── Integrated Verification Practice
│
├── SV-149 — Multi-Language EDA/
│   ├── SystemVerilog Testbench
│   ├── C Programming Integration
│   ├── DPI-C Integration
│   ├── Python Scripting
│   ├── Perl Scripting
│   ├── Tcl Scripting
│   └── Multi-Language EDA Workflow
│
└── Phase 13 — UVM/
    │
    ├── UVM-001 — UVM Architecture
    ├── UVM-002 — Component Hierarchy
    ├── UVM-003 — Object vs Component
    ├── UVM-004 — UVM Macros
    ├── UVM-005 — Sequence Item
    ├── UVM-006 — Transaction
    ├── UVM-007 — Sequence
    ├── UVM-008 — Sequencer
    ├── UVM-009 — Driver
    ├── UVM-010 — Monitor
    │
    ├── UVM-011 — Agent
    ├── UVM-012 — Environment
    ├── UVM-013 — Test and run_test()
    ├── UVM-014 — Scoreboard
    ├── UVM-015 — Analysis Port
    ├── UVM-016 — Analysis Export
    ├── UVM-017 — TLM FIFO
    ├── UVM-018 — TLM Communication
    ├── UVM-019 — Virtual Interface
    ├── UVM-020 — Configuration Database
    ├── UVM-021 — Objections
    ├── UVM-022 — UVM Phases
    ├── UVM-023 — Runtime Phases
    │
    ├── UVM-024 — Factory
    ├── UVM-025 — Factory Override
    ├── UVM-026 — Field Macros
    ├── UVM-027 — Copy and Clone
    ├── UVM-028 — Compare
    ├── UVM-029 — Print
    ├── UVM-030 — Pack and Unpack
    │
    ├── UVM-031 — Reporting
    ├── UVM-032 — Callbacks
    ├── UVM-033 — Sequence Arbitration
    ├── UVM-034 — Virtual Sequences
    ├── UVM-035 — Register Model
    ├── UVM-036 — Complete UVM FIFO
    │
    ├── UVM-037 — UVM APB-RAM/
    │   ├── APB Protocol
    │   ├── APB Master/Slave Interaction
    │   ├── RAM Memory Subsystem
    │   └── Protocol-Based Verification
    │
    └── UVM-038 — UVM AXI4-Lite/
        ├── AXI4-Lite Master
        ├── AXI4-Lite Slave
        ├── Write Address Channel — AW
        ├── Write Data Channel — W
        ├── Write Response Channel — B
        ├── Read Address Channel — AR
        ├── Read Data Channel — R
        ├── VALID/READY Handshakes
        ├── Monitor and Scoreboard
        └── UVM Verification Environment
```

### Standard contents of each learning topic

```text
Topic/
├── Concept Introduction
├── Complete Runnable Code
├── Relevant Learning Comments
├── Expected Simulation Output
├── Vivado Simulation Workflow
└── GitHub Markdown Notes
```

Each topic includes **concepts, runnable code, expected output, Vivado workflow, and GitHub notes**.

## 🎯 Why SystemVerilog & UVM?

- **SystemVerilog:** Describes digital hardware and provides powerful features for design and functional verification.
- **UVM:** Provides a reusable, scalable methodology for building structured, self-checking verification environments.

## 🛠️ Tools

- AMD Vivado 2025.1
- SystemVerilog
- UVM 1.2
- Tcl and multi-language EDA practice

## ✅ Journey Complete

Fundamentals → Advanced SystemVerilog → Randomization & Verification → UVM → Protocol-Based Verification.

*Built step by step, tested through simulation, and documented as my personal learning journey.*

---

## 👨‍💻 Author

**Bibhu Asish Panda**

**B.Tech — Electronics & Communication Engineering**

### Areas of Interest

* RTL Design
* Design Verification
* Digital VLSI
* Memory Design
* SystemVerilog
* UVM
* Physical Design
* STA
* RTL-to-GDSII

[GitHub](https://github.com/BibhuAsish1925) ·
[LinkedIn](www.linkedin.com/in/bibhu-asish-panda-05332b288)
