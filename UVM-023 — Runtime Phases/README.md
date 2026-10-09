# 172 — UVM-023 — Runtime Phases

### 1. Small Introduction

UVM runtime phases coordinate time-consuming verification activities.

* `reset_phase()`: initializes the DUT.
* `configure_phase()`: applies configuration settings.
* `main_phase()`: executes the primary stimulus.
* `shutdown_phase()`: completes outstanding activities before finishing.

Each phase is a task and can consume simulation time. Objections can be used to keep a phase active until its work is complete.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add `uvm_023_runtime_phases.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_023_runtime_phases_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Verify the Reset, Configure, Main, and Shutdown messages.

### 3. Compact Running Code

systemverilog

```
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_023_test extends uvm_test;
    `uvm_component_utils(uvm_023_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Reset: initializing DUT", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask

    task configure_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Configure: applying settings", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Main: running stimulus", UVM_LOW)
        #20;
        `uvm_info("RUNTIME", "Main: stimulus completed", UVM_LOW)
        phase.drop_objection(this);
    endtask

    task shutdown_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Shutdown: completing test", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask
endclass

module uvm_023_runtime_phases_tb;
    initial run_test("uvm_023_test");
endmodule
```

### 4. Expected Output

```
UVM_INFO ... [RUNTIME] Reset: initializing DUT
UVM_INFO ... [RUNTIME] Configure: applying settings
UVM_INFO ... [RUNTIME] Main: running stimulus
UVM_INFO ... [RUNTIME] Main: stimulus completed
UVM_INFO ... [RUNTIME] Shutdown: completing test
```

This lesson demonstrates four UVM runtime phases: Reset, Configure, Main, and Shutdown. Each phase performs a sample activity, uses a delay to represent time-consuming work, and drops its objection when finished. In practical verification, these phases coordinate reset control, DUT configuration, stimulus execution, and shutdown operations.
