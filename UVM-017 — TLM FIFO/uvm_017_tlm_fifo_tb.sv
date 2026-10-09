
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_017_item extends uvm_sequence_item;
    rand bit [7:0] data;

    `uvm_object_utils(uvm_017_item)

    function new(string name = "uvm_017_item");
        super.new(name);
    endfunction
endclass


class uvm_017_producer extends uvm_component;
    uvm_tlm_fifo #(uvm_017_item) fifo;

    `uvm_component_utils(uvm_017_producer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_017_item item;

        phase.raise_objection(this);

        repeat (3) begin
            item = uvm_017_item::type_id::create("item");

            if (!item.randomize())
                `uvm_fatal("RAND", "Item randomization failed")

            fifo.put(item);
            `uvm_info("PRODUCER",
                      $sformatf("Sent data = 0x%02h", item.data),
                      UVM_MEDIUM)
        end

        phase.drop_objection(this);
    endtask
endclass


class uvm_017_consumer extends uvm_component;
    uvm_tlm_fifo #(uvm_017_item) fifo;

    `uvm_component_utils(uvm_017_consumer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_017_item item;

        repeat (3) begin
            fifo.get(item);
            `uvm_info("CONSUMER",
                      $sformatf("Received data = 0x%02h", item.data),
                      UVM_MEDIUM)
        end
    endtask
endclass


class uvm_017_env extends uvm_env;
    uvm_tlm_fifo #(uvm_017_item) fifo;
    uvm_017_producer producer;
    uvm_017_consumer consumer;

    `uvm_component_utils(uvm_017_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        fifo = new("fifo", this, 4);
        producer = uvm_017_producer::type_id::create("producer", this);
        consumer = uvm_017_consumer::type_id::create("consumer", this);

        producer.fifo = fifo;
        consumer.fifo = fifo;
    endfunction
endclass


class uvm_017_test extends uvm_test;
    uvm_017_env env;

    `uvm_component_utils(uvm_017_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_017_env::type_id::create("env", this);
    endfunction
endclass


module uvm_017_tlm_fifo_tb;
    initial run_test("uvm_017_test");
endmodule