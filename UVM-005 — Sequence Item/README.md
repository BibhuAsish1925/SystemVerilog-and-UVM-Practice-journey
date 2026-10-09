# 153 — UVM-005 — Sequence Item

### 1. Small Introduction

A sequence item is a transaction object that represents one unit of stimulus for a Design Under Test (DUT). It is typically created by extending `uvm_sequence_item`.

For example, a transaction can describe a write operation using an address and data value.

Key concepts:

- `uvm_sequence_item`: Base class for sequence-driven transaction items.
- Transaction fields: Store information such as operation, address, and data.
- `uvm_object_utils`: Registers the sequence-item class with the UVM factory.
- `type_id::create()`: Creates an instance through the factory.

A sequence item is an object, not a component. It has no component hierarchy or component phases.

### 2. Vivado Flow

1. Open the existing Vivado project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. Under **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create `uvm_005_sequence_item.sv` as a SystemVerilog simulation source.

4. Paste the complete code below.

5. Right-click `uvm_005_sequence_item_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Check the Tcl Console for the transaction operation, address, and data.

### 3. Compact Running Code

File: `uvm_005_sequence_item.sv`

```systemverilog
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_005_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_005_sequence_item)

    bit        write;
    bit [7:0]  addr;
    bit [7:0]  data;

    function new(string name = "uvm_005_sequence_item");
        super.new(name);
        write = 1'b1;
        addr  = 8'h12;
        data  = 8'hA5;
    endfunction
endclass

class uvm_005_test extends uvm_test;
    `uvm_component_utils(uvm_005_test)

    uvm_005_sequence_item item;

    function new(string name = "uvm_005_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item = uvm_005_sequence_item::type_id::create("item");

        `uvm_info("SEQ_ITEM",
            $sformatf("Item: %s | Operation: %s | Address: 0x%02h | Data: 0x%02h",
                item.get_name(),
                item.write ? "WRITE" : "READ",
                item.addr, item.data),
            UVM_LOW)
    endfunction
endclass

module uvm_005_sequence_item_tb;
    initial run_test("uvm_005_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [RNTST] Running test uvm_005_test...
UVM_INFO ... [SEQ_ITEM] Item: item | Operation: WRITE | Address: 0x12 | Data: 0xa5
```

Source line numbers and message ordering may vary.

### 5. Key Learning Points

- `uvm_sequence_item` represents one transaction or unit of stimulus.
- Transaction fields describe the operation to perform.
- `uvm_object_utils` registers the class with the UVM factory.
- `type_id::create("item")` creates the sequence item.
- A sequence item is an object, not a structural component.
- In this example, the item is created and inspected directly. A sequence, sequencer, and driver will be introduced in later lessons.

**Verification context:** This example demonstrates sequence-item creation and field inspection. It does not yet drive a transaction onto DUT signals.