
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_023_test extends uvm_test;
    `uvm_component_utils(uvm_023_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Reset: initializing DUT", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask

    task configure_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Configure: applying settings", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask

    task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Main: running stimulus", UVM_LOW)
        #20;
        `uvm_info("RUNTIME", "Main: stimulus completed", UVM_LOW)
        phase.drop_objection(this);
    endtask

    task shutdown_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("RUNTIME", "Shutdown: completing test", UVM_LOW)
        #10;
        phase.drop_objection(this);
    endtask
endclass


module uvm_023_runtime_phases_tb;
    initial run_test("uvm_023_test");
endmodule