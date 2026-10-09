# 184 — UVM-035 — Register Model

### 1. Small Introduction

A UVM Register Model provides an abstract representation of hardware registers.

- `uvm_reg` models a hardware register.
- `uvm_reg_field` models a field inside a register.
- `uvm_reg_block` groups registers and address maps.
- Register abstraction lets tests describe register operations without directly controlling bus signals.

This lesson models an 8-bit control register at address `0x00`.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 project.
2. Create `uvm_035_register_model.sv` under Simulation Sources.
3. Paste the complete SystemVerilog code below.
4. Set `uvm_035_register_model_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Enter `run 1000ns` in the Tcl Console.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_035_control_reg extends uvm_reg;
    `uvm_object_utils(uvm_035_control_reg)

    uvm_reg_field control;

    function new(string name = "uvm_035_control_reg");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        control = uvm_reg_field::type_id::create("control");
        control.configure(this, 8, 0, "RW", 0, 0, 1, 1, 0);
    endfunction
endclass

class uvm_035_reg_block extends uvm_reg_block;
    `uvm_object_utils(uvm_035_reg_block)

    uvm_035_control_reg control_reg;
    uvm_reg_map default_map;

    function new(string name = "uvm_035_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        default_map = create_map(
            "default_map", 0, 1, UVM_LITTLE_ENDIAN
        );

        control_reg = uvm_035_control_reg::type_id::create(
            "control_reg"
        );
        control_reg.configure(this, null, "");
        control_reg.build();

        default_map.add_reg(control_reg, 'h00, "RW");
        lock_model();
    endfunction
endclass

class uvm_035_test extends uvm_test;
    `uvm_component_utils(uvm_035_test)

    uvm_035_reg_block reg_model;
    uvm_reg_data_t value;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reg_model = uvm_035_reg_block::type_id::create("reg_model");
        reg_model.build();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        reg_model.control_reg.set(8'hA5);
        value = reg_model.control_reg.get();

        `uvm_info("RAL",
            $sformatf("Register desired value = 0x%02h", value),
            UVM_MEDIUM)

        reg_model.control_reg.predict(8'hA5);
        value = reg_model.control_reg.get_mirrored_value();

        `uvm_info("RAL",
            $sformatf("Register mirrored value = 0x%02h", value),
            UVM_MEDIUM)

        `uvm_info("RAL",
            "Register model demonstration completed", UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
endclass

module uvm_035_register_model_tb;
    initial run_test("uvm_035_test");
endmodule
```

### 4. Expected Output

```
[RAL] Register desired value = 0xa5
[RAL] Register mirrored value = 0xa5
[RAL] Register model demonstration completed
```

### 5. Key Takeaways

- `uvm_reg` represents a hardware register.
- `uvm_reg_field` represents a register field.
- `uvm_reg_block` groups registers and address maps.
- `set()` updates the desired value, not the physical DUT.
- `predict()` updates the model's expected mirrored state.
- Actual bus reads and writes require additional frontdoor infrastructure, including a bus adapter and sequencer.

Key takeaway: The register model separates what the test wants to access from how the hardware bus performs the access. This abstraction becomes especially useful when verifying DUTs with many registers.
