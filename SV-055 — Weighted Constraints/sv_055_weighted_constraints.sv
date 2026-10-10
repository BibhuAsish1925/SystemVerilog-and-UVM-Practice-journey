module sv_055_weighted_constraints;

    class transaction;

        rand int data;

        // Weighted distribution
        constraint data_weight {
            data dist {
                0       := 1,
                [1:3]   := 2,
                [4:6]   :/ 3
            };
        }

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
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