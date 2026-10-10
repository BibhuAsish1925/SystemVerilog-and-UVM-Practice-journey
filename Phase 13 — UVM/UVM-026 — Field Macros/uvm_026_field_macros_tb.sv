
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [1:0] {
    IDLE, WRITE, READ, DONE
} uvm_026_operation_e;

// Nested object
class uvm_026_details extends uvm_object;
    `uvm_object_utils_begin(uvm_026_details)
        `uvm_field_int(id, UVM_DEFAULT)
    `uvm_object_utils_end

    int unsigned id;

    function new(string name = "uvm_026_details");
        super.new(name);
    endfunction
endclass

// Main object demonstrating four field types
class uvm_026_transaction extends uvm_object;
    `uvm_object_utils_begin(uvm_026_transaction)
        `uvm_field_int(data, UVM_DEFAULT)
        `uvm_field_enum(uvm_026_operation_e, operation, UVM_DEFAULT)
        `uvm_field_array_int(payload, UVM_DEFAULT)
        `uvm_field_object(details, UVM_DEFAULT)
    `uvm_object_utils_end

    bit [7:0] data;
    uvm_026_operation_e operation;
    bit [7:0] payload[];
    uvm_026_details details;

    function new(string name = "uvm_026_transaction");
        super.new(name);
    endfunction
endclass

class uvm_026_test extends uvm_test;
    `uvm_component_utils(uvm_026_test)

    uvm_026_transaction tx;

    function new(string name = "uvm_026_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tx = uvm_026_transaction::type_id::create("tx");
        tx.data = 8'hA5;
        tx.operation = WRITE;

        tx.payload = new[3];
        tx.payload[0] = 8'h11;
        tx.payload[1] = 8'h22;
        tx.payload[2] = 8'h33;

        tx.details = uvm_026_details::type_id::create("details");
        tx.details.id = 25;

        `uvm_info("FIELDS", "Printing transaction fields", UVM_LOW)
        tx.print();
    endfunction
endclass

module uvm_026_field_macros_tb;
    initial
        run_test("uvm_026_test");
endmodule
