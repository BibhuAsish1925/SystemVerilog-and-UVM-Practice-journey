`timescale 1ns/1ps

class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00,
        input logic       write   = 1'b0
    );
        this.address = address;
        this.data    = data;
        this.write   = write;
    endfunction

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class scoreboard;

    mailbox #(transaction) expected_mbx;
    mailbox #(transaction) actual_mbx;

    function new(
        mailbox #(transaction) expected_mbx,
        mailbox #(transaction) actual_mbx
    );
        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;
    endfunction

    task run(input int count);

        transaction expected;
        transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            expected.display("Expected");
            actual.display("Actual");

            if ((expected.address == actual.address) &&
                (expected.data    == actual.data)    &&
                (expected.write   == actual.write))
                $display("[%0t] SCOREBOARD: PASS", $time);
            else
                $error("[%0t] SCOREBOARD: FAIL", $time);

        end

    endtask

endclass


module sv_134_scoreboard_tb;

    mailbox #(transaction) expected_mbx;
    mailbox #(transaction) actual_mbx;

    scoreboard sb;

    initial begin

        transaction tx;

        expected_mbx = new();
        actual_mbx   = new();

        sb = new(expected_mbx, actual_mbx);

        fork

            sb.run(5);

            begin

                tx = new(8'h10, 8'hA5, 1'b1);
                expected_mbx.put(tx);

                tx = new(8'h15, 8'h3C, 1'b0);
                expected_mbx.put(tx);

                tx = new(8'h1A, 8'h72, 1'b1);
                expected_mbx.put(tx);

                tx = new(8'h1F, 8'hD4, 1'b0);
                expected_mbx.put(tx);

                tx = new(8'h12, 8'h56, 1'b1);
                expected_mbx.put(tx);

            end

            begin

                tx = new(8'h10, 8'hA5, 1'b1);
                actual_mbx.put(tx);

                tx = new(8'h15, 8'h3C, 1'b0);
                actual_mbx.put(tx);

                tx = new(8'h1A, 8'h72, 1'b1);
                actual_mbx.put(tx);

                tx = new(8'h1F, 8'hD4, 1'b0);
                actual_mbx.put(tx);

                tx = new(8'h12, 8'h56, 1'b1);
                actual_mbx.put(tx);

            end

        join

        $display("Scoreboard comparison completed.");

        $finish;

    end

endmodule