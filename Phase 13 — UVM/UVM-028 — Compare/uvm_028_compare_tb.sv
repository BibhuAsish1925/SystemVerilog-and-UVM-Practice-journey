`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_028_transaction extends uvm_sequence_item;
    `uvm_object_utils(uvm_028_transaction)

    bit [7:0] addr;
    bit [7:0] data;

    function new(string name = "uvm_028_transaction");
        super.new(name);
    endfunction

    virtual function bit do_compare(
        uvm_object rhs,
        uvm_comparer comparer
    );
        uvm_028_transaction rhs_tx;

        if (!$cast(rhs_tx, rhs))
            return 0;

        return super.do_compare(rhs, comparer)
            && (addr == rhs_tx.addr)
            && (data == rhs_tx.data);
    endfunction
endclass

class uvm_028_test extends uvm_test;
    `uvm_component_utils(uvm_028_test)

    uvm_028_transaction tx1;
    uvm_028_transaction tx2;
    uvm_028_transaction tx3;

    function new(string name = "uvm_028_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tx1 = uvm_028_transaction::type_id::create("tx1");
        tx2 = uvm_028_transaction::type_id::create("tx2");
        tx3 = uvm_028_transaction::type_id::create("tx3");

        tx1.addr = 8'h12;
        tx1.data = 8'hA5;

        tx2.addr = 8'h12;
        tx2.data = 8'hA5;

        tx3.addr = 8'h12;
        tx3.data = 8'hFF;

        `uvm_info("COMPARE",
            $sformatf("tx1 vs tx2: %s",
                      tx1.compare(tx2) ? "MATCH" : "MISMATCH"),
            UVM_LOW)

        `uvm_info("COMPARE",
            $sformatf("tx1 vs tx3: %s",
                      tx1.compare(tx3) ? "MATCH" : "MISMATCH"),
            UVM_LOW)
    endfunction
endclass

module uvm_028_compare_tb;
    initial
        run_test("uvm_028_test");
endmodule