
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_031_test extends uvm_test;
    `uvm_component_utils(uvm_031_test)

    function new(string name = "uvm_031_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        `uvm_info("REPORT", "Test started", UVM_LOW)

        `uvm_warning("REPORT", "Example warning message")

        `uvm_error("REPORT", "Example error message")

        `uvm_info("REPORT", "Test continues after the error", UVM_LOW)

        phase.drop_objection(this);
    endtask
endclass

module uvm_031_reporting_tb;
    initial
        run_test("uvm_031_test");
endmodule
