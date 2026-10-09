# 181 — UVM-032 — Callbacks

### 1. Small Introduction

A UVM callback adds or modifies component behavior without directly changing the component's source code.

Main elements:

- Callback class defines additional behavior.
- Registration attaches the callback to a component.
- Invocation executes the callback at a selected point.
- The callback can inspect or modify transaction data.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Under Simulation Sources, create `uvm_032_callbacks.sv`.
3. Paste the complete SystemVerilog code below.
4. Set `uvm_032_callbacks_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Enter `run 1000ns` in the Tcl Console.

### 3. Compact Running Code

```
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_032_item extends uvm_object;
    `uvm_object_utils(uvm_032_item)
    bit [7:0] data;

    function new(string name = "uvm_032_item");
        super.new(name);
    endfunction
endclass

class uvm_032_callback extends uvm_callback;
    `uvm_object_utils(uvm_032_callback)

    function new(string name = "uvm_032_callback");
        super.new(name);
    endfunction

    virtual function void pre_process(uvm_032_item item);
        item.data = item.data + 1;
        `uvm_info("CALLBACK",
            $sformatf("Callback modified data to 0x%02h", item.data),
            UVM_MEDIUM)
    endfunction
endclass

class uvm_032_driver extends uvm_component;
    `uvm_component_utils(uvm_032_driver)
    `uvm_register_cb(uvm_032_driver, uvm_032_callback)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_032_item req;

        for (int i = 0; i < 3; i++) begin
            req = uvm_032_item::type_id::create("req");
            req.data = 8'h10 + i;

            `uvm_do_callbacks(
                uvm_032_driver, uvm_032_callback, pre_process(req))

            `uvm_info("DRIVER",
                $sformatf("Processing data = 0x%02h", req.data),
                UVM_MEDIUM)
            #10ns;
        end
    endtask
endclass

class uvm_032_env extends uvm_env;
    `uvm_component_utils(uvm_032_env)
    uvm_032_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = uvm_032_driver::type_id::create("driver", this);
    endfunction
endclass

class uvm_032_test extends uvm_test;
    `uvm_component_utils(uvm_032_test)
    uvm_032_env env;
    uvm_032_callback cb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_032_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        cb = uvm_032_callback::type_id::create("cb");
        uvm_callbacks#(uvm_032_driver, uvm_032_callback)::add(
            env.driver, cb);
        `uvm_info("TEST", "Callback registered with driver", UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #35ns;
        phase.drop_objection(this);
    endtask
endclass

module uvm_032_callbacks_tb;
    initial run_test("uvm_032_test");
endmodule
```

### 4. Expected Output

```
[TEST] Callback registered with driver
[CALLBACK] Callback modified data to 0x11
[DRIVER] Processing data = 0x11
[CALLBACK] Callback modified data to 0x12
[DRIVER] Processing data = 0x12
[CALLBACK] Callback modified data to 0x13
[DRIVER] Processing data = 0x13
```

### 5. Key Takeaways

- `uvm_callback` is the base class for callbacks.
- `uvm_register_cb` registers a callback type for a component.
- `uvm_callbacks#(...)::add()` attaches a callback instance.
- `uvm_do_callbacks` invokes registered callbacks.
- Callbacks make verification components easier to extend and customize.

Key takeaway: A callback allows you to customize a component's behavior externally. Here, the driver invokes `pre_process()`, and the registered callback modifies the data before the driver processes it.