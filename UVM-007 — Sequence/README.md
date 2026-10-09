# 155 — UVM-007 — Sequence

### 1. Small Introduction

A UVM sequence generates transaction items that describe stimulus for a DUT. It typically extends `uvm_sequence` and works with a sequencer to deliver items to a driver.

Key concepts:

- **Sequence:** Defines which transactions to generate and in what order.
- **`body()`:** Task containing the main sequence execution.
- **`start_item(item)`:** Requests permission to send a sequence item.
- **`finish_item(item)`:** Completes the item handoff to the sequencer.
- **`randomize()`:** Generates values for randomized transaction fields.

The sequence follows this flow:

1. Create a sequence item.
2. Call `start_item(item)`.
3. Randomize the item.
4. Call `finish_item(item)`.
5. Repeat to generate more items.

### 2. Vivado Flow

1. Open the existing Vivado project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. Under **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create `uvm_007_sequence.sv` as a SystemVerilog simulation source.

4. Paste the complete code below.

5. Right-click `uvm_007_sequence_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Verify that the driver receives three randomized items.

### 3. Compact Running Code

File: `uvm_007_sequence.sv`

```systemverilog
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_007_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_007_item)

    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint valid_addr {
        addr inside {[8'h10:8'h1F]};
    }

    function new(string name = "uvm_007_item");
        super.new(name);
    endfunction
endclass

class uvm_007_sequence extends uvm_sequence #(uvm_007_item);
    `uvm_object_utils(uvm_007_sequence)

    function new(string name = "uvm_007_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_007_item item;

        repeat (3) begin
            item = uvm_007_item::type_id::create("item");

            start_item(item);
            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Item randomization failed")
            finish_item(item);
        end
    endtask
endclass

class uvm_007_sequencer extends uvm_sequencer #(uvm_007_item);
    `uvm_component_utils(uvm_007_sequencer)

    function new(string name = "uvm_007_sequencer",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass

class uvm_007_driver extends uvm_driver #(uvm_007_item);
    `uvm_component_utils(uvm_007_driver)

    function new(string name = "uvm_007_driver",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRIVER",
                $sformatf("Received item: addr=0x%02h data=0x%02h",
                    req.addr, req.data),
                UVM_LOW)
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_007_env extends uvm_env;
    `uvm_component_utils(uvm_007_env)

    uvm_007_sequencer sequencer;
    uvm_007_driver driver;

    function new(string name = "uvm_007_env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_007_sequencer::type_id::create("sequencer", this);
        driver = uvm_007_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_007_test extends uvm_test;
    `uvm_component_utils(uvm_007_test)

    uvm_007_env env;

    function new(string name = "uvm_007_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_007_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_007_sequence seq;

        phase.raise_objection(this);
        seq = uvm_007_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_007_sequence_tb;
    initial run_test("uvm_007_test");
endmodule
```

### 4. Expected Output

Example output; randomized values may differ:

```text
UVM_INFO ... [RNTST] Running test uvm_007_test...
UVM_INFO ... [DRIVER] Received item: addr=0x12 data=0xa5
UVM_INFO ... [DRIVER] Received item: addr=0x1a data=0x3c
UVM_INFO ... [DRIVER] Received item: addr=0x15 data=0x87
```

### 5. Key Learning Points

- `uvm_sequence` defines stimulus generation.
- `body()` contains the sequence's main execution.
- `start_item()` requests permission to send an item.
- `randomize()` generates transaction values.
- `finish_item()` completes the sequence-item handoff.
- `seq.start(sequencer)` starts the sequence on a sequencer.
- The sequencer transfers items to the connected driver.
- The driver calls `get_next_item()` and then `item_done()` to complete each handoff.
- The test raises an objection while the sequence runs and drops it after completion.

**Verification context:** This example demonstrates sequence execution and transaction handoff through a sequencer to a driver. The driver prints the transactions; it does not drive DUT signals yet.