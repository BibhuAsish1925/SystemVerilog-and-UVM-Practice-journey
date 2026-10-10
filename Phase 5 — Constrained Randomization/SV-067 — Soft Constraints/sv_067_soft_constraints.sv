module sv_067_soft_constraints;

    class transaction;

        rand int data;

        // Default constraint
        constraint data_range {
            soft data inside {[10:20]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Uses the default soft constraint
        if (trans.randomize())
            trans.display("Default");

        // Inline constraint overrides the soft constraint
        if (trans.randomize() with {
            data inside {[50:60]};
        })
            trans.display("Override");

    end

endmodule