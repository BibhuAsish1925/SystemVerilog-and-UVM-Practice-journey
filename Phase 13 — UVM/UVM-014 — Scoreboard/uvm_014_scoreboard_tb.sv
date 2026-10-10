
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_014_if(input bit clk);
    logic valid;
    logic [7:0] data_in;
    logic [7:0] data_out;

    assign data_out = ~data_in;
endinterface

class uvm_014_item extends uvm_sequence_item;
    rand bit [7:0] data_in;
    bit [7:0] actual_data;

    `uvm_object_utils(uvm_014_item)

    function new(string name = "uvm_014_item");
        super.new(name);
    endfunction
endclass

class uvm_014_sequence extends uvm_sequence #(uvm_014_item);
    `uvm_object_utils(uvm_014_sequence)

    function new(string name = "uvm_014_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_014_item item;

        repeat (3) begin
            item = uvm_014_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RAND", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_014_sequencer extends uvm_sequencer #(uvm_014_item);
    `uvm_component_utils(uvm_014_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_014_driver extends uvm_driver #(uvm_014_item);
    virtual uvm_014_if vif;

    `uvm_component_utils(uvm_014_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_014_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.data_in = req.data_in;
            vif.valid   = 1;

            `uvm_info("DRIVER",
                $sformatf("Driving data=0x%02h", req.data_in),
                UVM_MEDIUM)

            @(negedge vif.clk);
            vif.valid = 0;
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_014_monitor extends uvm_component;
    virtual uvm_014_if vif;
    uvm_analysis_port #(uvm_014_item) analysis_port;

    `uvm_component_utils(uvm_014_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_014_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_014_item observed;

        forever begin
            @(posedge vif.clk);

            if (vif.valid) begin
                observed = uvm_014_item::type_id::create("observed");
                observed.data_in = vif.data_in;
                observed.actual_data = vif.data_out;

                `uvm_info("MONITOR",
                    $sformatf("Input=0x%02h Output=0x%02h",
                        observed.data_in, observed.actual_data),
                    UVM_MEDIUM)

                analysis_port.write(observed);
            end
        end
    endtask
endclass

class uvm_014_scoreboard extends uvm_scoreboard;
    uvm_analysis_imp #(uvm_014_item, uvm_014_scoreboard) analysis_imp;
    int pass_count = 0;
    int error_count = 0;

    `uvm_component_utils(uvm_014_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    function void write(uvm_014_item item);
        bit [7:0] expected_data;

        expected_data = ~item.data_in;

        if (item.actual_data === expected_data) begin
            pass_count++;
            `uvm_info("SCOREBOARD",
                $sformatf("PASS: expected=0x%02h actual=0x%02h",
                    expected_data, item.actual_data),
                UVM_MEDIUM)
        end
        else begin
            error_count++;
            `uvm_error("SCOREBOARD",
                $sformatf("FAIL: expected=0x%02h actual=0x%02h",
                    expected_data, item.actual_data))
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SUMMARY",
            $sformatf("PASS=%0d ERROR=%0d",
                pass_count, error_count), UVM_NONE)
    endfunction
endclass

class uvm_014_env extends uvm_env;
    uvm_014_sequencer sequencer;
    uvm_014_driver driver;
    uvm_014_monitor monitor;
    uvm_014_scoreboard scoreboard;

    `uvm_component_utils(uvm_014_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_014_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_014_driver::type_id::create("driver", this);
        monitor = uvm_014_monitor::type_id::create("monitor", this);
        scoreboard = uvm_014_scoreboard::type_id::create(
            "scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.analysis_port.connect(scoreboard.analysis_imp);
    endfunction
endclass

class uvm_014_test extends uvm_test;
    uvm_014_env env;

    `uvm_component_utils(uvm_014_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_014_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_014_sequence seq;

        phase.raise_objection(this);
        seq = uvm_014_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_014_scoreboard_tb;
    bit clk = 0;
    uvm_014_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.data_in = 0;

        uvm_config_db#(virtual uvm_014_if)::set(
            null, "*", "vif", bus
        );

        run_test("uvm_014_test");
    end
endmodule