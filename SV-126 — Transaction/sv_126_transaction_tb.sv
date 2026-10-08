`timescale 1ns/1ps

// ============================================================
// Transaction class
// ============================================================

class transaction;

    // Transaction fields
    rand logic [7:0]  data;
    rand logic [7:0]  address;
    rand logic        write;

    // Constructor
    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00,
        input logic        write   = 1'b0
    );
        this.address = address;
        this.data    = data;
        this.write   = write;
    endfunction

    // Display transaction contents
    function void display();
        $display("[%0t] Transaction: address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


// ============================================================
// Testbench
// ============================================================

module sv_126_transaction_tb;

    transaction tx1;
    transaction tx2;

    initial begin

        // Create first transaction
        tx1 = new(8'h10, 8'hA5, 1'b1);

        // Create second transaction
        tx2 = new(8'h20, 8'h3C, 1'b0);

        // Display transactions
        tx1.display();
        tx2.display();

        $finish;

    end

endmodule