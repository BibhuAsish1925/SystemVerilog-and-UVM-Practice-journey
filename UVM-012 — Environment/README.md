# 161 — UVM-012 — Environment

### 1. Small Introduction

A UVM environment (`uvm_env`) organizes verification components into a reusable structure.

<table align="center">
  <tr>
    <td align="center">
      <img width="805" height="400" alt="image" src="https://github.com/user-attachments/assets/ec58fadf-3df8-4c07-9f16-1420627eece1" /><br/>
      <small>Fig.UVM Environment</small>
    </td>
</table>

The environment typically contains one or more agents and can also contain scoreboards and coverage collectors.

An agent groups:
- Sequencer — coordinates transaction delivery.
- Driver — drives interface signals.
- Monitor — samples and observes interface activity.

### 2. Vivado Flow

1. Add `uvm_012_environment.sv` under Simulation Sources.
2. Paste the complete code below.
3. Set `uvm_012_environment_tb` as the simulation top.
4. Run Behavioral Simulation.
5. Execute `run 1000ns` in the Tcl Console.
6. Verify three driver messages and three matching monitor messages.

### 3. Compact Running Code

**File:** `uvm_012_environment.sv`

```systemverilog
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_012_if(input logic clk);
    logic valid;
    logic [7:0] addr;
    logic [7:0] data;
endinterface

class uvm_012_item extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_range {
        addr inside {[8'h10:8'h1F]};
    }

    `uvm_object_utils(uvm_012_item)

    function new(string name = "uvm_012_item");
        super.new(name);
    endfunction
endclass

class uvm_012_sequence extends uvm_sequence #(uvm_012_item);
    `uvm_object_utils(uvm_012_sequence)

    function new(string name = "uvm_012_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_012_item item;

        repeat (3) begin
            item = uvm_012_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_012_sequencer extends uvm_sequencer #(uvm_012_item);
    `uvm_component_utils(uvm_012_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_012_driver extends uvm_driver #(uvm_012_item);
    `uvm_component_utils(uvm_012_driver)

    virtual uvm_012_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_012_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Driver interface not configured")
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

class uvm_012_monitor extends uvm_monitor;
    `uvm_component_utils(uvm_012_monitor)

    virtual uvm_012_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_012_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);

            if (vif.valid === 1'b1)
                `uvm_info("MONITOR",
                    $sformatf("Observed: addr=0x%02h data=0x%02h",
                              vif.addr, vif.data),
                    UVM_MEDIUM)
        end
    endtask
endclass

class uvm_012_agent extends uvm_agent;
    `uvm_component_utils(uvm_012_agent)

    uvm_012_sequencer sequencer;
    uvm_012_driver driver;
    uvm_012_monitor monitor;
    virtual uvm_012_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_012_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Agent interface not configured")

        uvm_config_db#(virtual uvm_012_if)::set(
            this, "driver", "vif", vif);
        uvm_config_db#(virtual uvm_012_if)::set(
            this, "monitor", "vif", vif);

        monitor = uvm_012_monitor::type_id::create("monitor", this);

        if (get_is_active() == UVM_ACTIVE) begin
            sequencer = uvm_012_sequencer::type_id::create(
                "sequencer", this);
            driver = uvm_012_driver::type_id::create("driver", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active() == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_012_env extends uvm_env;
    `uvm_component_utils(uvm_012_env)

    uvm_012_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uvm_012_agent::type_id::create("agent", this);
    endfunction
endclass

class uvm_012_test extends uvm_test;
    `uvm_component_utils(uvm_012_test)

    uvm_012_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_012_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_012_sequence seq;

        phase.raise_objection(this);
        seq = uvm_012_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_012_environment_tb;
    bit clk = 0;
    always #5 clk = ~clk;

    uvm_012_if bus(clk);

    initial begin
        bus.valid = 0;
        bus.addr = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_012_if)::set(
            null, "*", "vif", bus);

        run_test("uvm_012_test");
    end
endmodule
```

### 4. Expected Output

Three transactions should be driven and observed. Values vary between runs.

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

### 5. Key Takeaway

`uvm_env` organizes agents and other verification components. In this example, the environment creates one agent, which contains the sequencer, driver, and monitor. This hierarchy makes the testbench easier to extend and reuse.
