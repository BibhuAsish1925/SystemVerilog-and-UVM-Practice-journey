`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Transaction data for one operation
class uvm_005_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_005_sequence_item)

    bit        write;
    bit [7:0]  addr;
    bit [7:0]  data;

    function new(string name = "uvm_005_sequence_item");
        super.new(name);
        write = 1'b1;
        addr  = 8'h12;
        data  = 8'hA5;
    endfunction
endclass

class uvm_005_test extends uvm_test;
    `uvm_component_utils(uvm_005_test)

    uvm_005_sequence_item item;

    function new(string name = "uvm_005_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item = uvm_005_sequence_item::type_id::create("item");

        `uvm_info("SEQ_ITEM",
            $sformatf("Item: %s | Operation: %s | Address: 0x%02h | Data: 0x%02h",
                item.get_name(),
                item.write ? "WRITE" : "READ",
                item.addr, item.data),
            UVM_LOW)
    endfunction
endclass

module uvm_005_sequence_item_tb;
    initial run_test("uvm_005_test");
endmodule