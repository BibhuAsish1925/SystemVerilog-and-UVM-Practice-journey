`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Transaction
class uvm_007_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_007_item)

    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint valid_addr {
        addr inside {[8'h10:8'h1F]};
    }

    function new(string name = "uvm_007_item");
        super.new(name);
    endfunction
endclass

// Sequence: body() generates three items
class uvm_007_sequence extends uvm_sequence #(uvm_007_item);
    `uvm_object_utils(uvm_007_sequence)

    function new(string name = "uvm_007_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_007_item item;

        repeat (3) begin
            item = uvm_007_item::type_id::create("item");

            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Item randomization failed")
            finish_item(item);
        end
    endtask
endclass

// Sequencer transfers items from sequence to driver
class uvm_007_sequencer extends uvm_sequencer #(uvm_007_item);
    `uvm_component_utils(uvm_007_sequencer)

    function new(string name = "uvm_007_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

// Driver receives and prints each item
class uvm_007_driver extends uvm_driver #(uvm_007_item);
    `uvm_component_utils(uvm_007_driver)

    function new(string name = "uvm_007_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRIVER",
                $sformatf("Received item: addr=0x%02h data=0x%02h",
                    req.addr, req.data),
                UVM_LOW)
            seq_item_port.item_done();
        end
    endtask
endclass

// Environment connects sequencer and driver
class uvm_007_env extends uvm_env;
    `uvm_component_utils(uvm_007_env)

    uvm_007_sequencer sequencer;
    uvm_007_driver driver;

    function new(string name = "uvm_007_env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_007_sequencer::type_id::create("sequencer", this);
        driver = uvm_007_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Test starts the sequence
class uvm_007_test extends uvm_test;
    `uvm_component_utils(uvm_007_test)

    uvm_007_env env;

    function new(string name = "uvm_007_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_007_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_007_sequence seq;

        phase.raise_objection(this);
        seq = uvm_007_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_007_sequence_tb;
    initial run_test("uvm_007_test");
endmodule