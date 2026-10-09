
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_021_test extends uvm_test;
    `uvm_component_utils(uvm_021_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("OBJECTION", "Objection raised", UVM_MEDIUM)

        repeat (3) begin
            #10;
            `uvm_info("TEST", "Transaction completed", UVM_MEDIUM)
        end

        `uvm_info("OBJECTION", "Dropping objection", UVM_MEDIUM)
        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info("REPORT", "Run phase completed", UVM_MEDIUM)
    endfunction
endclass


module uvm_021_objections_tb;
    initial run_test("uvm_021_test");
endmodule