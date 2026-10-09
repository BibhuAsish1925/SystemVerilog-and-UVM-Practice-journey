
# 157 — UVM-008 — Sequencer

### Introduction

A UVM sequencer coordinates the transfer of sequence items from a sequence to a driver.

- `uvm_sequence` generates transaction items.
- `uvm_sequencer` manages item delivery.
- `uvm_driver` retrieves and processes items.

The sequencer is parameterized by the item type:

```systemverilog
uvm_sequencer #(uvm_008_item)
```

The driver and sequencer are connected through TLM ports:

```systemverilog
driver.seq_item_port.connect(sequencer.seq_item_export);
```

### Complete Running Code

**File:** `uvm_008_sequencer.sv`

```systemverilog
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_008_item extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [7:0] data;

    constraint addr_range {
        addr inside {[8'h10:8'h1F]};
    }

    `uvm_object_utils(uvm_008_item)

    function new(string name = "uvm_008_item");
        super.new(name);
    endfunction
endclass

class uvm_008_sequence extends uvm_sequence #(uvm_008_item);
    `uvm_object_utils(uvm_008_sequence)

    function new(string name = "uvm_008_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_008_item item;

        repeat (3) begin
            item = uvm_008_item::type_id::create("item");
            start_item(item);

            if (!item.randomize())
                `uvm_fatal("RANDFAIL", "Item randomization failed")

            finish_item(item);
        end
    endtask
endclass

class uvm_008_sequencer extends uvm_sequencer #(uvm_008_item);
    `uvm_component_utils(uvm_008_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_008_driver extends uvm_driver #(uvm_008_item);
    `uvm_component_utils(uvm_008_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);

            `uvm_info("DRIVER",
                $sformatf("Received item: addr=0x%02h data=0x%02h",
                          req.addr, req.data),
                UVM_MEDIUM)

            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_008_env extends uvm_env;
    `uvm_component_utils(uvm_008_env)

    uvm_008_sequencer sequencer;
    uvm_008_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_008_sequencer::type_id::create("sequencer", this);
        driver = uvm_008_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_008_test extends uvm_test;
    `uvm_component_utils(uvm_008_test)

    uvm_008_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_008_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_008_sequence seq;

        phase.raise_objection(this);
        seq = uvm_008_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask
endclass

module uvm_008_sequencer_tb;
    initial run_test("uvm_008_test");
endmodule
```

### Expected Output

Three driver messages are expected. Address values remain in the range `0x10`–`0x1F`; data values are randomized.

```text
[DRIVER] Received item: addr=0x12 data=0xA5
[DRIVER] Received item: addr=0x1B data=0x37
[DRIVER] Received item: addr=0x10 data=0xC2
UVM_WARNING : 0
UVM_ERROR   : 0
UVM_FATAL   : 0
```

The values are illustrative and will vary between runs.

### Vivado Usage

1. Add `uvm_008_sequencer.sv` as a simulation source.
2. Set `uvm_008_sequencer_tb` as the simulation top.
3. Run **Run Behavioral Simulation**.
4. Execute `run 1000ns` in the Tcl Console.
5. Verify that three items are received and there are no UVM errors or fatal messages.

### Key Takeaway

The sequence creates transactions, the sequencer coordinates their delivery, and the driver retrieves them through `get_next_item()` and completes each transfer using `item_done()`.
