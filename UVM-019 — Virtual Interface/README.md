
# 168 — UVM-019 — Virtual Interface

### 1. Small Introduction

A virtual interface allows UVM class-based components to access signals declared in a SystemVerilog interface.

The interface is created in a top-level module and passed to a UVM component through `uvm_config_db`.

- `interface`: groups related signals.
- `virtual interface`: provides a class with access to interface signals.
- `uvm_config_db::set()`: publishes the interface handle.
- `uvm_config_db::get()`: retrieves the interface handle.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add `uvm_019_virtual_interface.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_019_virtual_interface_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Verify that the driver connects to the virtual interface and drives three transactions.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_019_if(input bit clk);
    bit valid;
    bit [7:0] data;
endinterface

class uvm_019_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(uvm_019_item)

    function new(string name = "uvm_019_item");
        super.new(name);
    endfunction
endclass

class uvm_019_driver extends uvm_driver #(uvm_019_item);
    virtual uvm_019_if vif;
    `uvm_component_utils(uvm_019_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uvm_019_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not configured")
        `uvm_info("DRIVER", "Virtual interface connected",
                  UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
        uvm_019_item item;
        forever begin
            seq_item_port.get_next_item(item);
            @(negedge vif.clk);
            vif.valid = 1;
            vif.data = item.data;
            `uvm_info("DRIVER",
                      $sformatf("Drove data = 0x%02h", item.data),
                      UVM_MEDIUM)
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_019_sequence extends uvm_sequence #(uvm_019_item);
    `uvm_object_utils(uvm_019_sequence)

    function new(string name = "uvm_019_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_019_item item;
        repeat (3) begin
            item = uvm_019_item::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")
            finish_item(item);
        end
    endtask
endclass

class uvm_019_env extends uvm_env;
    uvm_sequencer #(uvm_019_item) sequencer;
    uvm_019_driver driver;
    `uvm_component_utils(uvm_019_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_sequencer#(uvm_019_item)::type_id::create(
                        "sequencer", this);
        driver = uvm_019_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_019_test extends uvm_test;
    uvm_019_env env;
    `uvm_component_utils(uvm_019_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_019_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_019_sequence seq;
        phase.raise_objection(this);
        seq = uvm_019_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_019_virtual_interface_tb;
    bit clk = 0;
    uvm_019_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data = 0;
        uvm_config_db#(virtual uvm_019_if)::set(
            null, "uvm_test_top.env.driver", "vif", bus);
        run_test("uvm_019_test");
    end

    initial begin
        forever begin
            @(posedge clk);
            if (bus.valid)
                $display("TOP: Observed data = 0x%02h at %0t",
                         bus.data, $time);
        end
    end
endmodule
```

### 4. Expected Output

Randomized values vary. The log should show a successful virtual-interface connection, three driver messages, and three corresponding top-level observations.

This example demonstrates how `uvm_config_db` passes a virtual interface from the top-level module to a UVM driver. The driver retrieves the interface during `build_phase()` and uses it to drive transaction data on the interface signals.