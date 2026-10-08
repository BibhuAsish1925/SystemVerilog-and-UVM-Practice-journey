`timescale 1ns/1ps


interface sv137_dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       valid;
    logic [7:0] result;

endinterface


module sv_137_dut (
    sv137_dut_if vif
);

    assign vif.result = vif.address + vif.data;

endmodule


class sv137_transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] result;

    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00,
        input logic [7:0] result  = 8'h00
    );
        this.address = address;
        this.data    = data;
        this.result  = result;
    endfunction

endclass


class sv137_generator;

    mailbox #(sv137_transaction) gen_mbx;
    mailbox #(sv137_transaction) expected_mbx;

    function new(
        mailbox #(sv137_transaction) gen_mbx,
        mailbox #(sv137_transaction) expected_mbx
    );
        this.gen_mbx      = gen_mbx;
        this.expected_mbx = expected_mbx;
    endfunction

    task run(input int count);

        sv137_transaction tx;

        repeat (count) begin

            tx = new();

            tx.address = 8'h10 + $urandom_range(0, 8);
            tx.data    = 8'h20 + $urandom_range(0, 8);
            tx.result  = tx.address + tx.data;

            gen_mbx.put(tx);
            expected_mbx.put(tx);

        end

    endtask

endclass


class sv137_driver;

    mailbox #(sv137_transaction) gen_mbx;
    virtual sv137_dut_if vif;

    function new(
        mailbox #(sv137_transaction) gen_mbx,
        virtual sv137_dut_if vif
    );
        this.gen_mbx = gen_mbx;
        this.vif     = vif;
    endfunction

    task run(input int count);

        sv137_transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            vif.address = tx.address;
            vif.data    = tx.data;
            vif.valid   = 1'b0;

            #1;

            vif.valid = 1'b1;

            $display("[%0t] Driver: address=%h data=%h",
                     $time,
                     vif.address,
                     vif.data);

            #9;

            vif.valid = 1'b0;

        end

    endtask

endclass


class sv137_monitor;

    virtual sv137_dut_if vif;
    mailbox #(sv137_transaction) actual_mbx;

    function new(
        virtual sv137_dut_if vif,
        mailbox #(sv137_transaction) actual_mbx
    );
        this.vif        = vif;
        this.actual_mbx = actual_mbx;
    endfunction

    task run(input int count);

        sv137_transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.result  = vif.result;

            actual_mbx.put(tx);

            $display("[%0t] Monitor: address=%h data=%h result=%h",
                     $time,
                     tx.address,
                     tx.data,
                     tx.result);

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


class sv137_scoreboard;

    mailbox #(sv137_transaction) expected_mbx;
    mailbox #(sv137_transaction) actual_mbx;

    function new(
        mailbox #(sv137_transaction) expected_mbx,
        mailbox #(sv137_transaction) actual_mbx
    );
        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;
    endfunction

    task run(input int count);

        sv137_transaction expected;
        sv137_transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            if ((expected.address == actual.address) &&
                (expected.data    == actual.data)    &&
                (expected.result  == actual.result))
                $display("[%0t] SCOREBOARD: PASS",
                         $time);
            else
                $error("[%0t] SCOREBOARD: FAIL",
                       $time);

        end

    endtask

endclass


class sv137_environment;

    mailbox #(sv137_transaction) gen_mbx;
    mailbox #(sv137_transaction) expected_mbx;
    mailbox #(sv137_transaction) actual_mbx;

    sv137_generator  gen;
    sv137_driver     drv;
    sv137_monitor    mon;
    sv137_scoreboard sb;

    virtual sv137_dut_if vif;

    function new(virtual sv137_dut_if vif);

        this.vif = vif;

        gen_mbx      = new();
        expected_mbx = new();
        actual_mbx   = new();

        gen = new(gen_mbx, expected_mbx);
        drv = new(gen_mbx, vif);
        mon = new(vif, actual_mbx);
        sb  = new(expected_mbx, actual_mbx);

    endfunction

    task run(input int count);

        fork
            gen.run(count);
            drv.run(count);
            mon.run(count);
            sb.run(count);
        join

    endtask

endclass


class sv137_test;

    sv137_environment env;

    virtual sv137_dut_if vif;

    function new(virtual sv137_dut_if vif);

        this.vif = vif;
        env = new(vif);

    endfunction

    task run();

        int stimulus_count = 5;

        $display("Starting SV-137 test...");

        $display("Test control: generating %0d transactions",
                 stimulus_count);

        env.run(stimulus_count);

        $display("SV-137 test completed.");

    endtask

endclass


module sv_137_test_tb;

    sv137_dut_if vif();

    sv_137_dut dut (
        .vif(vif)
    );

    sv137_test test;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.valid   = 1'b0;

        test = new(vif);

        test.run();

        $finish;

    end

endmodule