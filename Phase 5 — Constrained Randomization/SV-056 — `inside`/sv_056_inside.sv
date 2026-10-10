module sv_056_inside;

    class transaction;

        rand int data;

        // Restrict data to selected values and ranges
        constraint data_values {
            data inside {5, 10, [20:25], [40:45]};
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