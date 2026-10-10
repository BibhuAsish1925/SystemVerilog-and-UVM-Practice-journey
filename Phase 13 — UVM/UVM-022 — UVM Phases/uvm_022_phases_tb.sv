
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_022_env extends uvm_env;
    `uvm_component_utils(uvm_022_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("PHASE", "build_phase", UVM_LOW)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("PHASE", "connect_phase", UVM_LOW)
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("PHASE", "end_of_elaboration_phase", UVM_LOW)
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("PHASE", "start_of_simulation_phase", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("PHASE", "run_phase: executing", UVM_LOW)
        #10;
    endtask

    function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("PHASE", "extract_phase", UVM_LOW)
    endfunction

    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("PHASE", "check_phase", UVM_LOW)
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("PHASE", "report_phase", UVM_LOW)
    endfunction

    function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("PHASE", "final_phase", UVM_LOW)
    endfunction
endclass


class uvm_022_test extends uvm_test;
    uvm_022_env env;

    `uvm_component_utils(uvm_022_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_022_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", "Test started", UVM_LOW)

        #30;

        `uvm_info("TEST", "Test activity completed", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass


module uvm_022_phases_tb;
    initial run_test("uvm_022_test");
endmodule