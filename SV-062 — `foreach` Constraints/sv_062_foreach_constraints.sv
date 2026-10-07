module sv_062_foreach_constraints;

    class transaction;

        rand int data[5];

        // Apply the same constraint to every array element
        constraint data_range {
            foreach (data[i])
                data[i] inside {[10:50]};
        }

        function void display();
            foreach (data[i])
                $display("data[%0d] = %0d", i, data[i]);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        if (trans.randomize())
            trans.display();
        else
            $display("Randomization failed");

    end

endmodule