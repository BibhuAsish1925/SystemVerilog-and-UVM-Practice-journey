
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_013_if(input bit clk);
    logic valid;
    logic [7:0] addr;
    logic [7:0] data;
endinterface

class uvm_013_item extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_range {
        addr inside {[8'h10:8'h1F]};
    }

    `uvm_object_utils(uvm_013_item)

    function new(string name = "uvm_013_item");
        super.new(name);
    endfunction
endclass

class uvm_013_sequence extends uvm_sequence #(uvm_013_item);
    `uvm_object_utils(uvm_013_sequence)

    function new(string name = "uvm_013_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_013_item item;

        repeat (3) begin
            item = uvm_013_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RAND", "Item randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_013_sequencer extends uvm_sequencer #(uvm_013_item);
    `uvm_component_utils(uvm_013_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_013_driver extends uvm_driver #(uvm_013_item);
    virtual uvm_013_if vif;

    `uvm_component_utils(uvm_013_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_013_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            @(negedge vif.clk);
            vif.valid = 1;
            vif.addr  = req.addr;
            vif.data  = req.data;

            `uvm_info("DRIVER",
                $sformatf("addr=0x%02h data=0x%02h",
                          req.addr, req.data), UVM_MEDIUM)

            @(negedge vif.clk);
            vif.valid = 0;
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_013_monitor extends uvm_component;
    virtual uvm_013_if vif;

    `uvm_component_utils(uvm_013_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_013_if)::get(
            this, "", "vif", vif
        ))
            `uvm_fatal("NOVIF", "Virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);

            if (vif.valid)
                `uvm_info("MONITOR",
                    $sformatf("addr=0x%02h data=0x%02h",
                              vif.addr, vif.data), UVM_MEDIUM)
        end
    endtask
endclass

class uvm_013_agent extends uvm_agent;
    uvm_013_sequencer sequencer;
    uvm_013_driver driver;
    uvm_013_monitor monitor;

    `uvm_component_utils(uvm_013_agent)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sequencer = uvm_013_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_013_driver::type_id::create("driver", this);
        monitor = uvm_013_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_013_env extends uvm_env;
    uvm_013_agent agent;

    `uvm_component_utils(uvm_013_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uvm_013_agent::type_id::create("agent", this);
    endfunction
endclass

class uvm_013_test extends uvm_test;
    uvm_013_env env;

    `uvm_component_utils(uvm_013_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_013_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_013_sequence seq;

        phase.raise_objection(this);

        seq = uvm_013_sequence::type_id::create("seq");
        `uvm_info("TEST", "Starting sequence", UVM_MEDIUM)
        seq.start(env.agent.sequencer);
        `uvm_info("TEST", "Sequence completed", UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
endclass

module uvm_013_test_tb;
    bit clk = 0;
    uvm_013_if bus(clk);

    always #5 clk = ~clk;

    initial begin
        bus.valid = 0;
        bus.addr  = 0;
        bus.data  = 0;

        uvm_config_db#(virtual uvm_013_if)::set(
            null, "*", "vif", bus
        );

        run_test("uvm_013_test");
    end
endmodule