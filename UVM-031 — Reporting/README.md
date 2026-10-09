
# 180 — UVM-031 — Reporting

## 1. Introduction

UVM reporting macros provide standardized messages during simulation.

| Macro | Purpose |
|---|---|
| `uvm_info` | Informational messages |
| `uvm_warning` | Potential problems |
| `uvm_error` | Verification errors |
| `uvm_fatal` | Critical failures that terminate simulation |

## 2. Complete Runnable Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_031_test extends uvm_test;
    `uvm_component_utils(uvm_031_test)

    function new(string name = "uvm_031_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info("REPORT", "Test started", UVM_LOW)

        `uvm_warning("REPORT", "Example warning message")

        `uvm_error("REPORT", "Example error message")

        `uvm_info("REPORT", "Test continues after the error", UVM_LOW)

        phase.drop_objection(this);
    endtask
endclass

module uvm_031_reporting_tb;
    initial
        run_test("uvm_031_test");
endmodule
```

## 3. Expected Output

```text
UVM_INFO ... [REPORT] Test started
UVM_WARNING ... [REPORT] Example warning message
UVM_ERROR ... [REPORT] Example error message
UVM_INFO ... [REPORT] Test continues after the error
```

## 4. Fatal Reporting Example

Test this separately because a fatal report terminates simulation.

```systemverilog
`uvm_fatal("REPORT", "Example fatal error")
```

## 5. Vivado Usage

1. Create `uvm_031_reporting.sv` under Simulation Sources.
2. Set `uvm_031_reporting_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Check the message severities and UVM report summary.

## 6. Key Takeaways

- Reporting macros make verification messages consistent.
- Report IDs help categorize and filter messages.
- Warnings and errors do not necessarily stop simulation.
- Fatal reports normally terminate simulation.
- A clean verification test should not contain unintended UVM errors or fatals.
