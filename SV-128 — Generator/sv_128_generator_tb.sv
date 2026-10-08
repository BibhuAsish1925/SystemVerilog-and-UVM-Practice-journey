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

    function void display();
        $display("[%0t] Transaction: address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


class generator;

    transaction tx;

    function new();
        tx = new();
    endfunction

    task generate_transactions(input int count);

        repeat (count) begin

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            tx.display();

        end

    endtask

endclass


module sv_128_generator_tb;

    generator gen;

    initial begin

        gen = new();

        $display("Starting transaction generation...");

        gen.generate_transactions(5);

        $display("Transaction generation completed.");

        $finish;

    end

endmodule