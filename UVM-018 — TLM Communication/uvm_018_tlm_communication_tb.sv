
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_018_item extends uvm_sequence_item;
    bit [7:0] data;

    `uvm_object_utils(uvm_018_item)

    function new(string name = "uvm_018_item");
        super.new(name);
    endfunction
endclass


class uvm_018_test extends uvm_test;
    uvm_tlm_fifo #(uvm_018_item) fifo;
    uvm_018_item item;

    `uvm_component_utils(uvm_018_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo = new("fifo", this, 4);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_018_item received;

        phase.raise_objection(this);

        // PUT: insert two transactions
        item = uvm_018_item::type_id::create("item1");
        item.data = 8'hA5;
        fifo.put(item);
        `uvm_info("PUT", "Sent data = 0xA5", UVM_MEDIUM)

        item = uvm_018_item::type_id::create("item2");
        item.data = 8'h3C;
        fifo.put(item);
        `uvm_info("PUT", "Sent data = 0x3C", UVM_MEDIUM)

        // PEEK: inspect the first transaction without removing it
        fifo.peek(received);
        `uvm_info("PEEK",
                  $sformatf("Observed data = 0x%02h", received.data),
                  UVM_MEDIUM)

        // GET: remove the same first transaction
        fifo.get(received);
        `uvm_info("GET",
                  $sformatf("Received data = 0x%02h", received.data),
                  UVM_MEDIUM)

        // GET: remove the second transaction
        fifo.get(received);
        `uvm_info("GET",
                  $sformatf("Received data = 0x%02h", received.data),
                  UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
endclass


module uvm_018_tlm_communication_tb;
    initial run_test("uvm_018_test");
endmodule