
# 167 — UVM-018 — TLM Communication

### 1. Small Introduction

TLM communication enables UVM components to exchange transaction objects.

The three FIFO methods demonstrated here are:

- `put(item)`: inserts a transaction into the FIFO.
- `get(item)`: removes and returns the next transaction.
- `peek(item)`: reads the next transaction without removing it.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 Vivado project.
2. Add a simulation source named `uvm_018_tlm_communication.sv`.
3. Paste the code below.
4. Set `uvm_018_tlm_communication_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Execute `run 1000ns` in the Tcl Console.
7. Confirm that `peek()` and the first `get()` return the same transaction.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_018_item extends uvm_sequence_item;
    bit [7:0] data;

    `uvm_object_utils(uvm_018_item)

    function new(string name = "uvm_018_item");
        super.new(name);
    endfunction
endclass

class uvm_018_test extends uvm_test;
    uvm_tlm_fifo #(uvm_018_item) fifo;
    uvm_018_item item;

    `uvm_component_utils(uvm_018_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        fifo = new("fifo", this, 4);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_018_item received;
        phase.raise_objection(this);

        item = uvm_018_item::type_id::create("item1");
        item.data = 8'hA5;
        fifo.put(item);
        `uvm_info("PUT", "Sent data = 0xA5", UVM_MEDIUM)

        item = uvm_018_item::type_id::create("item2");
        item.data = 8'h3C;
        fifo.put(item);
        `uvm_info("PUT", "Sent data = 0x3C", UVM_MEDIUM)

        fifo.peek(received);
        `uvm_info("PEEK",
                  $sformatf("Observed data = 0x%02h", received.data),
                  UVM_MEDIUM)

        fifo.get(received);
        `uvm_info("GET",
                  $sformatf("Received data = 0x%02h", received.data),
                  UVM_MEDIUM)

        fifo.get(received);
        `uvm_info("GET",
                  $sformatf("Received data = 0x%02h", received.data),
                  UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
endclass

module uvm_018_tlm_communication_tb;
    initial run_test("uvm_018_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [PUT] Sent data = 0xA5
UVM_INFO ... [PUT] Sent data = 0x3C
UVM_INFO ... [PEEK] Observed data = 0xA5
UVM_INFO ... [GET] Received data = 0xA5
UVM_INFO ... [GET] Received data = 0x3C
```

This example demonstrates basic TLM FIFO communication. `put()` adds transactions, `peek()` inspects the next transaction without removing it, and `get()` removes transactions in FIFO order.