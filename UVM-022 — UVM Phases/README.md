
# 171 — UVM-022 — UVM Phases

### 1. Small Introduction

UVM phases organize testbench construction, connection, execution, checking, reporting, and cleanup.

- `build_phase`: creates components and retrieves configuration.
- `connect_phase`: connects TLM ports and exports.
- `end_of_elaboration_phase`: finalizes the component hierarchy.
- `start_of_simulation_phase`: performs setup before run-time activity.
- `run_phase`: executes time-consuming test activity.
- `extract_phase`: extracts results.
- `check_phase`: checks final conditions.
- `report_phase`: reports results.
- `final_phase`: performs final cleanup.

Function phases execute without consuming simulation time. The run phase is a task phase that can consume simulation time.

 <table align="center">
  <tr>
    <td align="center">
      <img width="427" height="402" alt="image" src="https://github.com/user-attachments/assets/72a0dd3a-50d7-4dfd-aa11-236c00030f0c" /><br/>
      <small>Fig. UVM Phases</small>
    </td>
</table>

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add `uvm_022_phases.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_022_phases_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Verify the phase messages and confirm that post-run phases execute after the objection is dropped.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_022_env extends uvm_env;
    `uvm_component_utils(uvm_022_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("PHASE", "build_phase", UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("PHASE", "connect_phase", UVM_LOW)
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("PHASE", "end_of_elaboration_phase", UVM_LOW)
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("PHASE", "start_of_simulation_phase", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("PHASE", "run_phase: executing", UVM_LOW)
        #10;
    endtask

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("PHASE", "extract_phase", UVM_LOW)
    endfunction

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("PHASE", "check_phase", UVM_LOW)
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("PHASE", "report_phase", UVM_LOW)
    endfunction

    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("PHASE", "final_phase", UVM_LOW)
    endfunction
endclass

class uvm_022_test extends uvm_test;
    uvm_022_env env;
    `uvm_component_utils(uvm_022_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_022_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", "Test started", UVM_LOW)
        #30;
        `uvm_info("TEST", "Test activity completed", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass

module uvm_022_phases_tb;
    initial run_test("uvm_022_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [PHASE] build_phase
UVM_INFO ... [PHASE] connect_phase
UVM_INFO ... [PHASE] end_of_elaboration_phase
UVM_INFO ... [PHASE] start_of_simulation_phase
UVM_INFO ... [TEST] Test started
UVM_INFO ... [PHASE] run_phase: executing
UVM_INFO ... [TEST] Test activity completed
UVM_INFO ... [PHASE] extract_phase
UVM_INFO ... [PHASE] check_phase
UVM_INFO ... [PHASE] report_phase
UVM_INFO ... [PHASE] final_phase
```

This lesson demonstrates the UVM component lifecycle, from `build_phase()` and `connect_phase()` through `run_phase()` and the post-run phases. Objections control how long run-time test activity remains active.
