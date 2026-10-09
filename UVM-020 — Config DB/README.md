# 169 — UVM-020 — Config DB

### 1. Small Introduction

`uvm_config_db` shares configuration values between UVM components.

* `uvm_config_db::set()` stores a value for a component path and field name.
* `uvm_config_db::get()` retrieves that value.
* The type parameter must match between `set()` and `get()`.

Example syntax:

systemverilog

```
uvm_config_db#(DATA_TYPE)::set(
    context, instance_path, field_name, value
);

uvm_config_db#(DATA_TYPE)::get(
    context, instance_path, field_name, value
);
```

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add `uvm_020_config_db.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_020_config_db_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Verify that the driver retrieves the interface and `drive_count` configuration values.

### 3. Compact Running Code

systemverilog

```
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_020_if(input bit clk);
    bit valid;
    bit [7:0] data;
endinterface

class uvm_020_item extends uvm_sequence_item;
    rand bit [7:0] data;
    `uvm_object_utils(uvm_020_item)

    function new(string name = "uvm_020_item");
        super.new(name);
    endfunction
endclass

class uvm_020_driver extends uvm_driver #(uvm_020_item);
    virtual uvm_020_if vif;
    int unsigned drive_count;
    `uvm_component_utils(uvm_020_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_020_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("CFG", "Failed to get virtual interface")

        if (!uvm_config_db#(int unsigned)::get(
                this, "", "drive_count", drive_count))
            `uvm_fatal("CFG", "Failed to get drive_count")

        `uvm_info("CONFIG",
                  $sformatf("Got drive_count = %0d", drive_count),
                  UVM_MEDIUM)
    endfunction

    task run_phase(uvm_phase phase);
        uvm_020_item item;
        repeat (drive_count) begin
            seq_item_port.get_next_item(item);
            @(negedge vif.clk);
            vif.valid = 1;
            vif.data = item.data;
            `uvm_info("DRIVER",
                      $sformatf("Drove data = 0x%02h", item.data),
                      UVM_MEDIUM)
            seq_item_port.item_done();
        end
        @(negedge vif.clk);
        vif.valid = 0;
    endtask
endclass

class uvm_020_sequence extends uvm_sequence #(uvm_020_item);
    `uvm_object_utils(uvm_020_sequence)

    function new(string name = "uvm_020_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_020_item item;
        repeat (3) begin
            item = uvm_020_item::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")
            finish_item(item);
        end
    endtask
endclass

class uvm_020_env extends uvm_env;
    uvm_sequencer #(uvm_020_item) sequencer;
    uvm_020_driver driver;
    `uvm_component_utils(uvm_020_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_sequencer#(uvm_020_item)::type_id::create(
                        "sequencer", this);
        driver = uvm_020_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_020_test extends uvm_test;
    uvm_020_env env;
    `uvm_component_utils(uvm_020_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_020_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_020_sequence seq;
        phase.raise_objection(this);
        seq = uvm_020_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_020_config_db_tb;
    bit clk = 0;
    uvm_020_if bus(clk);
    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_020_if)::set(
            null, "uvm_test_top.env.driver", "vif", bus);
        uvm_config_db#(int unsigned)::set(
            null, "uvm_test_top.env.driver", "drive_count", 3);

        run_test("uvm_020_test");
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

Randomized values vary between runs. The log should show:

* `Got drive_count = 3`
* Three driver messages
* Three corresponding top-level observations
* No `CFG` fatal errors

This lesson demonstrates sharing a virtual interface and an integer configuration value using `uvm_config_db`. The top module publishes both values with `set()`, and the driver retrieves them with `get()` during `build_phase()`. </CodeBlock>
