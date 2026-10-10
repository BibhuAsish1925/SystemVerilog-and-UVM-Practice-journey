
`include "uvm_macros.svh"
import uvm_pkg::*;

// APB interface
interface uvm_037_apb_if;
    logic PCLK;
    logic PRESETn;
    logic PSEL, PENABLE, PWRITE;
    logic [3:0]  PADDR;
    logic [31:0] PWDATA, PRDATA;
    logic PREADY;
endinterface

// 16-word x 32-bit RAM with a simplified APB access handshake
module uvm_037_apb_ram_dut(uvm_037_apb_if bus);
    logic [31:0] mem [0:15];

    assign bus.PREADY = bus.PSEL && bus.PENABLE;
    assign bus.PRDATA = mem[bus.PADDR];

    always @(posedge bus.PCLK) begin
        if (!bus.PRESETn) begin
            // Memory contents are not reset.
        end
        else if (bus.PSEL && bus.PENABLE &&
                 bus.PWRITE && bus.PREADY) begin
            mem[bus.PADDR] <= bus.PWDATA;
        end
    end
endmodule

// Transaction
class uvm_037_item extends uvm_sequence_item;
    rand bit        is_write;
    rand bit [3:0]  addr;
    rand bit [31:0] data;

    `uvm_object_utils(uvm_037_item)

    function new(string name = "uvm_037_item");
        super.new(name);
    endfunction
endclass

// Sequence: write three locations, then read them back
class uvm_037_sequence extends uvm_sequence #(uvm_037_item);
    `uvm_object_utils(uvm_037_sequence)

    function new(string name = "uvm_037_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_037_item req;
        bit [3:0] addresses[3] = '{4'h1, 4'h2, 4'h3};
        bit [31:0] values[3] = '{32'hA5, 32'h3C, 32'hF0};

        for (int i = 0; i < 3; i++) begin
            req = uvm_037_item::type_id::create("write_req");
            start_item(req);
            req.is_write = 1;
            req.addr = addresses[i];
            req.data = values[i];
            finish_item(req);
        end

        for (int i = 0; i < 3; i++) begin
            req = uvm_037_item::type_id::create("read_req");
            start_item(req);
            req.is_write = 0;
            req.addr = addresses[i];
            req.data = 0;
            finish_item(req);
        end
    endtask
endclass

// Sequencer
class uvm_037_sequencer extends uvm_sequencer #(uvm_037_item);
    `uvm_component_utils(uvm_037_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// APB driver
class uvm_037_driver extends uvm_driver #(uvm_037_item);
    `uvm_component_utils(uvm_037_driver)

    virtual uvm_037_apb_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uvm_037_apb_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "APB virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_037_item req;

        wait (vif.PRESETn === 1'b1);

        forever begin
            seq_item_port.get_next_item(req);

            // Setup phase
            @(negedge vif.PCLK);
            vif.PSEL = 1;
            vif.PENABLE = 0;
            vif.PWRITE = req.is_write;
            vif.PADDR = req.addr;
            vif.PWDATA = req.data;

            // Access phase
            @(negedge vif.PCLK);
            vif.PENABLE = 1;

            do @(posedge vif.PCLK);
            while (vif.PREADY !== 1'b1);

            @(negedge vif.PCLK);
            vif.PSEL = 0;
            vif.PENABLE = 0;
            vif.PWRITE = 0;

            `uvm_info("APB_DRV",
                $sformatf("%s addr=0x%0h data=0x%08h",
                req.is_write ? "WRITE" : "READ ",
                req.addr, req.data), UVM_MEDIUM)

            seq_item_port.item_done();
        end
    endtask
endclass

// APB monitor
class uvm_037_monitor extends uvm_component;
    `uvm_component_utils(uvm_037_monitor)

    virtual uvm_037_apb_if vif;
    uvm_analysis_port #(uvm_037_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual uvm_037_apb_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor virtual interface not configured")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_037_item observed;

        forever begin
            @(posedge vif.PCLK);

            if (vif.PRESETn && vif.PSEL &&
                vif.PENABLE && vif.PREADY) begin

                observed = uvm_037_item::type_id::create("observed");
                observed.is_write = vif.PWRITE;
                observed.addr = vif.PADDR;

                if (vif.PWRITE)
                    observed.data = vif.PWDATA;
                else
                    observed.data = vif.PRDATA;

                ap.write(observed);
            end
        end
    endtask
endclass

// Scoreboard: maintains a reference memory and checks reads
class uvm_037_scoreboard extends uvm_component;
    `uvm_component_utils(uvm_037_scoreboard)

    uvm_analysis_imp #(uvm_037_item, uvm_037_scoreboard) analysis_imp;
    bit [31:0] model [bit [3:0]];
    int pass_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    function void write(uvm_037_item item);
        if (item.is_write) begin
            model[item.addr] = item.data;
            `uvm_info("SB",
                $sformatf("Model WRITE addr=0x%0h data=0x%08h",
                item.addr, item.data), UVM_MEDIUM)
        end
        else if (!model.exists(item.addr)) begin
            error_count++;
            `uvm_error("SB",
                $sformatf("Read from unwritten address 0x%0h",
                item.addr))
        end
        else if (item.data !== model[item.addr]) begin
            error_count++;
            `uvm_error("SB",
                $sformatf("Mismatch addr=0x%0h expected=0x%08h actual=0x%08h",
                item.addr, model[item.addr], item.data))
        end
        else begin
            pass_count++;
            `uvm_info("SB",
                $sformatf("PASS addr=0x%0h data=0x%08h",
                item.addr, item.data), UVM_MEDIUM)
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SUMMARY",
            $sformatf("PASS=%0d ERROR=%0d",
            pass_count, error_count), UVM_NONE)
        if (error_count != 0)
            `uvm_error("SUMMARY", "APB-RAM verification failed")
    endfunction
endclass

// Agent
class uvm_037_agent extends uvm_agent;
    `uvm_component_utils(uvm_037_agent)

    uvm_037_sequencer sequencer;
    uvm_037_driver driver;
    uvm_037_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_037_sequencer::type_id::create("sequencer", this);
        driver = uvm_037_driver::type_id::create("driver", this);
        monitor = uvm_037_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// Environment
class uvm_037_env extends uvm_env;
    `uvm_component_utils(uvm_037_env)

    uvm_037_agent agent;
    uvm_037_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = uvm_037_agent::type_id::create("agent", this);
        scoreboard =
            uvm_037_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.ap.connect(scoreboard.analysis_imp);
    endfunction
endclass

// Test
class uvm_037_test extends uvm_test;
    `uvm_component_utils(uvm_037_test)

    uvm_037_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uvm_037_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_037_sequence seq;
        phase.raise_objection(this);

        seq = uvm_037_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        phase.drop_objection(this);
    endtask
endclass

// Top module
module uvm_037_apb_ram_tb;
    uvm_037_apb_if bus();

    initial bus.PCLK = 0;
    always #5ns bus.PCLK = ~bus.PCLK;

    uvm_037_apb_ram_dut dut(bus);

    initial begin
        bus.PRESETn = 0;
        bus.PSEL = 0;
        bus.PENABLE = 0;
        bus.PWRITE = 0;
        bus.PADDR = 0;
        bus.PWDATA = 0;

        uvm_config_db#(virtual uvm_037_apb_if)::set(
            null, "*", "vif", bus);

        // Start UVM at time zero; reset release runs concurrently.
        fork
            run_test("uvm_037_test");
            begin
                repeat (2) @(negedge bus.PCLK);
                bus.PRESETn = 1;
            end
        join
    end
endmodule
