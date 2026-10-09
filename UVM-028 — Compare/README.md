# 177 — UVM-028 — Compare&#x20;

## 1. Introduction

UVM provides `compare()` to determine whether two objects contain equivalent field values. The `do_compare()` method allows a class to implement custom comparison logic.

- `compare()` invokes UVM's comparison mechanism.
- `do_compare()` defines custom field-by-field comparison.
- `$cast()` checks whether the source object is compatible with the expected class.

## 2. Complete Runnable Code

```
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
```

## 3. Expected Output

```
UVM_INFO ... [COMPARE] tx1 vs tx2: MATCH
UVM_INFO ... [COMPARE] tx1 vs tx3: MISMATCH
```

## 4. Vivado Usage

1. Create `uvm_028_compare.sv` under Simulation Sources.
2. Set `uvm_028_compare_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Verify the MATCH and MISMATCH results.

## 5. Key Takeaways

- `compare()` returns a Boolean comparison result.
- `do_compare()` implements custom comparison logic.
- `$cast()` checks the type of the compared object.
- Every field that matters to transaction equivalence should be included in the comparison.
