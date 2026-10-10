module sv_048_basic_randomization;

    class transaction;

        // Random variable
        rand int data;

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        // Create transaction object
        trans = new();

        // Generate random values
        repeat (5) begin

            if (trans.randomize())
                trans.display($time / 1);
            else
                $display("Randomization failed");

        end

    end

endmodule