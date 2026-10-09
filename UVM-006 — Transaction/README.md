
# 154 — UVM-006 — Transaction

### 1. Small Introduction

A transaction represents an operation that a verification environment wants to perform on a DUT. In UVM, it is commonly implemented as a class derived from `uvm_sequence_item`.

A transaction typically contains:

- **Fields:** Store operation type, address, and data.
- **Randomization:** Uses `rand` fields and `randomize()` to generate values.
- **Methods:** Initialize, display, validate, or process transaction data.

This example randomizes three transactions and checks that each address is within the permitted range.

### 2. Vivado Flow

1. Open the existing Vivado project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. Under **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create `uvm_006_transaction.sv` as a SystemVerilog simulation source.

4. Paste the complete code below.

5. Right-click `uvm_006_transaction_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Verify that three transaction messages are printed and every address lies between `0x10` and `0x1F`.

### 3. Compact Running Code

File: `uvm_006_transaction.sv`

```systemverilog id="3y2m9w"
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_006_transaction extends uvm_sequence_item;
    `uvm_object_utils(uvm_006_transaction)

    rand bit       write;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint valid_address {
        addr inside {[8'h10:8'h1F]};
    }

    function new(string name = "uvm_006_transaction");
        super.new(name);
    endfunction

    function bit is_valid();
        return (addr inside {[8'h10:8'h1F]});
    endfunction

    function void display_transaction();
        `uvm_info("TRANSACTION",
            $sformatf("Operation=%s | Address=0x%02h | Data=0x%02h | Status=%s",
                write ? "WRITE" : "READ",
                addr, data,
                is_valid() ? "VALID" : "INVALID"),
            UVM_LOW)
    endfunction
endclass

class uvm_006_test extends uvm_test;
    `uvm_component_utils(uvm_006_test)

    uvm_006_transaction item;

    function new(string name = "uvm_006_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item = uvm_006_transaction::type_id::create("item");

        repeat (3) begin
            if (!item.randomize()) begin
                `uvm_fatal("RANDFAIL", "Transaction randomization failed")
            end
            item.display_transaction();
        end
    endfunction
endclass

module uvm_006_transaction_tb;
    initial run_test("uvm_006_test");
endmodule
```

### 4. Expected Output

Example output (randomized values can differ):

```text id="d91y6p"
UVM_INFO ... [RNTST] Running test uvm_006_test...
UVM_INFO ... [TRANSACTION] Operation=WRITE | Address=0x12 | Data=0xa5 | Status=VALID
UVM_INFO ... [TRANSACTION] Operation=READ  | Address=0x1a | Data=0x3c | Status=VALID
UVM_INFO ... [TRANSACTION] Operation=WRITE | Address=0x15 | Data=0x87 | Status=VALID
```

### 5. Key Learning Points

- `rand` declares fields that can be randomized.
- `constraint valid_address` restricts addresses to `0x10`–`0x1F`.
- `randomize()` generates new field values while respecting the constraints.
- `is_valid()` checks the address range.
- `display_transaction()` prints the transaction's fields and validity status.
- `uvm_object_utils` registers the transaction class with the UVM factory.
- `type_id::create("item")` creates the transaction object through the factory.
- This example creates and inspects transactions directly; a sequence and sequencer will be covered later.

**Verification context:** The lesson demonstrates transaction fields, constrained randomization, and user-defined methods. It does not yet drive transactions onto DUT signals.