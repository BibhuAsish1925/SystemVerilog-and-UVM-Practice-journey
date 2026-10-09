
# 011 — UVM-011 — Agent

### 1. Small Introduction

A UVM agent groups the sequencer, driver, and monitor into one reusable verification component.

- **Sequencer:** coordinates transaction delivery.
- **Driver:** receives transactions and drives interface signals.
- **Monitor:** passively samples interface signals and observes transactions.

An **active agent** creates a sequencer and driver along with a monitor. A **passive agent** typically creates only a monitor.

### 2. Vivado Flow — Step by Step

1. Add `uvm_011_agent.sv` under Simulation Sources.
2. Paste the complete SystemVerilog code below.
3. Set `uvm_011_agent_tb` as the simulation top.
4. Run Behavioral Simulation.
5. Execute `run 1000ns` in the Tcl Console.
6. Verify three driver messages and three matching monitor messages.

### 3. Compact Running Code

**File:** `uvm_011_agent.sv`

```systemverilog
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_011_if(input logic clk);
    logic valid;
    logic [7:0] addr;
    logic [7:0] data;
endinterface

class uvm_011_item extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_range {
        addr inside {[8'h10:8'h1F]};
    }

    `uvm_object_utils(uvm_011_item)

    function new(string name = "uvm_011_item");
        super.new(name);
    endfunction
endclass

class uvm_011_sequence extends uvm_sequence #(uvm_011_item);
    `uvm_object_utils(uvm_011_sequence)

    function new(string name = "uvm_011_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_011_item item;

        repeat (3) begin
            item = uvm_011_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_011_sequencer extends uvm_sequencer #(uvm_011_item);
    `uvm_component_utils(uvm_011_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_011_driver extends uvm_driver #(uvm_011_item);
    `uvm_component_utils(uvm_011_driver)

    virtual uvm_011_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_011_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Driver virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.valid = 1'b1;
            vif.addr = req.addr;
            vif.data = req.data;

            `uvm_info("DRIVER",
                $sformatf("Driving: addr=0x%02h data=0x%02h",
                          req.addr, req.data),
                UVM_MEDIUM)

            @(negedge vif.clk);
            vif.valid = 1'b0;

            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_011_monitor extends uvm_monitor;
    `uvm_component_utils(uvm_011_monitor)

    virtual uvm_011_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_011_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_011_item item;

        forever begin
            @(posedge vif.clk);

            if (vif.valid === 1'b1) begin
                item = uvm_011_item::type_id::create("item");
                item.addr = vif.addr;
                item.data = vif.data;

                `uvm_info("MONITOR",
                    $sformatf("Observed: addr=0x%02h data=0x%02h",
                              item.addr, item.data),
                    UVM_MEDIUM)
            end
        end
    endtask
endclass

class uvm_011_agent extends uvm_agent;
    `uvm_component_utils(uvm_011_agent)

    uvm_011_sequencer sequencer;
    uvm_011_driver driver;
    uvm_011_monitor monitor;
    virtual uvm_011_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_011_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Agent virtual interface not configured")

        uvm_config_db#(virtual uvm_011_if)::set(
            this, "driver", "vif", vif);
        uvm_config_db#(virtual uvm_011_if)::set(
            this, "monitor", "vif", vif);

        monitor = uvm_011_monitor::type_id::create("monitor", this);

        if (get_is_active() == UVM_ACTIVE) begin
            sequencer = uvm_011_sequencer::type_id::create(
                "sequencer", this);
            driver = uvm_011_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active() == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_011_env extends uvm_env;
    `uvm_component_utils(uvm_011_env)

    uvm_011_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uvm_011_agent::type_id::create("agent", this);
    endfunction
endclass

class uvm_011_test extends uvm_test;
    `uvm_component_utils(uvm_011_test)

    uvm_011_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_011_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_011_sequence seq;

        phase.raise_objection(this);
        seq = uvm_011_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_011_agent_tb;
    bit clk = 0;
    always #5 clk = ~clk;

    uvm_011_if bus(clk);

    initial begin
        bus.valid = 0;
        bus.addr = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_011_if)::set(
            null, "*", "vif", bus);

        run_test("uvm_011_test");
    end
endmodule
```

### 4. Expected Output

Three transactions should be driven and then observed by the monitor.

```text
[DRIVER] Driving: addr=0x19 data=0x99
[MONITOR] Observed: addr=0x19 data=0x99
[DRIVER] Driving: addr=0x16 data=0xDE
[MONITOR] Observed: addr=0x16 data=0xDE
[DRIVER] Driving: addr=0x1C data=0xF4
[MONITOR] Observed: addr=0x1C data=0xF4

UVM_WARNING : 0
UVM_ERROR   : 0
UVM_FATAL   : 0
```

Values are illustrative and will vary.

### 5. Key Takeaway

The agent combines the sequencer, driver, and monitor into a reusable component. The sequencer and driver are connected in `connect_phase()`, while the monitor independently observes the interface. This example uses an active agent.