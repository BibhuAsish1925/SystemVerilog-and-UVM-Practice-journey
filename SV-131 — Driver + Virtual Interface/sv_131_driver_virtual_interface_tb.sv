`timescale 1ns/1ps

interface dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface


class transaction;

    rand logic [7:0] address;
    rand logic [7:0] data;
    rand logic       write;

    constraint address_range {
        address inside {[8'h10:8'h1F]};
    }

    constraint data_range {
        data inside {[8'h20:8'hEF]};
    }

endclass


class driver;

    mailbox #(transaction) gen_mbx;
    virtual dut_if vif;

    function new(
        mailbox #(transaction) gen_mbx,
        virtual dut_if vif
    );
        this.gen_mbx = gen_mbx;
        this.vif     = vif;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            vif.address = tx.address;
            vif.data    = tx.data;
            vif.write   = tx.write;
            vif.valid   = 1'b1;

            $display("[%0t] Driver -> DUT: address=%h data=%h write=%b valid=%b",
                     $time,
                     vif.address,
                     vif.data,
                     vif.write,
                     vif.valid);

            #10;

            vif.valid = 1'b0;

        end

    endtask

endclass


class generator;

    mailbox #(transaction) gen_mbx;

    function new(mailbox #(transaction) gen_mbx);
        this.gen_mbx = gen_mbx;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            tx = new();

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            gen_mbx.put(tx);

        end

    endtask

endclass


module sv_131_driver_virtual_interface_tb;

    dut_if vif();

    mailbox #(transaction) gen_mbx;

    generator gen;
    driver    drv;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        gen_mbx = new();

        gen = new(gen_mbx);
        drv = new(gen_mbx, vif);

        fork
            gen.run(5);
            drv.run(5);
        join

        $display("Virtual interface connectivity completed.");

        $finish;

    end

endmodule