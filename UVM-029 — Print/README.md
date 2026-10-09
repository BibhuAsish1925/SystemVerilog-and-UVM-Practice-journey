# 178 — UVM-029 — Print&#x20;

## 1. Introduction

UVM provides object-printing methods for transaction inspection and debugging.

- `print()` displays an object's formatted contents.
- `sprint()` returns the formatted contents as a string.
- `do_print()` customizes how an object prints its fields.

## 2. Complete Runnable Code

```
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
```

## 3. Expected Output

The printer output should contain these field values:

```
addr  0x12
data  0xA5
write 1
```

Both `print()` and `sprint()` should display the same transaction fields, though their output formatting may vary.

## 4. Vivado Usage

1. Create `uvm_029_print.sv` under Simulation Sources.
2. Set `uvm_029_print_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Verify the address, data, and write fields in both outputs.

## 5. Key Takeaways

- `print()` displays formatted object contents.
- `sprint()` returns formatted contents as a string.
- `do_print()` defines custom field-printing behavior.
- `uvm_printer` provides methods such as `print_field()`.
- Printing helps debug transaction values during verification.

Next concept: UVM-030 — `record()` and transaction recording.