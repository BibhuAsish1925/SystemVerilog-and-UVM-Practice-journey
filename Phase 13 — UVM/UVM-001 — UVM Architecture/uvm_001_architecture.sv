`timescale 1ns/1ps

interface uvm_001_if(input logic clk);
    logic valid;
    logic [7:0] data;
endinterface

module uvm_001_architecture_tb;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // 1. Transaction
    class uvm_001_item extends uvm_sequence_item;
        rand bit [7:0] data;

        `uvm_object_utils(uvm_001_item)

        function new(string name = "uvm_001_item");
            super.new(name);
        endfunction
    endclass

    // 2. Sequence: supplies three transactions
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

    // 3. Sequencer
    class uvm_001_sequencer extends uvm_sequencer #(uvm_001_item);
        `uvm_component_utils(uvm_001_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

    // 4. Driver: drives transactions onto the interface
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

    // 5. Monitor: observes interface transactions
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

    // 6. Agent: groups sequencer, driver, and monitor
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

    // 7. Scoreboard: checks observed data
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

    // 8. Environment: contains agent and scoreboard
    class uvm_001_env extends uvm_env;
        `uvm_component_utils(uvm_001_env)

        uvm_001_agent     agent;
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

    // 9. Test: starts the sequence
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

    // 10. Simulation top
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