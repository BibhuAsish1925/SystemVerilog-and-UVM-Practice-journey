
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_027_transaction extends uvm_sequence_item;
    `uvm_object_utils_begin(uvm_027_transaction)
        `uvm_field_int(addr, UVM_DEFAULT)
        `uvm_field_int(data, UVM_DEFAULT)
    `uvm_object_utils_end

    bit [7:0] addr;
    bit [7:0] data;

    function new(string name = "uvm_027_transaction");
        super.new(name);
    endfunction
endclass

class uvm_027_test extends uvm_test;
    `uvm_component_utils(uvm_027_test)

    uvm_027_transaction original;
    uvm_027_transaction copied;
    uvm_027_transaction cloned;

    function new(string name = "uvm_027_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create and initialize the original
        original = uvm_027_transaction::type_id::create("original");
        original.addr = 8'h12;
        original.data = 8'hA5;

        // Create an existing destination, then copy into it
        copied = uvm_027_transaction::type_id::create("copied");
        copied.copy(original);

        // Create a new object through the factory
        cloned = uvm_027_transaction::type_id::create("cloned");

        // Copy the original transaction into it
        cloned.copy(original);

        `uvm_info("COPY",
            $sformatf("Original: addr=0x%02h data=0x%02h",
                      original.addr, original.data), UVM_LOW)

        `uvm_info("COPY",
            $sformatf("Copied:   addr=0x%02h data=0x%02h",
                      copied.addr, copied.data), UVM_LOW)

        if (cloned == null)
            `uvm_fatal("CLONE", "Clone returned null")

        `uvm_info("CLONE",
            $sformatf("Cloned:   addr=0x%02h data=0x%02h",
                      cloned.addr, cloned.data), UVM_LOW)

        // Prove that the cloned object is independent
        cloned.data = 8'hFF;

        `uvm_info("CLONE",
            $sformatf("After modifying clone: original=0x%02h clone=0x%02h",
                      original.data, cloned.data), UVM_LOW)
    endfunction
endclass

module uvm_027_copy_clone_tb;
    initial
        run_test("uvm_027_test");
endmodule
