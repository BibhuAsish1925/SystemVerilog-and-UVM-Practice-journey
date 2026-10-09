`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Object registration
class uvm_004_transaction extends uvm_object;
    `uvm_object_utils(uvm_004_transaction)

    bit [7:0] data;

    function new(string name = "transaction");
        super.new(name);
        data = 8'h5A;
    endfunction
endclass

// Component registration
class uvm_004_env extends uvm_env;
    `uvm_component_utils(uvm_004_env)

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MACRO_DEMO",
            $sformatf("Environment created: %s", get_full_name()),
            UVM_LOW)
    endfunction
endclass

// The test is also a component
class uvm_004_test extends uvm_test;
    `uvm_component_utils(uvm_004_test)

    uvm_004_env env;
    uvm_004_transaction transaction;

    function new(string name = "uvm_004_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uvm_004_env::type_id::create("env", this);
        transaction =
            uvm_004_transaction::type_id::create("transaction");

        `uvm_info("MACRO_DEMO",
            $sformatf("Object created: %s | Data = 0x%02h",
                transaction.get_name(), transaction.data),
            UVM_LOW)
    endfunction
endclass

module uvm_004_uvm_macros_tb;
    initial run_test("uvm_004_test");
endmodule