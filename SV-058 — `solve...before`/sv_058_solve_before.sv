module sv_058_solve_before;

    class transaction;

        rand bit write;
        rand int data;

        // Solve write before data
        constraint solve_order {
            solve write before data;
        }

        // Data depends on write
        constraint data_rule {
            if (write)
                data inside {[10:20]};
            else
                data inside {[80:90]};
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