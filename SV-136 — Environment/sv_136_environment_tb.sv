`timescale 1ns/1ps


interface sv136_dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       valid;
    logic [7:0] result;

endinterface


module sv_136_dut (
    sv136_dut_if vif
);

    assign vif.result = vif.address + vif.data;

endmodule


class sv136_transaction;

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


class sv136_generator;

    mailbox #(sv136_transaction) gen_mbx;
    mailbox #(sv136_transaction) expected_mbx;

    function new(
        mailbox #(sv136_transaction) gen_mbx,
        mailbox #(sv136_transaction) expected_mbx
    );
        this.gen_mbx      = gen_mbx;
        this.expected_mbx = expected_mbx;
    endfunction

    task run(input int count);

        sv136_transaction tx;

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


class sv136_driver;

    mailbox #(sv136_transaction) gen_mbx;
    virtual sv136_dut_if vif;

    function new(
        mailbox #(sv136_transaction) gen_mbx,
        virtual sv136_dut_if vif
    );
        this.gen_mbx = gen_mbx;
        this.vif     = vif;
    endfunction

    task run(input int count);

        sv136_transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            // Drive DUT inputs
            vif.address = tx.address;
            vif.data    = tx.data;
            vif.valid   = 1'b0;

            // Allow combinational DUT result to settle
            #1;

            // Indicate that the transaction is valid
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


class sv136_monitor;

    virtual sv136_dut_if vif;
    mailbox #(sv136_transaction) actual_mbx;

    function new(
        virtual sv136_dut_if vif,
        mailbox #(sv136_transaction) actual_mbx
    );
        this.vif        = vif;
        this.actual_mbx = actual_mbx;
    endfunction

    task run(input int count);

        sv136_transaction tx;

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


class sv136_scoreboard;

    mailbox #(sv136_transaction) expected_mbx;
    mailbox #(sv136_transaction) actual_mbx;

    function new(
        mailbox #(sv136_transaction) expected_mbx,
        mailbox #(sv136_transaction) actual_mbx
    );
        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;
    endfunction

    task run(input int count);

        sv136_transaction expected;
        sv136_transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            if ((expected.address == actual.address) &&
                (expected.data    == actual.data)    &&
                (expected.result  == actual.result))
                $display("[%0t] SCOREBOARD: PASS",
                         $time);
            else begin

                $error("[%0t] SCOREBOARD: FAIL",
                       $time);

                $display("Expected: address=%h data=%h result=%h",
                         expected.address,
                         expected.data,
                         expected.result);

                $display("Actual:   address=%h data=%h result=%h",
                         actual.address,
                         actual.data,
                         actual.result);

            end

        end

    endtask

endclass


class sv136_environment;

    mailbox #(sv136_transaction) gen_mbx;
    mailbox #(sv136_transaction) expected_mbx;
    mailbox #(sv136_transaction) actual_mbx;

    sv136_generator  gen;
    sv136_driver     drv;
    sv136_monitor    mon;
    sv136_scoreboard sb;

    virtual sv136_dut_if vif;

    function new(virtual sv136_dut_if vif);

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


module sv_136_environment_tb;

    sv136_dut_if vif();

    sv_136_dut dut (
        .vif(vif)
    );

    sv136_environment env;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.valid   = 1'b0;

        env = new(vif);

        $display("Starting verification environment...");

        env.run(5);

        $display("Verification environment completed.");

        $finish;

    end

endmodule