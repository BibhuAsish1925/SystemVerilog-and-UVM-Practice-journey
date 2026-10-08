`timescale 1ns/1ps

class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] result;

    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00
    );
        this.address = address;
        this.data    = data;
    endfunction

endclass


class reference_model;

    function logic [7:0] predict(transaction tx);

        predict = tx.data + tx.address;

    endfunction

endclass


module sv_135_reference_model_tb;

    transaction     tx;
    reference_model ref_model;

    logic [7:0] expected_result;

    initial begin

        ref_model = new();

        // Transaction 1
        tx = new(8'h10, 8'h20);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        // Transaction 2
        tx = new(8'h15, 8'h30);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        // Transaction 3
        tx = new(8'h1A, 8'h40);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        $display("Reference model prediction completed.");

        $finish;

    end

endmodule