
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

interface uvm_010_if(input logic clk);
    logic valid;
    logic [7:0] addr;
    logic [7:0] data;
endinterface


class uvm_010_item extends uvm_sequence_item;
    bit [7:0] addr;
    bit [7:0] data;

    `uvm_object_utils(uvm_010_item)

    function new(string name = "uvm_010_item");
        super.new(name);
    endfunction
endclass


class uvm_010_monitor extends uvm_monitor;
    `uvm_component_utils(uvm_010_monitor)

    virtual uvm_010_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_010_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_010_item item;

        forever begin
            @(posedge vif.clk);

            if (vif.valid) begin
                item = uvm_010_item::type_id::create("item");
                item.addr = vif.addr;
                item.data = vif.data;

                `uvm_info("MONITOR",
                    $sformatf("Sampled: addr=0x%02h data=0x%02h",
                              item.addr, item.data),
                    UVM_MEDIUM)
            end
        end
    endtask
endclass


class uvm_010_env extends uvm_env;
    `uvm_component_utils(uvm_010_env)

    uvm_010_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = uvm_010_monitor::type_id::create("monitor", this);
    endfunction
endclass


class uvm_010_test extends uvm_test;
    `uvm_component_utils(uvm_010_test)

    uvm_010_env env;
    virtual uvm_010_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_010_if)::get(
                this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Test virtual interface not configured")

        env = uvm_010_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        repeat (3) begin
            @(negedge vif.clk);
            vif.valid = 1'b1;
            vif.addr = 8'h10 + $urandom_range(0, 15);
            vif.data = $urandom_range(0, 255);

            @(negedge vif.clk);
            vif.valid = 1'b0;
        end

        phase.drop_objection(this);
    endtask
endclass


module uvm_010_monitor_tb;
    bit clk = 0;

    always #5 clk = ~clk;

    uvm_010_if bus(clk);

    initial begin
        bus.valid = 0;
        bus.addr = 0;
        bus.data = 0;

        uvm_config_db#(virtual uvm_010_if)::set(
            null, "*", "vif", bus);

        run_test("uvm_010_test");
    end
endmodule