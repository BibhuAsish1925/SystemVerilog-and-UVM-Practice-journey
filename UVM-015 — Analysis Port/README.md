
# 164 — UVM-015 — Analysis Port

### 1. Small Introduction

The UVM analysis port broadcasts transactions from a producer, usually a monitor, to one or more subscribers.

- `uvm_analysis_port`: Publishes transactions using `write()`.
- `uvm_analysis_imp`: Receives transactions and invokes the subscriber's `write()` method.
- `uvm_subscriber`: Provides a convenient base class for transaction subscribers.
- `connect_phase()`: Connects the monitor's analysis port to the scoreboard and logger.

This example broadcasts three observed transactions to two subscribers.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add a Simulation Source named `uvm_015_analysis_port.sv`.
3. Paste the complete code below.
4. Set `uvm_015_analysis_port_tb` as the simulation top.
5. Run **Run Simulation → Run Behavioral Simulation**.
6. Enter `run 1000ns` in the Tcl Console.
7. Confirm that the scoreboard reports three passes and the logger receives three transactions.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_015_if(input bit clk);
    logic valid;
    logic [7:0] data;
    logic [7:0] data_out;

    assign data_out = ~data;
endinterface

class uvm_015_item extends uvm_sequence_item;
    rand bit [7:0] data;
    bit [7:0] actual_data;

    `uvm_object_utils(uvm_015_item)

    function new(string name = "uvm_015_item");
        super.new(name);
    endfunction
endclass

class uvm_015_sequence extends uvm_sequence #(uvm_015_item);
    `uvm_object_utils(uvm_015_sequence)

    function new(string name = "uvm_015_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_015_item item;

        repeat (3) begin
            item = uvm_015_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_015_sequencer extends uvm_sequencer #(uvm_015_item);
    `uvm_component_utils(uvm_015_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_015_driver extends uvm_driver #(uvm_015_item);
    virtual uvm_015_if vif;

    `uvm_component_utils(uvm_015_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_015_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.data  = req.data;
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

class uvm_015_monitor extends uvm_component;
    virtual uvm_015_if vif;
    uvm_analysis_port #(uvm_015_item) analysis_port;

    `uvm_component_utils(uvm_015_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_015_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_015_item observed;

        forever begin
            @(posedge vif.clk);

            if (vif.valid) begin
                observed = uvm_015_item::type_id::create("observed");
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

class uvm_015_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(uvm_015_item, uvm_015_scoreboard) analysis_imp;
    int pass_count = 0;
    int error_count = 0;

    `uvm_component_utils(uvm_015_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    function void write(uvm_015_item item);
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
            $sformatf("Scoreboard PASS=%0d ERROR=%0d",
                pass_count, error_count), UVM_NONE)
    endfunction
endclass

class uvm_015_logger extends uvm_subscriber #(uvm_015_item);
    int received_count = 0;

    `uvm_component_utils(uvm_015_logger)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void write(uvm_015_item item);
        received_count++;
        `uvm_info("LOGGER",
            $sformatf("Transaction %0d: data=0x%02h",
                received_count, item.data), UVM_MEDIUM)
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("LOGGER_SUMMARY",
            $sformatf("Received %0d transactions", received_count),
            UVM_NONE)
    endfunction
endclass

class uvm_015_env extends uvm_env;
    uvm_015_sequencer sequencer;
    uvm_015_driver driver;
    uvm_015_monitor monitor;
    uvm_015_scoreboard scoreboard;
    uvm_015_logger logger;

    `uvm_component_utils(uvm_015_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_015_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_015_driver::type_id::create("driver", this);
        monitor = uvm_015_monitor::type_id::create("monitor", this);
        scoreboard = uvm_015_scoreboard::type_id::create(
            "scoreboard", this);
        logger = uvm_015_logger::type_id::create("logger", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(scoreboard.analysis_imp);
        monitor.analysis_port.connect(logger.analysis_export);
    endfunction
endclass

class uvm_015_test extends uvm_test;
    uvm_015_env env;

    `uvm_component_utils(uvm_015_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_015_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_015_sequence seq;

        phase.raise_objection(this);
        seq = uvm_015_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_015_analysis_port_tb;
    bit clk = 0;
    uvm_015_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_015_if)::set(
            null, "*", "vif", bus
        );

        run_test("uvm_015_test");
    end
endmodule
```

### 4. Expected Output

Random data values vary. Expect three monitor transactions, three scoreboard PASS messages, three logger messages, and no UVM errors or fatal messages.

### Key Takeaways

- `uvm_analysis_port` supports one-to-many transaction broadcasting.
- `analysis_port.write(item)` publishes an observed transaction.
- `uvm_analysis_imp` receives transactions through a `write()` callback.
- `uvm_subscriber` offers a built-in `analysis_export`.
- Connect analysis ports in `connect_phase()`.
- Analysis communication does not require the monitor to know the subscribers' internal implementation.
```