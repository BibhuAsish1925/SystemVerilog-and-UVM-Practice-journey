`timescale 1ns/1ps

// ============================================================
// Transaction class
// ============================================================

class transaction;

    // Randomizable transaction fields
    rand logic [7:0] address;
    rand logic [7:0] data;
    rand logic       write;

    // Address and data constraints
    constraint address_range {
        address inside {[8'h10:8'h1F]};
    }

    constraint data_range {
        data inside {[8'h20:8'hEF]};
    }

    // Write operation must be 0 or 1
    constraint write_value {
        write inside {0, 1};
    }

    // Display transaction
    function void display();
        $display("[%0t] address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


// ============================================================
// Testbench
// ============================================================

module sv_127_transaction_randomization_tb;

    transaction tx;

    initial begin

        tx = new();

        repeat (5) begin

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            tx.display();

        end

        $finish;

    end

endmodule