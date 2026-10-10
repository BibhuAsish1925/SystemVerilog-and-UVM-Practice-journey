`timescale 1ns/1ps

module uvm_001_smoke_test;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class uvm_001_test extends uvm_test;

        `uvm_component_utils(uvm_001_test)

        function new(string name = "uvm_001_test",
                     uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);

            `uvm_info("UVM001",
                      "UVM smoke test PASS",
                      UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass

    initial begin
        run_test("uvm_001_test");
    end

endmodule