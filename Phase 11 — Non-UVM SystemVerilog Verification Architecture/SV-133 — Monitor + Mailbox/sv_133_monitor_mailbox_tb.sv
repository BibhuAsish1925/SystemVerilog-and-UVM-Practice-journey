`timescale 1ns/1ps

interface dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface


class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class monitor;

    virtual dut_if vif;
    mailbox #(transaction) mon_mbx;

    function new(
        virtual dut_if vif,
        mailbox #(transaction) mon_mbx
    );
        this.vif     = vif;
        this.mon_mbx = mon_mbx;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.write   = vif.write;

            mon_mbx.put(tx);

            tx.display("Monitored");

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


module sv_133_monitor_mailbox_tb;

    dut_if vif();

    mailbox #(transaction) mon_mbx;
    monitor mon;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        mon_mbx = new();
        mon = new(vif, mon_mbx);

        fork

            mon.run(5);

            begin
                transaction rx;

                repeat (5) begin

                    mon_mbx.get(rx);

                    rx.display("Received");

                end
            end

            begin

                #10;
                vif.address = 8'h10;
                vif.data    = 8'hA5;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h15;
                vif.data    = 8'h3C;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1A;
                vif.data    = 8'h72;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1F;
                vif.data    = 8'hD4;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h12;
                vif.data    = 8'h56;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

            end

        join

        $display("Monitor-to-mailbox communication completed.");

        $finish;

    end

endmodule