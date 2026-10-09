# 183 — UVM-034 — Virtual Sequences

### 1. Small Introduction

A virtual sequence coordinates stimulus across multiple agents by controlling multiple sequencers.

Key concepts:

- Multiple agents: Each agent handles a separate interface.
- Multiple sequencers: Each sequencer controls its agent's sequences.
- Virtual sequence: Coordinates ordinary sequences across sequencers.
- Virtual sequencer: Holds references to agent sequencers.

### 2. Vivado Flow — Step by Step

1. Open the existing UVM phase 13 project.
2. Create `uvm_034_virtual_sequences.sv` under Simulation Sources.
3. Paste the complete code below.
4. Set `uvm_034_virtual_sequences_tb` as the simulation top.
5. Run Behavioral Simulation.
6. Enter `run 1000ns` in the Tcl Console.

### 3. Compact Running Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_034_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_034_item)
    rand bit [7:0] data;
    string source;

    function new(string name = "uvm_034_item");
        super.new(name);
    endfunction
endclass

class uvm_034_seq extends uvm_sequence #(uvm_034_item);
    `uvm_object_utils(uvm_034_seq)

    function new(string name = "uvm_034_seq");
        super.new(name);
    endfunction

    task body();
        uvm_034_item req;

        repeat (3) begin
            req = uvm_034_item::type_id::create("req");
            start_item(req);
            if (!req.randomize())
                `uvm_fatal("RAND", "Randomization failed")
            req.source = get_name();
            finish_item(req);
        end
    endtask
endclass

class uvm_034_sequencer extends uvm_sequencer #(uvm_034_item);
    `uvm_component_utils(uvm_034_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_034_driver extends uvm_driver #(uvm_034_item);
    `uvm_component_utils(uvm_034_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_034_item req;

        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRIVER",
                $sformatf("%s received data=0x%02h",
                          get_full_name(), req.data), UVM_MEDIUM)
            seq_item_port.item_done();
        end
    endtask
endclass

class uvm_034_agent extends uvm_agent;
    `uvm_component_utils(uvm_034_agent)

    uvm_034_sequencer sequencer;
    uvm_034_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_034_sequencer::type_id::create("sequencer", this);
        driver = uvm_034_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

class uvm_034_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(uvm_034_virtual_sequencer)

    uvm_034_sequencer seqr_a;
    uvm_034_sequencer seqr_b;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class uvm_034_virtual_seq extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(uvm_034_virtual_seq)
    `uvm_declare_p_sequencer(uvm_034_virtual_sequencer)

    function new(string name = "uvm_034_virtual_seq");
        super.new(name);
    endfunction

    task body();
        uvm_034_seq seq_a;
        uvm_034_seq seq_b;

        seq_a = uvm_034_seq::type_id::create("seq_a");
        seq_b = uvm_034_seq::type_id::create("seq_b");

        `uvm_info("VSEQ", "Starting sequences on both agents", UVM_MEDIUM)

        fork
            seq_a.start(p_sequencer.seqr_a);
            seq_b.start(p_sequencer.seqr_b);
        join

        `uvm_info("VSEQ", "Both sequences completed", UVM_MEDIUM)
    endtask
endclass

class uvm_034_env extends uvm_env;
    `uvm_component_utils(uvm_034_env)

    uvm_034_agent agent_a;
    uvm_034_agent agent_b;
    uvm_034_virtual_sequencer vseqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_a = uvm_034_agent::type_id::create("agent_a", this);
        agent_b = uvm_034_agent::type_id::create("agent_b", this);
        vseqr = uvm_034_virtual_sequencer::type_id::create("vseqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vseqr.seqr_a = agent_a.sequencer;
        vseqr.seqr_b = agent_b.sequencer;
    endfunction
endclass

class uvm_034_test extends uvm_test;
    `uvm_component_utils(uvm_034_test)

    uvm_034_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_034_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_034_virtual_seq vseq;

        phase.raise_objection(this);
        vseq = uvm_034_virtual_seq::type_id::create("vseq");
        vseq.start(env.vseqr);
        phase.drop_objection(this);
    endtask
endclass

module uvm_034_virtual_sequences_tb;
    initial run_test("uvm_034_test");
endmodule
```

### 4. Expected Output

Your log should show both agents receiving transactions. The exact data values and ordering may vary because the transactions are randomized and the sequences run concurrently.

```
UVM_INFO ... [VSEQ] Starting sequences on both agents
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_a.driver received data=0x..
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_b.driver received data=0x..
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_a.driver received data=0x..
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_b.driver received data=0x..
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_a.driver received data=0x..
UVM_INFO ... [DRIVER] uvm_test_top.env.agent_b.driver received data=0x..
UVM_INFO ... [VSEQ] Both sequences completed
```

How to verify success:

- `agent_a` and `agent_b` each have their own sequencer and driver.
- Each ordinary sequence generates three transactions.
- The virtual sequence starts both ordinary sequences concurrently.
- The log should contain three transactions from each agent, for six total.

### 5. Key Takeaways

- A virtual sequence coordinates multiple ordinary sequences.
- A virtual sequencer stores handles to multiple agent sequencers.
- The environment connects the virtual sequencer to the agent sequencers.
- `fork...join` allows the ordinary sequences to run concurrently.
- Each agent retains its own sequencer-driver connection. \</CodeBlock>

Key takeaway: A virtual sequence provides one place to coordinate activity across multiple interfaces, while each agent continues to manage its own transactions.
