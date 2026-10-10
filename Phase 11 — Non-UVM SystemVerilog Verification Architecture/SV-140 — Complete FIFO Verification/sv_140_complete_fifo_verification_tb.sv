`timescale 1ns/1ps

//============================================================
// FIFO Interface
//============================================================

interface sv140_fifo_if;

    logic       clk;
    logic       reset;

    logic       write_en;
    logic       read_en;
    logic [7:0] write_data;

    logic [7:0] read_data;
    logic       full;
    logic       empty;

endinterface


//============================================================
// FIFO DUT
//============================================================

module sv_140_fifo_dut (
    sv140_fifo_if vif
);

    logic [7:0] mem [0:3];

    logic [2:0] count;
    logic [1:0] wr_ptr;
    logic [1:0] rd_ptr;

    assign vif.full  = (count == 3'd4);
    assign vif.empty = (count == 3'd0);

    always_ff @(posedge vif.clk) begin

        if (vif.reset) begin

            count          <= 3'd0;
            wr_ptr         <= 2'd0;
            rd_ptr         <= 2'd0;
            vif.read_data  <= 8'h00;

        end
        else begin

            if (vif.write_en && !vif.full) begin
                mem[wr_ptr] <= vif.write_data;
                wr_ptr      <= wr_ptr + 1'b1;
            end

            if (vif.read_en && !vif.empty) begin
                vif.read_data <= mem[rd_ptr];
                rd_ptr        <= rd_ptr + 1'b1;
            end

            case ({vif.write_en && !vif.full,
                   vif.read_en  && !vif.empty})

                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;

            endcase

        end

    end

endmodule


//============================================================
// Transaction
//============================================================

class sv140_transaction;

    logic       write_en;
    logic       read_en;
    logic [7:0] data;

    function new(
        input logic       write_en = 1'b0,
        input logic       read_en  = 1'b0,
        input logic [7:0] data     = 8'h00
    );

        this.write_en = write_en;
        this.read_en  = read_en;
        this.data     = data;

    endfunction

endclass


//============================================================
// Generator
//============================================================

class sv140_generator;

    mailbox #(sv140_transaction) gen_mbx;

    function new(mailbox #(sv140_transaction) gen_mbx);

        this.gen_mbx = gen_mbx;

    endfunction

    task run();

        sv140_transaction tx;

        // Write four values
        tx = new(1'b1, 1'b0, 8'hA1);
        gen_mbx.put(tx);

        tx = new(1'b1, 1'b0, 8'hB2);
        gen_mbx.put(tx);

        tx = new(1'b1, 1'b0, 8'hC3);
        gen_mbx.put(tx);

        tx = new(1'b1, 1'b0, 8'hD4);
        gen_mbx.put(tx);

        // Read four values
        tx = new(1'b0, 1'b1, 8'h00);
        gen_mbx.put(tx);

        tx = new(1'b0, 1'b1, 8'h00);
        gen_mbx.put(tx);

        tx = new(1'b0, 1'b1, 8'h00);
        gen_mbx.put(tx);

        tx = new(1'b0, 1'b1, 8'h00);
        gen_mbx.put(tx);

    endtask

endclass


//============================================================
// Driver
//============================================================

class sv140_driver;

    mailbox #(sv140_transaction) gen_mbx;
    virtual sv140_fifo_if vif;

    function new(
        mailbox #(sv140_transaction) gen_mbx,
        virtual sv140_fifo_if vif
    );

        this.gen_mbx = gen_mbx;
        this.vif     = vif;

    endfunction

    task run(input int count);

        sv140_transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            @(negedge vif.clk);

            vif.write_en  = tx.write_en;
            vif.read_en   = tx.read_en;
            vif.write_data = tx.data;

            $display("[%0t] Driver: write=%b read=%b data=%h",
                     $time,
                     tx.write_en,
                     tx.read_en,
                     tx.data);

        end

        @(negedge vif.clk);

        vif.write_en = 1'b0;
        vif.read_en  = 1'b0;

    endtask

endclass


//============================================================
// Monitor
//============================================================

class sv140_monitor;

    virtual sv140_fifo_if vif;
    mailbox #(sv140_transaction) actual_mbx;

    function new(
        virtual sv140_fifo_if vif,
        mailbox #(sv140_transaction) actual_mbx
    );

        this.vif        = vif;
        this.actual_mbx = actual_mbx;

    endfunction

    task run(input int count);

        sv140_transaction tx;

        repeat (count) begin

            @(posedge vif.clk);

            #1;

            if (vif.read_en && !vif.empty) begin

                tx = new();

                tx.write_en = 1'b0;
                tx.read_en  = 1'b1;
                tx.data     = vif.read_data;

                actual_mbx.put(tx);

                $display("[%0t] Monitor: read_data=%h",
                         $time,
                         vif.read_data);

            end

        end

    endtask

endclass


//============================================================
// Scoreboard
//============================================================

class sv140_scoreboard;

    mailbox #(sv140_transaction) actual_mbx;

    logic [7:0] expected_fifo[$];

    int pass_count;
    int fail_count;

    function new(mailbox #(sv140_transaction) actual_mbx);

        this.actual_mbx = actual_mbx;

        pass_count = 0;
        fail_count = 0;

    endfunction

    task write_expected(input logic [7:0] data);

        expected_fifo.push_back(data);

    endtask

    task check_read(input logic [7:0] actual_data);

        logic [7:0] expected_data;

        if (expected_fifo.size() == 0) begin

            $error("[%0t] SCOREBOARD: Unexpected FIFO read",
                   $time);

            fail_count++;

        end
        else begin

            expected_data = expected_fifo.pop_front();

            if (actual_data == expected_data) begin

                $display("[%0t] SCOREBOARD: PASS expected=%h actual=%h",
                         $time,
                         expected_data,
                         actual_data);

                pass_count++;

            end
            else begin

                $error("[%0t] SCOREBOARD: FAIL expected=%h actual=%h",
                       $time,
                       expected_data,
                       actual_data);

                fail_count++;

            end

        end

    endtask

    task run(input int read_count);

        sv140_transaction tx;

        repeat (read_count) begin

            actual_mbx.get(tx);

            check_read(tx.data);

        end

    endtask

    function void report();

        $display("========================================");
        $display("FIFO SCOREBOARD SUMMARY");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

    endfunction

endclass


//============================================================
// Testbench
//============================================================

module sv_140_complete_fifo_verification_tb;

    sv140_fifo_if vif();

    mailbox #(sv140_transaction) gen_mbx;
    mailbox #(sv140_transaction) actual_mbx;

    sv140_generator  gen;
    sv140_driver     drv;
    sv140_monitor    mon;
    sv140_scoreboard sb;

    sv_140_fifo_dut dut (
        .vif(vif)
    );


    initial begin

        vif.clk        = 1'b0;
        vif.reset      = 1'b1;
        vif.write_en   = 1'b0;
        vif.read_en    = 1'b0;
        vif.write_data = 8'h00;

        gen_mbx    = new();
        actual_mbx = new();

        gen = new(gen_mbx);
        drv = new(gen_mbx, vif);
        mon = new(vif, actual_mbx);
        sb  = new(actual_mbx);


        // Reset
        repeat (2)
            @(negedge vif.clk);

        vif.reset = 1'b0;


        $display("Starting complete FIFO verification...");


        fork

            gen.run();

            drv.run(8);

            mon.run(8);

            begin

                // Reference model
                sb.write_expected(8'hA1);
                sb.write_expected(8'hB2);
                sb.write_expected(8'hC3);
                sb.write_expected(8'hD4);

                sb.run(4);

            end

        join


        sb.report();

        $display("Complete FIFO verification completed.");

        $finish;

    end


    always #5 vif.clk = ~vif.clk;

endmodule