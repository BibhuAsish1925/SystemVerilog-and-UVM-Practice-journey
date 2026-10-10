
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_029_transaction extends uvm_sequence_item;
    `uvm_object_utils(uvm_029_transaction)

    bit [7:0] addr;
    bit [7:0] data;
    bit write;

    function new(string name = "uvm_029_transaction");
        super.new(name);
    endfunction

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("addr", addr, 8, UVM_HEX);
        printer.print_field("data", data, 8, UVM_HEX);
        printer.print_field("write", write, 1, UVM_DEC);
    endfunction
endclass

class uvm_029_test extends uvm_test;
    `uvm_component_utils(uvm_029_test)

    uvm_029_transaction tx;

    function new(string name = "uvm_029_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tx = uvm_029_transaction::type_id::create("tx");
        tx.addr = 8'h12;
        tx.data = 8'hA5;
        tx.write = 1'b1;

        `uvm_info("PRINT", "Using print()", UVM_LOW)
        tx.print();

        `uvm_info("PRINT", "Using sprint()", UVM_LOW)
        $display("%s", tx.sprint());
    endfunction
endclass

module uvm_029_print_tb;
    initial
        run_test("uvm_029_test");
endmodule
