module sv_057_implication;

    class transaction;

        rand bit write;
        rand int data;

        // If write is 1, data must be between 10 and 50
        constraint write_data {
            write -> data inside {[10:50]};
        }

        function void display(int count);
            $display("Transaction %0d: write = %0d | data = %0d",
                     count, write, data);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        trans = new();

        for (count = 1; count <= 10; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule