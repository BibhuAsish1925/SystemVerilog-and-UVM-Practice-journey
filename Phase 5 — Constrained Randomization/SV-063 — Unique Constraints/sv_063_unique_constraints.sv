module sv_063_unique_constraints;

    class transaction;

        rand int data[5];

        // XSim-compatible equivalent of unique {data}
        constraint unique_data {
            data[0] != data[1];
            data[0] != data[2];
            data[0] != data[3];
            data[0] != data[4];

            data[1] != data[2];
            data[1] != data[3];
            data[1] != data[4];

            data[2] != data[3];
            data[2] != data[4];

            data[3] != data[4];
        }

        // Keep all values within the range 1 to 10
        constraint data_range {
            foreach (data[i])
                data[i] inside {[1:10]};
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