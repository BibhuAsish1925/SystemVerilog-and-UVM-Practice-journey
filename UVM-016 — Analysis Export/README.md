# 165 — UVM-016 — Analysis Export

### 1. Small Introduction

A UVM analysis export exposes an analysis interface through an intermediate component.

* `uvm_analysis_port`: Publishes transactions.
* `uvm_analysis_export`: Exposes or forwards the analysis connection.
* `uvm_analysis_imp`: Receives transactions and calls the subscriber's `write()` method.

In this example, the monitor's analysis port connects to the environment's export, which then connects to the scoreboard's implementation.

<table align="center">
  <tr>
    <td align="center">
      <img width="807" height="397" alt="image" src="https://github.com/user-attachments/assets/132e63a0-00c9-46dc-9fd7-e37ec09616a2" /><br/>
      <small>Fig. UVM Analysis Export</small>
    </td>
</table>

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add a Simulation Source named `uvm_016_analysis_export.sv`.
3. Paste the complete code from this lesson.
4. Set `uvm_016_analysis_export_tb` as the simulation top.
5. Run Run Simulation → Run Behavioral Simulation.
6. Enter `run 1000ns` in the Tcl Console.
7. Confirm three scoreboard PASS messages and a final summary of `PASS=3 ERROR=0`.

### 3. Compact Running Code

systemverilog

```
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_016_if(input bit clk);
    logic valid;
    logic [7:0] data;
    logic [7:0] data_out;

    assign data_out = ~data;
endinterface

class uvm_016_item extends uvm_sequence_item;
    rand bit [7:0] data;
    bit [7:0] actual_data;

    `uvm_object_utils(uvm_016_item)

    function new(string name = "uvm_016_item");
        super.new(name);
    endfunction
endclass

class uvm_016_sequence extends uvm_sequence #(uvm_016_item);
    `uvm_object_utils(uvm_016_sequence)

    function new(string name = "uvm_016_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_016_item item;

        repeat (3) begin
            item = uvm_016_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_016_sequencer extends uvm_sequencer #(uvm_016_item);
    `uvm_component_utils(uvm_016_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_016_driver extends uvm_driver #(uvm_016_item);
    virtual uvm_016_if vif;

    `uvm_component_utils(uvm_016_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_016_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.data = req.data;
            vif.valid = 1;

            `uvm_info("DRIVER",
                $sformatf("Driving data=0x%02h", req.data),
                UVM_MEDIUM)

            @(negedge vif.clk);
            vif.valid = 0;
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_016_monitor extends uvm_component;
    virtual uvm_016_if vif;
    uvm_analysis_port #(uvm_016_item) analysis_port;

    `uvm_component_utils(uvm_016_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_016_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_016_item observed;

        forever begin
            @(posedge vif.clk);

            if (vif.valid) begin
                observed = uvm_016_item::type_id::create("observed");
                observed.data = vif.data;
                observed.actual_data = vif.data_out;

                `uvm_info("MONITOR",
                    $sformatf("data=0x%02h output=0x%02h",
                        observed.data, observed.actual_data),
                    UVM_MEDIUM)

                analysis_port.write(observed);
            end
        end
    endtask
endclass

class uvm_016_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(uvm_016_item, uvm_016_scoreboard) analysis_imp;
    int pass_count = 0;
    int error_count = 0;

    `uvm_component_utils(uvm_016_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    function void write(uvm_016_item item);
        bit [7:0] expected_data;
        expected_data = ~item.data;

        if (item.actual_data === expected_data) begin
            pass_count++;
            `uvm_info("SCOREBOARD",
                $sformatf("PASS expected=0x%02h actual=0x%02h",
                    expected_data, item.actual_data),
                UVM_MEDIUM)
        end
        else begin
            error_count++;
            `uvm_error("SCOREBOARD",
                $sformatf("FAIL expected=0x%02h actual=0x%02h",
                    expected_data, item.actual_data))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SUMMARY",
            $sformatf("PASS=%0d ERROR=%0d",
                pass_count, error_count), UVM_NONE)
    endfunction
endclass

class uvm_016_env extends uvm_env;
    uvm_016_sequencer sequencer;
    uvm_016_driver driver;
    uvm_016_monitor monitor;
    uvm_016_scoreboard scoreboard;
    uvm_analysis_export #(uvm_016_item) analysis_export;

    `uvm_component_utils(uvm_016_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sequencer = uvm_016_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_016_driver::type_id::create("driver", this);
        monitor = uvm_016_monitor::type_id::create("monitor", this);
        scoreboard = uvm_016_scoreboard::type_id::create(
            "scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(analysis_export);
        analysis_export.connect(scoreboard.analysis_imp);
    endfunction
endclass

class uvm_016_test extends uvm_test;
    uvm_016_env env;

    `uvm_component_utils(uvm_016_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_016_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_016_sequence seq;

        phase.raise_objection(this);
        seq = uvm_016_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_016_analysis_export_tb;
    bit clk = 0;
    uvm_016_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_016_if)::set(
            null, "*", "vif", bus
        );

        run_test("uvm_016_test");
    end
endmodule
```

### 4. Expected Output

Randomized values vary. Expect three monitor transactions, three scoreboard PASS messages, `PASS=3 ERROR=0`, and no UVM errors or fatal messages.

### Key Takeaways

* An analysis export is a connection mechanism, not a transaction generator.
* The monitor publishes through `uvm_analysis_port`.
* The environment exposes the path through `uvm_analysis_export`.
* The scoreboard receives transactions through `uvm_analysis_imp`.
* The analysis connections are established in `connect_phase()`. </CodeBlock>
