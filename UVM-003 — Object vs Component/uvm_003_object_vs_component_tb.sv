`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Data object: no component hierarchy or component phases
class uvm_003_transaction extends uvm_object;
    `uvm_object_utils(uvm_003_transaction)

    bit [7:0] data;

    function new(string name = "transaction");
        super.new(name);
        data = 8'hA5;
    endfunction
endclass

// Structural component: has a hierarchical path and UVM phases
class uvm_003_env extends uvm_env;
    `uvm_component_utils(uvm_003_env)

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Component path: %s", get_full_name()),
            UVM_LOW)
    endfunction
endclass

class uvm_003_test extends uvm_test;
    `uvm_component_utils(uvm_003_test)

    uvm_003_env env;
    uvm_003_transaction transaction;

    function new(string name = "uvm_003_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uvm_003_env::type_id::create("env", this);
        transaction =
            uvm_003_transaction::type_id::create("transaction");

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Test component path: %s", get_full_name()),
            UVM_LOW)

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Object name: %s | Data: 0x%02h",
                transaction.get_name(), transaction.data),
            UVM_LOW)
    endfunction
endclass

module uvm_003_object_vs_component_tb;
    initial run_test("uvm_003_test");
endmodule