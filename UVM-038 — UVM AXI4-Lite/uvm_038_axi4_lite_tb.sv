
`include "uvm_macros.svh"
import uvm_pkg::*;

// 1. AXI4-Lite interface
interface uvm_038_axi_if;
    logic ACLK, ARESETn;

    logic [3:0] AWADDR, ARADDR;
    logic AWVALID, AWREADY;

    logic [31:0] WDATA, RDATA;
    logic [3:0] WSTRB;
    logic WVALID, WREADY;

    logic [1:0] BRESP, RRESP;
    logic BVALID, BREADY;

    logic ARVALID, ARREADY;
    logic RVALID, RREADY;
endinterface

// 2. AXI4-Lite slave: four 32-bit registers
module uvm_038_axi_slave(uvm_038_axi_if bus);

    logic [31:0] regs [0:3];

    logic aw_pending, w_pending;
    logic [3:0] awaddr_saved;
    logic [31:0] wdata_saved;
    logic [3:0] wstrb_saved;

    wire aw_fire = bus.AWVALID && bus.AWREADY;
    wire w_fire  = bus.WVALID  && bus.WREADY;
    wire b_fire  = bus.BVALID  && bus.BREADY;
    wire ar_fire = bus.ARVALID && bus.ARREADY;
    wire r_fire  = bus.RVALID  && bus.RREADY;

    // Select saved or newly accepted write information.
    wire [3:0] write_addr =
        aw_pending ? awaddr_saved : bus.AWADDR;
    wire [31:0] write_data =
        w_pending ? wdata_saved : bus.WDATA;
    wire [3:0] write_strb =
        w_pending ? wstrb_saved : bus.WSTRB;

    assign bus.AWREADY = !aw_pending && !bus.BVALID;
    assign bus.WREADY  = !w_pending && !bus.BVALID;
    assign bus.ARREADY = !bus.RVALID;

    always @(posedge bus.ACLK) begin
        if (!bus.ARESETn) begin
            aw_pending <= 0;
            w_pending  <= 0;
            bus.BVALID <= 0;
            bus.BRESP  <= 0;
            bus.RVALID <= 0;
            bus.RRESP  <= 0;
            bus.RDATA  <= 0;

            awaddr_saved <= 0;
            wdata_saved  <= 0;
            wstrb_saved  <= 0;
        end
        else begin
            if (aw_fire) begin
                aw_pending <= 1;
                awaddr_saved <= bus.AWADDR;
            end

            if (w_fire) begin
                w_pending <= 1;
                wdata_saved <= bus.WDATA;
                wstrb_saved <= bus.WSTRB;
            end

            // Complete the write when both channels are available.
            if ((aw_pending || aw_fire) &&
                (w_pending || w_fire) && !bus.BVALID) begin

                if (write_addr < 4) begin
                    for (int b = 0; b < 4; b++) begin
                        if (write_strb[b]) begin
                            regs[write_addr][8*b +: 8]
                                <= write_data[8*b +: 8];
                        end
                    end
                end

                aw_pending <= 0;
                w_pending <= 0;
                bus.BVALID <= 1;
                bus.BRESP <= 2'b00;
            end
            else if (b_fire) begin
                bus.BVALID <= 0;
            end

            // Read channel
            if (ar_fire) begin
                if (bus.ARADDR < 4)
                    bus.RDATA <= regs[bus.ARADDR];
                else
                    bus.RDATA <= 32'h00000000;

                bus.RRESP <= 2'b00;
                bus.RVALID <= 1;
            end
            else if (r_fire) begin
                bus.RVALID <= 0;
            end
        end
    end
endmodule

// 3. UVM transaction
class uvm_038_item extends uvm_sequence_item;

    bit is_write;
    bit [3:0] addr;
    bit [31:0] data;

    `uvm_object_utils(uvm_038_item)

    function new(string name = "uvm_038_item");
        super.new(name);
    endfunction
endclass

// 4. Sequence: write and read three addresses
class uvm_038_sequence extends uvm_sequence #(uvm_038_item);

    `uvm_object_utils(uvm_038_sequence)

    function new(string name = "uvm_038_sequence");
        super.new(name);
    endfunction

    task body();
        uvm_038_item req;

        bit [3:0] addrs[3] = '{4'h1, 4'h2, 4'h3};
        bit [31:0] values[3] = '{32'hA5, 32'h3C, 32'hF0};

        for (int i = 0; i < 3; i++) begin
            req = uvm_038_item::type_id::create("write_req");

            start_item(req);
            req.is_write = 1;
            req.addr = addrs[i];
            req.data = values[i];
            finish_item(req);
        end

        for (int i = 0; i < 3; i++) begin
            req = uvm_038_item::type_id::create("read_req");

            start_item(req);
            req.is_write = 0;
            req.addr = addrs[i];
            req.data = 0;
            finish_item(req);
        end
    endtask
endclass

// 5. Sequencer
class uvm_038_sequencer extends uvm_sequencer #(uvm_038_item);

    `uvm_component_utils(uvm_038_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

// 6. AXI4-Lite master driver
class uvm_038_driver extends uvm_driver #(uvm_038_item);

    `uvm_component_utils(uvm_038_driver)

    virtual uvm_038_axi_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_038_axi_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Driver virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_038_item req;
        bit aw_done, w_done;

        wait (vif.ARESETn === 1'b1);

        forever begin
            seq_item_port.get_next_item(req);

            if (req.is_write) begin
                @(negedge vif.ACLK);

                vif.AWADDR  = req.addr;
                vif.AWVALID = 1;
                vif.WDATA   = req.data;
                vif.WSTRB   = 4'hF;
                vif.WVALID  = 1;
                vif.BREADY  = 0;

                aw_done = 0;
                w_done = 0;

                // AW and W can complete in different cycles.
                while (!aw_done || !w_done) begin
                    @(posedge vif.ACLK);

                    if (vif.AWVALID && vif.AWREADY)
                        aw_done = 1;

                    if (vif.WVALID && vif.WREADY)
                        w_done = 1;

                    @(negedge vif.ACLK);

                    if (aw_done)
                        vif.AWVALID = 0;

                    if (w_done)
                        vif.WVALID = 0;
                end

                vif.BREADY = 1;

                do @(posedge vif.ACLK);
                while (vif.BVALID !== 1'b1);

                @(negedge vif.ACLK);
                vif.BREADY = 0;

                `uvm_info("MASTER",
                    $sformatf("WRITE addr=0x%0h data=0x%08h",
                    req.addr, req.data), UVM_MEDIUM)
            end
            else begin
                @(negedge vif.ACLK);

                vif.ARADDR = req.addr;
                vif.ARVALID = 1;
                vif.RREADY = 0;

                do @(posedge vif.ACLK);
                while (!(vif.ARVALID && vif.ARREADY));

                @(negedge vif.ACLK);
                vif.ARVALID = 0;
                vif.RREADY = 1;

                do @(posedge vif.ACLK);
                while (vif.RVALID !== 1'b1);

                req.data = vif.RDATA;

                @(negedge vif.ACLK);
                vif.RREADY = 0;

                `uvm_info("MASTER",
                    $sformatf("READ addr=0x%0h data=0x%08h",
                    req.addr, req.data), UVM_MEDIUM)
            end

            seq_item_port.item_done();
        end
    endtask
endclass

// 7. Monitor
class uvm_038_monitor extends uvm_component;

    `uvm_component_utils(uvm_038_monitor)

    virtual uvm_038_axi_if vif;
    uvm_analysis_port #(uvm_038_item) ap;

    bit aw_seen, w_seen;
    bit [3:0] saved_addr;
    bit [31:0] saved_data;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual uvm_038_axi_if)::get(
            this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Monitor virtual interface missing")
    endfunction

    task run_phase(uvm_phase phase);
        uvm_038_item item;

        forever begin
            @(posedge vif.ACLK);

            if (!vif.ARESETn) begin
                aw_seen = 0;
                w_seen = 0;
            end
            else begin
                if (vif.AWVALID && vif.AWREADY) begin
                    saved_addr = vif.AWADDR;
                    aw_seen = 1;
                end

                if (vif.WVALID && vif.WREADY) begin
                    saved_data = vif.WDATA;
                    w_seen = 1;
                end

                if (vif.BVALID && vif.BREADY &&
                    aw_seen && w_seen) begin

                    item = uvm_038_item::type_id::create(
                        "write_observed");

                    item.is_write = 1;
                    item.addr = saved_addr;
                    item.data = saved_data;

                    ap.write(item);

                    aw_seen = 0;
                    w_seen = 0;
                end

                if (vif.RVALID && vif.RREADY) begin
                    item = uvm_038_item::type_id::create(
                        "read_observed");

                    item.is_write = 0;
                    item.addr = vif.ARADDR;
                    item.data = vif.RDATA;

                    ap.write(item);
                end
            end
        end
    endtask
endclass

// 8. Scoreboard
class uvm_038_scoreboard extends uvm_component;

    `uvm_component_utils(uvm_038_scoreboard)

    uvm_analysis_imp #(uvm_038_item, uvm_038_scoreboard) analysis_imp;

    bit [31:0] model [bit [3:0]];

    int pass_count = 0;
    int error_count = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_imp = new("analysis_imp", this);
    endfunction

    function void write(uvm_038_item item);
        if (item.is_write) begin
            model[item.addr] = item.data;
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
                $sformatf(
                "Mismatch addr=0x%0h expected=0x%08h actual=0x%08h",
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
            `uvm_error("SUMMARY", "AXI4-Lite verification failed")
    endfunction
endclass

// 9. Agent
class uvm_038_agent extends uvm_agent;

    `uvm_component_utils(uvm_038_agent)

    uvm_038_sequencer sequencer;
    uvm_038_driver driver;
    uvm_038_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sequencer = uvm_038_sequencer::type_id::create(
            "sequencer", this);
        driver = uvm_038_driver::type_id::create("driver", this);
        monitor = uvm_038_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass

// 10. Environment
class uvm_038_env extends uvm_env;

    `uvm_component_utils(uvm_038_env)

    uvm_038_agent agent;
    uvm_038_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = uvm_038_agent::type_id::create("agent", this);
        scoreboard = uvm_038_scoreboard::type_id::create(
            "scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.monitor.ap.connect(scoreboard.analysis_imp);
    endfunction
endclass

// 11. Test
class uvm_038_test extends uvm_test;

    `uvm_component_utils(uvm_038_test)

    uvm_038_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uvm_038_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_038_sequence seq;

        phase.raise_objection(this);

        seq = uvm_038_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);

        phase.drop_objection(this);
    endtask
endclass

// 12. Top module
module uvm_038_axi4_lite_tb;

    uvm_038_axi_if bus();

    initial bus.ACLK = 0;
    always #5ns bus.ACLK = ~bus.ACLK;

    uvm_038_axi_slave dut(bus);

    initial begin
        bus.ARESETn = 0;

        bus.AWADDR = 0;
        bus.AWVALID = 0;

        bus.WDATA = 0;
        bus.WSTRB = 0;
        bus.WVALID = 0;

        bus.BREADY = 0;

        bus.ARADDR = 0;
        bus.ARVALID = 0;
        bus.RREADY = 0;

        uvm_config_db#(virtual uvm_038_axi_if)::set(
            null, "*", "vif", bus);

        // Start UVM at time zero; release reset concurrently.
        fork
            run_test("uvm_038_test");

            begin
                repeat (2) @(negedge bus.ACLK);
                bus.ARESETn = 1;
            end
        join
    end
endmodule
