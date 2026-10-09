`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

// Monitor: lowest component in this example
class uvm_002_monitor extends uvm_monitor;
    `uvm_component_utils(uvm_002_monitor)

    function new(string name = "monitor",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)
    endfunction
endclass

// Agent creates the monitor
class uvm_002_agent extends uvm_agent;
    `uvm_component_utils(uvm_002_agent)

    uvm_002_monitor monitor;

    function new(string name = "agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        monitor = uvm_002_monitor::type_id::create("monitor", this);
    endfunction
endclass

// Environment creates the agent
class uvm_002_env extends uvm_env;
    `uvm_component_utils(uvm_002_env)

    uvm_002_agent agent;

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        agent = uvm_002_agent::type_id::create("agent", this);
    endfunction
endclass

// Test creates the environment
class uvm_002_test extends uvm_test;
    `uvm_component_utils(uvm_002_test)

    uvm_002_env env;

    function new(string name = "uvm_002_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        env = uvm_002_env::type_id::create("env", this);
    endfunction
endclass

module uvm_002_component_hierarchy_tb;
    initial run_test("uvm_002_test");
endmodule