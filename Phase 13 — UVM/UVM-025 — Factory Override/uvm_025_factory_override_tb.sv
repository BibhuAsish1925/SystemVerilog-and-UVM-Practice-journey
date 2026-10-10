
`include "uvm_macros.svh"
import uvm_pkg::*;

// Original transaction
class uvm_025_base_item extends uvm_object;
    `uvm_object_utils(uvm_025_base_item)

    function new(string name = "uvm_025_base_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "BASE";
    endfunction
endclass

// Replacement for type override
class uvm_025_type_item extends uvm_025_base_item;
    `uvm_object_utils(uvm_025_type_item)

    function new(string name = "uvm_025_type_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "TYPE_REPLACEMENT";
    endfunction
endclass

// Replacement for instance override
class uvm_025_inst_item extends uvm_025_base_item;
    `uvm_object_utils(uvm_025_inst_item)

    function new(string name = "uvm_025_inst_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "INSTANCE_REPLACEMENT";
    endfunction
endclass

class uvm_025_test extends uvm_test;
    `uvm_component_utils(uvm_025_test)

    uvm_025_base_item type_item;
    uvm_025_base_item normal_item;
    uvm_025_base_item inst_item;

    function new(string name = "uvm_025_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Demonstrate instance override first, before type override.
        uvm_025_base_item::type_id::set_inst_override(
            uvm_025_inst_item::get_type(),
            "inst_item",
            this
        );

        // Replace the base type for other factory creations.
        uvm_025_base_item::type_id::set_type_override(
            uvm_025_type_item::get_type()
        );

        type_item = uvm_025_base_item::type_id::create(
            "type_item", this
        );

        normal_item = uvm_025_base_item::type_id::create(
            "normal_item", this
        );

        inst_item = uvm_025_base_item::type_id::create(
            "inst_item", this
        );

        `uvm_info("TYPE_OVERRIDE",
            $sformatf("type_item = %s", type_item.get_kind()),
            UVM_MEDIUM)

        `uvm_info("TYPE_OVERRIDE",
            $sformatf("normal_item = %s", normal_item.get_kind()),
            UVM_MEDIUM)

        `uvm_info("INSTANCE_OVERRIDE",
            $sformatf("inst_item = %s", inst_item.get_kind()),
            UVM_MEDIUM)
    endfunction
endclass

module uvm_025_factory_override_tb;
    initial begin
        $display("[TOP] Starting UVM-025 Factory Override");
        run_test("uvm_025_test");
    end
endmodule