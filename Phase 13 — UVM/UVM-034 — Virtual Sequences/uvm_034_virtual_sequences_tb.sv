
`include "uvm_macros.svh"
import uvm_pkg::*;

// Transaction shared by both agents
class uvm_034_item extends uvm_sequence_item;
    `uvm_object_utils(uvm_034_item)

    rand bit [7:0] data;
    string source;

    function new(string name = "uvm_034_item");
        super.new(name);
    endfunction
endclass

// Ordinary sequence used by each agent
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

// Sequencer for each agent
class uvm_034_sequencer extends uvm_sequencer #(uvm_034_item);
    `uvm_component_utils(uvm_034_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Driver for each agent
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
                          get_full_name(), req.data),
                UVM_MEDIUM)

            seq_item_port.item_done();
        end
    endtask
endclass

// One agent contains one sequencer and one driver
class uvm_034_agent extends uvm_agent;
    `uvm_component_utils(uvm_034_agent)

    uvm_034_sequencer sequencer;
    uvm_034_driver driver;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_034_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_034_driver::type_id::create("driver", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Virtual sequencer holds handles to both agent sequencers
class uvm_034_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(uvm_034_virtual_sequencer)

    uvm_034_sequencer seqr_a;
    uvm_034_sequencer seqr_b;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// Virtual sequence coordinates both ordinary sequences
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

// Environment with two agents and one virtual sequencer
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
        vseqr = uvm_034_virtual_sequencer::type_id::create(
            "vseqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        vseqr.seqr_a = agent_a.sequencer;
        vseqr.seqr_b = agent_b.sequencer;
    endfunction
endclass

// Test starts the virtual sequence
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
