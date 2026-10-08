`timescale 1ns/1ps

//============================================================
// APB-style Interface
//============================================================

interface sv141_apb_if;

    logic       clk;
    logic       reset;

    logic       psel;
    logic       penable;
    logic       pwrite;
    logic [7:0] paddr;
    logic [7:0] pwdata;

    logic [7:0] prdata;
    logic       pready;

endinterface


//============================================================
// APB-style DUT
//============================================================

module sv_141_apb_dut (
    sv141_apb_if vif
);

    logic [7:0] mem [0:3];

    assign vif.pready = vif.psel && vif.penable;

    always_ff @(posedge vif.clk) begin

        if (vif.reset) begin

            mem[0]      <= 8'h00;
            mem[1]      <= 8'h00;
            mem[2]      <= 8'h00;
            mem[3]      <= 8'h00;
            vif.prdata  <= 8'h00;

        end
        else if (vif.psel && vif.penable) begin

            if (vif.pwrite) begin

                case (vif.paddr)

                    8'h10: mem[0] <= vif.pwdata;
                    8'h14: mem[1] <= vif.pwdata;
                    8'h18: mem[2] <= vif.pwdata;
                    8'h1C: mem[3] <= vif.pwdata;

                    default: ;

                endcase

            end
            else begin

                case (vif.paddr)

                    8'h10: vif.prdata <= mem[0];
                    8'h14: vif.prdata <= mem[1];
                    8'h18: vif.prdata <= mem[2];
                    8'h1C: vif.prdata <= mem[3];

                    default: vif.prdata <= 8'h00;

                endcase

            end

        end

    end

endmodule


//============================================================
// Transaction
//============================================================

class sv141_transaction;

    logic       write;
    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] expected_data;

    function new(
        input logic       write         = 1'b0,
        input logic [7:0] address       = 8'h00,
        input logic [7:0] data          = 8'h00,
        input logic [7:0] expected_data = 8'h00
    );

        this.write         = write;
        this.address       = address;
        this.data          = data;
        this.expected_data = expected_data;

    endfunction

endclass


//============================================================
// Generator
//============================================================

class sv141_generator;

    mailbox #(sv141_transaction) gen_mbx;
    mailbox #(sv141_transaction) expected_mbx;

    function new(
        mailbox #(sv141_transaction) gen_mbx,
        mailbox #(sv141_transaction) expected_mbx
    );

        this.gen_mbx      = gen_mbx;
        this.expected_mbx = expected_mbx;

    endfunction


    task run();

        sv141_transaction tx;

        // WRITE address 10 = A5
        tx = new(1'b1, 8'h10, 8'hA5, 8'h00);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        // WRITE address 14 = 3C
        tx = new(1'b1, 8'h14, 8'h3C, 8'h00);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        // READ address 10 -> A5
        tx = new(1'b0, 8'h10, 8'h00, 8'hA5);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        // READ address 14 -> 3C
        tx = new(1'b0, 8'h14, 8'h00, 8'h3C);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

    endtask

endclass


//============================================================
// Driver
//============================================================

class sv141_driver;

    mailbox #(sv141_transaction) gen_mbx;
    virtual sv141_apb_if vif;

    function new(
        mailbox #(sv141_transaction) gen_mbx,
        virtual sv141_apb_if vif
    );

        this.gen_mbx = gen_mbx;
        this.vif     = vif;

    endfunction


    task run(input int count);

        sv141_transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            // APB setup phase
            @(negedge vif.clk);

            vif.psel     = 1'b1;
            vif.penable  = 1'b0;
            vif.pwrite   = tx.write;
            vif.paddr    = tx.address;
            vif.pwdata   = tx.data;

            // APB access phase
            @(negedge vif.clk);

            vif.penable = 1'b1;

            @(posedge vif.clk);

            #1;

            $display("[%0t] Driver: %s address=%h data=%h",
                     $time,
                     tx.write ? "WRITE" : "READ ",
                     tx.address,
                     tx.data);

            // End transfer
            @(negedge vif.clk);

            vif.psel    = 1'b0;
            vif.penable = 1'b0;

        end

    endtask

endclass


//============================================================
// Monitor
//============================================================

class sv141_monitor;

    virtual sv141_apb_if vif;
    mailbox #(sv141_transaction) actual_mbx;

    function new(
        virtual sv141_apb_if vif,
        mailbox #(sv141_transaction) actual_mbx
    );

        this.vif        = vif;
        this.actual_mbx = actual_mbx;

    endfunction


    task run(input int count);

        sv141_transaction tx;
        int observed_count;

        observed_count = 0;

        // Wait until the required number of valid
        // protocol transfers has actually been observed.
        while (observed_count < count) begin

            @(posedge vif.clk);

            #1;

            if (vif.psel && vif.penable && vif.pready) begin

                tx = new();

                tx.write   = vif.pwrite;
                tx.address = vif.paddr;

                if (vif.pwrite)
                    tx.data = vif.pwdata;
                else
                    tx.data = vif.prdata;

                actual_mbx.put(tx);

                $display("[%0t] Monitor: %s address=%h data=%h",
                         $time,
                         tx.write ? "WRITE" : "READ ",
                         tx.address,
                         tx.data);

                observed_count++;

            end

        end

    endtask

endclass


//============================================================
// Scoreboard
//============================================================

class sv141_scoreboard;

    mailbox #(sv141_transaction) expected_mbx;
    mailbox #(sv141_transaction) actual_mbx;

    int pass_count;
    int fail_count;

    function new(
        mailbox #(sv141_transaction) expected_mbx,
        mailbox #(sv141_transaction) actual_mbx
    );

        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;

        pass_count = 0;
        fail_count = 0;

    endfunction


    task run(input int count);

        sv141_transaction expected;
        sv141_transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            if (expected.write != actual.write) begin

                $error("[%0t] SCOREBOARD FAIL: operation mismatch",
                       $time);

                fail_count++;

            end
            else if (expected.address != actual.address) begin

                $error("[%0t] SCOREBOARD FAIL: address expected=%h actual=%h",
                       $time,
                       expected.address,
                       actual.address);

                fail_count++;

            end
            else if (expected.write) begin

                if (expected.data == actual.data) begin

                    $display("[%0t] SCOREBOARD PASS: WRITE address=%h data=%h",
                             $time,
                             actual.address,
                             actual.data);

                    pass_count++;

                end
                else begin

                    $error("[%0t] SCOREBOARD FAIL: WRITE expected=%h actual=%h",
                           $time,
                           expected.data,
                           actual.data);

                    fail_count++;

                end

            end
            else begin

                if (expected.expected_data == actual.data) begin

                    $display("[%0t] SCOREBOARD PASS: READ address=%h data=%h",
                             $time,
                             actual.address,
                             actual.data);

                    pass_count++;

                end
                else begin

                    $error("[%0t] SCOREBOARD FAIL: READ expected=%h actual=%h",
                           $time,
                           expected.expected_data,
                           actual.data);

                    fail_count++;

                end

            end

        end

    endtask


    function void report();

        $display("========================================");
        $display("PROTOCOL SCOREBOARD SUMMARY");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

    endfunction

endclass


//============================================================
// Complete Protocol Verification Testbench
//============================================================

module sv_141_complete_protocol_verification_tb;

    sv141_apb_if vif();

    mailbox #(sv141_transaction) gen_mbx;
    mailbox #(sv141_transaction) expected_mbx;
    mailbox #(sv141_transaction) actual_mbx;

    sv141_generator  gen;
    sv141_driver     drv;
    sv141_monitor    mon;
    sv141_scoreboard sb;

    sv_141_apb_dut dut (
        .vif(vif)
    );


    initial begin

        vif.clk    = 1'b0;
        vif.reset  = 1'b1;

        vif.psel    = 1'b0;
        vif.penable = 1'b0;
        vif.pwrite  = 1'b0;
        vif.paddr   = 8'h00;
        vif.pwdata  = 8'h00;

        gen_mbx      = new();
        expected_mbx = new();
        actual_mbx   = new();

        gen = new(gen_mbx, expected_mbx);
        drv = new(gen_mbx, vif);
        mon = new(vif, actual_mbx);
        sb  = new(expected_mbx, actual_mbx);


        // Reset
        repeat (2)
            @(negedge vif.clk);

        vif.reset = 1'b0;

        $display("Starting complete protocol verification...");


        fork

            gen.run();

            drv.run(4);

            mon.run(4);

            sb.run(4);

        join


        sb.report();

        $display("Complete protocol verification completed.");

        $finish;

    end


    always #5 vif.clk = ~vif.clk;

endmodule