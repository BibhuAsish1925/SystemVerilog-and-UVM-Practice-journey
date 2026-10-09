# 170 — UVM-021 — Objections

### 1. Small Introduction

UVM objections control when a simulation phase can finish.

- `raise_objection(this)`: keeps the phase active while work is in progress.
- `drop_objection(this)`: releases the component's objection when work is complete.

Typical usage:

```systemverilog
phase.raise_objection(this);

// Perform test activity

phase.drop_objection(this);
```

When all relevant objections are dropped, UVM can complete the run phase.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add `uvm_021_objections.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_021_objections_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Verify that the three transaction messages appear before the objection is dropped.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_021_test extends uvm_test;
    `uvm_component_utils(uvm_021_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("OBJECTION", "Objection raised", UVM_MEDIUM)

        repeat (3) begin
            #10;
            `uvm_info("TEST", "Transaction completed", UVM_MEDIUM)
        end

        `uvm_info("OBJECTION", "Dropping objection", UVM_MEDIUM)
        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info("REPORT", "Run phase completed", UVM_MEDIUM)
    endfunction
endclass

module uvm_021_objections_tb;
    initial run_test("uvm_021_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [OBJECTION] Objection raised
UVM_INFO ... [TEST] Transaction completed
UVM_INFO ... [TEST] Transaction completed
UVM_INFO ... [TEST] Transaction completed
UVM_INFO ... [OBJECTION] Dropping objection
UVM_INFO ... [REPORT] Run phase completed
```

This lesson demonstrates UVM phase control using `raise_objection()` and `drop_objection()`. The objection keeps `run_phase()` active during the test activity and is dropped when the work is complete, allowing UVM to finish the phase.