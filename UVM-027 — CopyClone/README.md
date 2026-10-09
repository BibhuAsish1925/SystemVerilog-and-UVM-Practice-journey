
# 176 — UVM-027 — Copy/Clone

## 1. Introduction

UVM provides methods to create and duplicate transaction objects. The three important methods are `create()`, `copy()`, and `clone()`.

- **`create()`** creates an object through the UVM factory.
- **`copy()`** copies field values from a source object into an existing destination object.
- **`clone()`** creates a new object and copies the source object's contents into it.

For automatic copying of custom fields, register the fields using UVM field macros or implement the appropriate `do_copy()` method.

## 2. Important Methods

### Create

```systemverilog
original = uvm_027_transaction::type_id::create("original");
```

Creates a transaction through the UVM factory.

### Copy

```systemverilog
copied = uvm_027_transaction::type_id::create("copied");
copied.copy(original);
```

Copies the registered field values from `original` into the existing `copied` object.

### Clone

```systemverilog
cloned = uvm_027_transaction::type_id::create("cloned");
cloned.copy(original);
```

Creates a separate object and copies the original transaction's registered fields into it. This explicit approach demonstrates the same essential operations as cloning for this example.

## 3. Complete Runnable Code

```systemverilog
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

        // Copy into an existing object
        copied = uvm_027_transaction::type_id::create("copied");
        copied.copy(original);

        // Create a separate object and copy the fields
        cloned = uvm_027_transaction::type_id::create("cloned");
        cloned.copy(original);

        `uvm_info("COPY",
            $sformatf("Original: addr=0x%02h data=0x%02h",
                      original.addr, original.data), UVM_LOW)

        `uvm_info("COPY",
            $sformatf("Copied:   addr=0x%02h data=0x%02h",
                      copied.addr, copied.data), UVM_LOW)

        `uvm_info("CLONE",
            $sformatf("Cloned:   addr=0x%02h data=0x%02h",
                      cloned.addr, cloned.data), UVM_LOW)

        // Verify that the cloned object's data is independent
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
```

## 4. Expected Output

```text
UVM_INFO ... [COPY] Original: addr=0x12 data=0xa5
UVM_INFO ... [COPY] Copied:   addr=0x12 data=0xa5
UVM_INFO ... [CLONE] Cloned:   addr=0x12 data=0xa5
UVM_INFO ... [CLONE] After modifying clone: original=0xa5 clone=0xff
```

### Verified Vivado Results

- Original transaction: address `0x12`, data `0xA5`.
- Copied transaction: address `0x12`, data `0xA5`.
- Cloned transaction: address `0x12`, data `0xA5`.
- After modifying the clone, original data remains `0xA5`.
- UVM warnings: `0`
- UVM errors: `0`
- UVM fatals: `0`

## 5. Vivado Usage

1. Create `uvm_027_copy_clone_tb.sv` under Simulation Sources.
2. Set `uvm_027_copy_clone_tb` as the simulation top.
3. Run **Run Behavioral Simulation**.
4. Enter `run 1000ns` in the Tcl Console.
5. Verify that the copied and cloned values initially match the original.
6. Confirm that changing the clone does not change the original object's data.

## 6. Key Takeaways

- `create()` constructs an object through the factory.
- `copy()` copies registered fields into an existing object.
- `clone()` uses factory creation and copying in the standard UVM implementation.
- Factory creation and field copying are distinct operations.
- The example demonstrates independent scalar fields; nested objects may require explicit deep-copy handling.
