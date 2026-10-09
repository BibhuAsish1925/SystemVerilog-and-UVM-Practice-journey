# 185 — UVM-036 — Complete UVM FIFO

### 1. Small Introduction

This lesson combines the main UVM components into a FIFO verification environment.

- Agent: Contains a sequencer, driver, and monitor.
- Environment: Instantiates the agent and scoreboard and connects analysis communication.
- Test: Starts a sequence that sends FIFO operations.
- Scoreboard: Uses a reference queue to compare expected and observed FIFO data.

The example uses a synchronous FIFO with depth 4 and an 8-bit data path.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Create `uvm_036_complete_fifo.sv` under Simulation Sources.
3. Paste the complete SystemVerilog source from Section 3.
4. Set `uvm_036_complete_fifo_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Enter `run 1000ns` in the Tcl Console.

The FIFO DUT and UVM testbench are included in one file.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

// Interface between the UVM driver, monitor and FIFO DUT
interface uvm_036_if;
    logic clk;
    logic reset;
    logic write_en;
    logic read_en;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic full;
    logic empty;
endinterface

// Simple synchronous FIFO DUT, depth = 4
module uvm_036_fifo_dut(uvm_036_if bus);
    localparam int DEPTH = 4;

    logic [7:0] mem [0:DEPTH-1];
    logic [1:0] wr_ptr, rd_ptr;
    logic [2:0] count;

    assign bus.full  = (count == DEPTH);
    assign bus.empty = (count == 0);

    always_ff @(posedge bus.clk) begin
        if (bus.reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            bus.data_out <= 0;
        end
        else begin
            case ({bus.write_en && !bus.full,
                   bus.read_en && !bus.empty})
                2'b10: begin
                    mem[wr_ptr] <= bus.data_in;
                    wr_ptr <= wr_ptr + 1'b1;
                    count <= count + 1'b1;
                end

                2'b01: begin
                    bus.data_out <= mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1'b1;
                    count <= count - 1'b1;
                end

                default: begin
                    count <= count;
                end
            endcase
        end
    end
endmodule

// Transaction: one FIFO write or read
class uvm_036_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_036_item)

    bit is_write;
    bit [7:0] data;

    function new(string name = "uvm_036_item");
        super.new(name);
    endfunction
endclass

// Sequence generates writes followed by reads
class uvm_036_sequence extends uvm_sequence #(uvm_036_item);
    `uvm_object_utils(uvm_036_sequence)

    function new(string name = "uvm_036_sequence");
        super.new(name);
    endfunction

    task send(bit wr, bit [7:0] value);
        uvm_036_item req;

        req = uvm_036_item::type_id::create("req");
        start_item(req);
        req.is_write = wr;
        req.data = value;
        finish_item(req);
    endtask

    task body();
        send(1, 8'h11);
        send(1, 8'h22);
        send(1, 8'h33);

        send(0, 8'h00);
        send(0, 8'h00);
        send(0, 8'h00);
    endtask
endclass

// Sequencer
class uvm_036_sequencer extends uvm_sequencer #(uvm_036_item);
    `uvm_component_utils(uvm_036_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Driver applies operations to the FIFO interface
class uvm_036_driver extends uvm_driver #(uvm_036_item);
    `uvm_component_utils(uvm_036_driver)

    virtual uvm_036_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_036_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Driver interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_036_item req;

        wait (vif.reset == 0);

        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.write_en = req.is_write;
            vif.read_en  = !req.is_write;
            vif.data_in  = req.data;

            @(posedge vif.clk);
            #2ns;

            vif.write_en = 0;
            vif.read_en  = 0;
            seq_item_port.item_done();
        end
    endtask
endclass

// Monitor publishes accepted operations to the scoreboard
class uvm_036_monitor extends uvm_component;
    `uvm_component_utils(uvm_036_monitor)

    virtual uvm_036_if vif;
    uvm_analysis_port #(uvm_036_item) analysis_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_036_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_036_item item;

        forever begin
            @(posedge vif.clk);

            if (!vif.reset &&
                vif.write_en && !vif.full) begin
                item = uvm_036_item::type_id::create("write_item");
                item.is_write = 1;
                item.data = vif.data_in;
                #1ns;
                analysis_port.write(item);
            end
            else if (!vif.reset &&
                     vif.read_en && !vif.empty) begin
                item = uvm_036_item::type_id::create("read_item");
                item.is_write = 0;
                #1ns;
                item.data = vif.data_out;
                analysis_port.write(item);
            end
        end
    endtask
endclass

// Complete agent: sequencer, driver and monitor
class uvm_036_agent extends uvm_agent;
    `uvm_component_utils(uvm_036_agent)

    uvm_036_sequencer sequencer;
    uvm_036_driver driver;
    uvm_036_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_036_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_036_driver::type_id::create("driver", this);
        monitor = uvm_036_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Scoreboard maintains the expected FIFO contents
class uvm_036_scoreboard extends uvm_component;
    `uvm_component_utils(uvm_036_scoreboard)

    uvm_analysis_imp #(uvm_036_item, uvm_036_scoreboard) analysis_export;
    bit [7:0] expected_q[$];
    int pass_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(uvm_036_item item);
        bit [7:0] expected;

        if (item.is_write) begin
            expected_q.push_back(item.data);
            `uvm_info("SCOREBOARD",
                $sformatf("WRITE accepted: 0x%02h", item.data),
                UVM_MEDIUM)
        end
        else if (expected_q.size() == 0) begin
            error_count++;
            `uvm_error("SCOREBOARD", "Read observed with empty reference queue")
        end
        else begin
            expected = expected_q.pop_front();

            if (item.data == expected) begin
                pass_count++;
                `uvm_info("SCOREBOARD",
                    $sformatf("PASS: expected=0x%02h actual=0x%02h",
                              expected, item.data), UVM_MEDIUM)
            end
            else begin
                error_count++;
                `uvm_error("SCOREBOARD",
                    $sformatf("FAIL: expected=0x%02h actual=0x%02h",
                              expected, item.data))
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SUMMARY",
            $sformatf("PASS=%0d ERROR=%0d",
                      pass_count, error_count), UVM_NONE)
    endfunction
endclass

// Environment connects agent monitor to scoreboard
class uvm_036_env extends uvm_env;
    `uvm_component_utils(uvm_036_env)

    uvm_036_agent agent;
    uvm_036_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uvm_036_agent::type_id::create("agent", this);
        scoreboard = uvm_036_scoreboard::type_id::create(
            "scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.analysis_port.connect(
            scoreboard.analysis_export);
    endfunction
endclass

// Test runs the FIFO sequence
class uvm_036_test extends uvm_test;
    `uvm_component_utils(uvm_036_test)

    uvm_036_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_036_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_036_sequence seq;

        phase.raise_objection(this);
        seq = uvm_036_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass

// Top-level testbench

module uvm_036_complete_fifo_tb;
    uvm_036_if bus();

    initial bus.clk = 0;
    always #5ns bus.clk = ~bus.clk;

    uvm_036_fifo_dut dut(bus);

    initial begin
        bus.reset = 1;
        bus.write_en = 0;
        bus.read_en = 0;
        bus.data_in = 0;

        uvm_config_db#(virtual uvm_036_if)::set(
            null, "*", "vif", bus);
    end

    // Start UVM at time 0; release reset concurrently.
    initial begin
        fork
            run_test("uvm_036_test");

            begin
                wait (bus.clk === 1'b0);
                repeat (2) @(negedge bus.clk);
                bus.reset = 0;
            end
        join
    end
endmodule

```

### 4. Expected Output

```
[SCOREBOARD] WRITE accepted: 0x11
[SCOREBOARD] WRITE accepted: 0x22
[SCOREBOARD] WRITE accepted: 0x33
[SCOREBOARD] PASS: expected=0x11 actual=0x11
[SCOREBOARD] PASS: expected=0x22 actual=0x22
[SCOREBOARD] PASS: expected=0x33 actual=0x33
[SUMMARY] PASS=3 ERROR=0
```

### 5. Key Takeaways

- The sequence generates stimulus.
- The sequencer coordinates transaction delivery.
- The driver applies operations to the DUT.
- The monitor observes accepted operations and publishes transactions.
- The environment connects the monitor to the scoreboard.
- The scoreboard maintains a reference queue and checks read data.
- The test controls the sequence and simulation objection.
- A passing summary confirms that all three FIFO reads matched the expected data.

Key takeaway: This lesson combines sequence, sequencer, driver, monitor, agent, environment, test, analysis communication, and scoreboard checking into one end-to-end FIFO verification example. The DUT is deliberately simple so you can focus on how the UVM components work together.
