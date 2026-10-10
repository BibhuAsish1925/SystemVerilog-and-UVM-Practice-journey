
`include "uvm_macros.svh"
import uvm_pkg::*;

// Transaction
class uvm_033_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_033_item)

    bit [7:0] data;
    string source;

    function new(string name = "uvm_033_item");
        super.new(name);
    endfunction
endclass

// Low-priority sequence
class uvm_033_low_seq extends uvm_sequence #(uvm_033_item);
    `uvm_object_utils(uvm_033_low_seq)

    function new(string name = "uvm_033_low_seq");
        super.new(name);
    endfunction

    task body();
        uvm_033_item req;

        repeat (3) begin
            req = uvm_033_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("RAND", "Item randomization failed")
            req.source = "LOW";
            finish_item(req);
        end
    endtask
endclass

// High-priority sequence
class uvm_033_high_seq extends uvm_sequence #(uvm_033_item);
    `uvm_object_utils(uvm_033_high_seq)

    function new(string name = "uvm_033_high_seq");
        super.new(name);
    endfunction

    task body();
        uvm_033_item req;

        repeat (3) begin
            req = uvm_033_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("RAND", "Item randomization failed")
            req.source = "HIGH";
            finish_item(req);
        end
    endtask
endclass

// Sequencer
class uvm_033_sequencer extends uvm_sequencer #(uvm_033_item);
    `uvm_component_utils(uvm_033_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
        set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
    endfunction
endclass

// Driver
class uvm_033_driver extends uvm_driver #(uvm_033_item);
    `uvm_component_utils(uvm_033_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_033_item req;

        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRIVER",
                $sformatf("Source=%s Data=0x%02h",
                          req.source, req.data), UVM_MEDIUM)
            seq_item_port.item_done();
        end
    endtask
endclass

// Environment
class uvm_033_env extends uvm_env;
    `uvm_component_utils(uvm_033_env)

    uvm_033_sequencer sequencer;
    uvm_033_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_033_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_033_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Test runs both sequences on the same sequencer
class uvm_033_test extends uvm_test;
    `uvm_component_utils(uvm_033_test)

    uvm_033_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_033_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_033_high_seq high_seq;
        uvm_033_low_seq low_seq;

        phase.raise_objection(this);

        high_seq = uvm_033_high_seq::type_id::create("high_seq");
        low_seq  = uvm_033_low_seq::type_id::create("low_seq");

        fork
            high_seq.start(env.sequencer, null, 100);
            low_seq.start(env.sequencer, null, 10);
        join

        phase.drop_objection(this);
    endtask
endclass

module uvm_033_sequence_arbitration_tb;
    initial run_test("uvm_033_test");
endmodule
