`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Transaction fields, randomization, and methods
class uvm_006_transaction extends uvm_sequence_item;
    `uvm_object_utils(uvm_006_transaction)

    rand bit       write;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint valid_address {
        addr inside {[8'h10:8'h1F]};
    }

    function new(string name = "uvm_006_transaction");
        super.new(name);
    endfunction

    function bit is_valid();
        return (addr inside {[8'h10:8'h1F]});
    endfunction

    function void display_transaction();
        `uvm_info("TRANSACTION",
            $sformatf("Operation=%s | Address=0x%02h | Data=0x%02h | Status=%s",
                write ? "WRITE" : "READ",
                addr, data,
                is_valid() ? "VALID" : "INVALID"),
            UVM_LOW)
    endfunction
endclass

class uvm_006_test extends uvm_test;
    `uvm_component_utils(uvm_006_test)

    uvm_006_transaction item;

    function new(string name = "uvm_006_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item = uvm_006_transaction::type_id::create("item");

        repeat (3) begin
            if (!item.randomize()) begin
                `uvm_fatal("RANDFAIL", "Transaction randomization failed")
            end
            item.display_transaction();
        end
    endfunction
endclass

module uvm_006_transaction_tb;
    initial run_test("uvm_006_test");
endmodule