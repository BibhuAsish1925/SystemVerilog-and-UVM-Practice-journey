`timescale 1ns/1ps

interface sv138_dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface


class sv138_transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

endclass


class sv138_coverage;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    covergroup cg_transaction;

        cp_address:
            coverpoint address {
                bins low_address  = {[8'h10:8'h14]};
                bins high_address = {[8'h15:8'h1F]};
            }

        cp_data:
            coverpoint data {
                bins low_data  = {[8'h20:8'h27]};
                bins high_data = {[8'h28:8'h2F]};
            }

        cp_write:
            coverpoint write {
                bins read  = {0};
                bins write = {1};
            }

        address_write:
            cross cp_address, cp_write;

    endgroup


    function new();

        cg_transaction = new();

    endfunction


    function void sample(sv138_transaction tx);

        address = tx.address;
        data    = tx.data;
        write   = tx.write;

        cg_transaction.sample();

    endfunction


    function void report();

        $display("Coverage = %0.2f%%",
                 cg_transaction.get_coverage());

    endfunction

endclass


class sv138_monitor;

    virtual sv138_dut_if vif;
    sv138_coverage cov;

    function new(
        virtual sv138_dut_if vif,
        sv138_coverage cov
    );

        this.vif = vif;
        this.cov = cov;

    endfunction


    task run(input int count);

        sv138_transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.write   = vif.write;

            $display("[%0t] Monitor: address=%h data=%h write=%b",
                     $time,
                     tx.address,
                     tx.data,
                     tx.write);

            cov.sample(tx);

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


module sv_138_coverage_integration_tb;

    sv138_dut_if vif();

    sv138_coverage cov;
    sv138_monitor  mon;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        cov = new();
        mon = new(vif, cov);

        fork

            mon.run(5);

            begin

                #10;
                vif.address = 8'h10;
                vif.data    = 8'h20;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h14;
                vif.data    = 8'h27;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h15;
                vif.data    = 8'h28;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1F;
                vif.data    = 8'h2F;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h12;
                vif.data    = 8'h2A;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

            end

        join

        cov.report();

        $display("Coverage integration completed.");

        $finish;

    end

endmodule