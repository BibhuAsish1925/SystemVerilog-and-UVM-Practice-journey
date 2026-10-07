module sv_068_constraint_layering;

    class transaction;

        rand int data;

        // Class-level constraint
        constraint data_range {
            data inside {[10:100]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Layer 1: class constraint
        if (trans.randomize())
            trans.display("Class constraint");
        else
            $display("Randomization failed");


        // Layer 2: class constraint + inline constraint
        if (trans.randomize() with {
            data inside {[40:60]};
        })
            trans.display("Class + inline constraint");
        else
            $display("Randomization failed");


        // Another inline constraint
        if (trans.randomize() with {
            data == 75;
        })
            trans.display("Class + exact inline constraint");
        else
            $display("Randomization failed");

    end

endmodule