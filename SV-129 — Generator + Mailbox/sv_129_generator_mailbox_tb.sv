`timescale 1ns/1ps

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

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class generator;

    mailbox #(transaction) gen_mbx;

    function new(mailbox #(transaction) gen_mbx);
        this.gen_mbx = gen_mbx;
    endfunction

    task generate_transactions(input int count);

        transaction tx;

        repeat (count) begin

            tx = new();

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            gen_mbx.put(tx);

            tx.display("Generated");

        end

    endtask

endclass


module sv_129_generator_mailbox_tb;

    mailbox #(transaction) gen_mbx;
    generator gen;

    initial begin

        gen_mbx = new();
        gen = new(gen_mbx);

        fork

            gen.generate_transactions(5);

            begin
                transaction rx;

                repeat (5) begin

                    gen_mbx.get(rx);

                    rx.display("Received");

                end
            end

        join

        $display("Generator and mailbox communication completed.");

        $finish;

    end

endmodule