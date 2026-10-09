
# UVM-009 — Driver

### 1. Small Introduction

A UVM driver receives transaction items from a sequencer and translates them into DUT or interface activity.

Important elements:

- `uvm_driver`: base class for a driver.
- `get_next_item(req)`: retrieves the next transaction.
- `item_done()`: completes the transaction handshake.

Basic flow:

1. Sequence creates an item.
2. Sequencer coordinates item delivery.
3. Driver retrieves the item using `get_next_item()`.
4. Driver processes the item.
5. Driver calls `item_done()`.

### 2. Vivado Flow

1. Add `uvm_009_driver.sv` under Simulation Sources.
2. Paste the complete code below.
3. Set `uvm_009_driver_tb` as the simulation top.
4. Run **Run Behavioral Simulation**.
5. Execute `run 1000ns` in the Tcl Console.
6. Verify that three driver messages appear without UVM errors or fatal messages.

### 3. Compact Running Code

**File:** `uvm_009_driver.sv`

```systemverilog
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_009_item extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_range {
        addr inside {[8'h10:8'h1F]};
    }

    `uvm_object_utils(uvm_009_item)

    function new(string name = "uvm_009_item");
        super.new(name);
    endfunction
endclass

class uvm_009_sequence extends uvm_sequence #(uvm_009_item);
    `uvm_object_utils(uvm_009_sequence)

    function new(string name = "uvm_009_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_009_item item;

        repeat (3) begin
            item = uvm_009_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_009_sequencer extends uvm_sequencer #(uvm_009_item);
    `uvm_component_utils(uvm_009_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_009_driver extends uvm_driver #(uvm_009_item);
    `uvm_component_utils(uvm_009_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info("DRIVER",
                $sformatf("Processing: addr=0x%02h data=0x%02h",
                          req.addr, req.data),
                UVM_MEDIUM)

            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_009_env extends uvm_env;
    `uvm_component_utils(uvm_009_env)

    uvm_009_sequencer sequencer;
    uvm_009_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_009_sequencer::type_id::create("sequencer", this);
        driver = uvm_009_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_009_test extends uvm_test;
    `uvm_component_utils(uvm_009_test)

    uvm_009_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_009_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_009_sequence seq;

        phase.raise_objection(this);
        seq = uvm_009_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_009_driver_tb;
    initial run_test("uvm_009_test");
endmodule
```

### 4. Expected Output

Three driver messages should appear, with randomized addresses in the range `0x10`–`0x1F`.

```text
UVM_INFO ... [DRIVER] Processing: addr=0x12 data=0xA5
UVM_INFO ... [DRIVER] Processing: addr=0x1B data=0x37
UVM_INFO ... [DRIVER] Processing: addr=0x10 data=0xC2
UVM_ERROR : 0
UVM_FATAL : 0
```

Values and report formatting may vary.

### 5. Key Takeaway

- `get_next_item(req)` retrieves a transaction from the sequencer.
- The driver performs the transaction's required work.
- `item_done()` signals that the item has been processed.
- In this example, the driver prints transactions instead of driving actual DUT signals.