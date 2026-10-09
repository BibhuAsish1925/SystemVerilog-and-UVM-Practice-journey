# 001 — UVM-001 — UVM Architecture

### 1. Small Introduction

UVM (Universal Verification Methodology) is a SystemVerilog-based methodology for building reusable verification environments.

<table align="center">
  <tr>
    <td align="center">
      <img width="811" height="647" alt="image" src="https://github.com/user-attachments/assets/4a6fe60a-dde5-4877-a07e-3f3b3b57f8a1" /><br/>
      <small>Fig. UVM Architecture</small>
    </td>
</table>


Its main components are:

- **Test:** Selects the verification scenario.
- **Environment:** Groups verification components.
- **Agent:** Organizes components for an interface.
- **Sequencer:** Supplies transactions to the driver.
- **Driver:** Converts transactions into signal activity.
- **Monitor:** Observes interface activity.
- **Scoreboard:** Checks observed results against expected values.

Architecture flow:

Test → Environment → Agent

Inside the agent:
- Sequencer → Driver → DUT interface
- Monitor → Scoreboard (through an analysis connection)

This lesson demonstrates these components with three transactions. It is a UVM architecture exercise, not yet a complete DUT-based verification project.

### 2. Vivado Flow — Step by Step

1. Open the existing `UVM phase 13.xpr` project in Vivado 2025.1.
2. In the Sources panel, expand **Simulation Sources**.
3. Choose **Add Sources → Add or Create Simulation Sources**.
4. Click **Create File**, select `SystemVerilog`, and enter `uvm_001_architecture.sv`.
5. Open the new file, paste the complete code below, and save it.
6. Under Simulation Sources, right-click the module `uvm_001_architecture_tb` and select **Set as Top**.
7. Select **Run Simulation → Run Behavioral Simulation**.
8. Check the Tcl Console or Simulation Log for the three scoreboard PASS messages and the final architecture PASS message.

Keep the existing `uvm_001_smoke_test.sv` unchanged. The test class `uvm_001_test` is created automatically by `run_test()`; the simulation top is the module `uvm_001_architecture_tb`.

### 3. Compact Running Code

**File:** `uvm_001_architecture.sv`

```systemverilog
`timescale 1ns/1ps

interface uvm_001_if(input logic clk);
    logic valid;
    logic [7:0] data;
endinterface

module uvm_001_architecture_tb;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class uvm_001_item extends uvm_sequence_item;
        rand bit [7:0] data;
        `uvm_object_utils(uvm_001_item)

        function new(string name = "uvm_001_item");
            super.new(name);
        endfunction
    endclass

    class uvm_001_sequence extends uvm_sequence #(uvm_001_item);
        `uvm_object_utils(uvm_001_sequence)

        function new(string name = "uvm_001_sequence");
            super.new(name);
        endfunction

        task body();
            uvm_001_item req;

            for (int i = 1; i <= 3; i++) begin
                req = uvm_001_item::type_id::create(
                    $sformatf("req_%0d", i)
                );

                start_item(req);
                case (i)
                    1: req.data = 8'h11;
                    2: req.data = 8'h22;
                    3: req.data = 8'h33;
                endcase
                finish_item(req);
            end
        endtask
    endclass

    class uvm_001_sequencer extends uvm_sequencer #(uvm_001_item);
        `uvm_component_utils(uvm_001_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

    class uvm_001_driver extends uvm_driver #(uvm_001_item);
        `uvm_component_utils(uvm_001_driver)

        virtual uvm_001_if vif;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual uvm_001_if)::get(
                this, "", "vif", vif
            ))
                `uvm_fatal("NOVIF", "Driver interface not configured")
        endfunction

        task run_phase(uvm_phase phase);
            uvm_001_item req;

            forever begin
                seq_item_port.get_next_item(req);

                @(negedge vif.clk);
                vif.data  <= req.data;
                vif.valid <= 1'b1;

                @(negedge vif.clk);
                vif.valid <= 1'b0;

                seq_item_port.item_done();
            end
        endtask
    endclass

    class uvm_001_monitor extends uvm_monitor;
        `uvm_component_utils(uvm_001_monitor)

        virtual uvm_001_if vif;
        uvm_analysis_port #(uvm_001_item) ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ap = new("ap", this);

            if (!uvm_config_db#(virtual uvm_001_if)::get(
                this, "", "vif", vif
            ))
                `uvm_fatal("NOVIF", "Monitor interface not configured")
        endfunction

        task run_phase(uvm_phase phase);
            uvm_001_item observed;

            forever begin
                @(posedge vif.clk);
                if (vif.valid) begin
                    observed = uvm_001_item::type_id::create("observed");
                    observed.data = vif.data;
                    ap.write(observed);
                end
            end
        endtask
    endclass

    class uvm_001_agent extends uvm_agent;
        `uvm_component_utils(uvm_001_agent)

        uvm_001_sequencer sequencer;
        uvm_001_driver    driver;
        uvm_001_monitor   monitor;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sequencer = uvm_001_sequencer::type_id::create(
                "sequencer", this
            );
            driver = uvm_001_driver::type_id::create("driver", this);
            monitor = uvm_001_monitor::type_id::create("monitor", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.seq_item_port.connect(sequencer.seq_item_export);
        endfunction
    endclass

    class uvm_001_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(uvm_001_scoreboard)

        uvm_analysis_imp #(uvm_001_item, uvm_001_scoreboard)
            analysis_export;

        bit [7:0] expected_data [0:2] = '{8'h11, 8'h22, 8'h33};
        int unsigned count = 0;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            analysis_export = new("analysis_export", this);
        endfunction

        function void write(uvm_001_item tr);
            if (count >= 3) begin
                `uvm_error("SB", "Received extra transaction")
            end
            else if (tr.data !== expected_data[count]) begin
                `uvm_error("SB", $sformatf(
                    "Expected 0x%02h, got 0x%02h",
                    expected_data[count], tr.data
                ))
                count++;
            end
            else begin
                `uvm_info("SB", $sformatf(
                    "PASS: observed 0x%02h", tr.data
                ), UVM_LOW)
                count++;
            end
        endfunction

        function void check_phase(uvm_phase phase);
            super.check_phase(phase);
            if (count != 3)
                `uvm_error("SB", $sformatf(
                    "Expected 3 transactions, checked %0d", count
                ))
            else
                `uvm_info("UVM001",
                    "UVM architecture demonstration PASS", UVM_LOW)
        endfunction
    endclass

    class uvm_001_env extends uvm_env;
        `uvm_component_utils(uvm_001_env)

        uvm_001_agent      agent;
        uvm_001_scoreboard scoreboard;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = uvm_001_agent::type_id::create("agent", this);
            scoreboard = uvm_001_scoreboard::type_id::create(
                "scoreboard", this
            );
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.monitor.ap.connect(scoreboard.analysis_export);
        endfunction
    endclass

    class uvm_001_test extends uvm_test;
        `uvm_component_utils(uvm_001_test)

        uvm_001_env env;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = uvm_001_env::type_id::create("env", this);
        endfunction

        task run_phase(uvm_phase phase);
            uvm_001_sequence seq;

            phase.raise_objection(this);
            `uvm_info("UVM001",
                "UVM architecture demonstration started", UVM_LOW)

            seq = uvm_001_sequence::type_id::create("seq");
            seq.start(env.agent.sequencer);

            phase.drop_objection(this);
        endtask
    endclass

    bit clk = 0;
    uvm_001_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_001_if)::set(
            null, "uvm_test_top.env.agent.*", "vif", bus
        );

        run_test("uvm_001_test");
    end

endmodule
```

### 4. Expected Output

The log should contain messages similar to:

```text
UVM_INFO ... [UVM001] UVM architecture demonstration started
UVM_INFO ... [SB] PASS: observed 0x11
UVM_INFO ... [SB] PASS: observed 0x22
UVM_INFO ... [SB] PASS: observed 0x33
UVM_INFO ... [UVM001] UVM architecture demonstration PASS

--- UVM Report Summary ---
UVM_ERROR :    0
UVM_FATAL :    0
```

The exact timestamps and source line numbers can differ.

The three PASS messages confirm that the monitor observed the expected data and the scoreboard checked it.

### 5. Key Learning Points

- A **sequence** creates transactions; the **sequencer** coordinates delivery to the driver.
- The **driver** converts transactions into pin-level signals.
- The **monitor** observes the interface independently of the sequence.
- An **analysis port** publishes observed transactions to the scoreboard.
- The **scoreboard** checks actual observations against expected values.
- The **environment** connects the agent and scoreboard.
- The **test** creates the environment and starts the sequence.
- `uvm_config_db` passes the virtual interface to the driver and monitor.
- `raise_objection()` and `drop_objection()` control when the UVM run phase can finish.
