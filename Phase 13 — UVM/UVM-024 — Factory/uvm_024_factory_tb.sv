
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_024_item extends uvm_object;
    `uvm_object_utils(uvm_024_item)

    bit [7:0] data;

    function new(string name = "uvm_024_item");
        super.new(name);
        $display("[ITEM] Constructor called: %s", name);
    endfunction
endclass

class uvm_024_test extends uvm_test;
    `uvm_component_utils(uvm_024_test)

    uvm_024_item item;

    function new(string name = "uvm_024_test",
                 uvm_component parent = null);
        super.new(name, parent);
        $display("[TEST] Constructor called: %s", name);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        $display("[FACTORY] Creating item through factory...");

        item = uvm_024_item::type_id::create("item");

        if (item == null)
            `uvm_fatal("FACTORY", "Factory creation failed")

        item.data = 8'hA5;

        $display("[FACTORY] Object created: %s, data = 0x%02h",
                 item.get_name(), item.data);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        $display("[RUN] UVM test is running.");
        #10ns;
        $display("[RUN] UVM test completed.");

        phase.drop_objection(this);
    endtask
endclass

module uvm_024_factory_tb;

    initial begin
        $display("[TOP] Simulation started.");
        run_test("uvm_024_test");
    end

endmodule