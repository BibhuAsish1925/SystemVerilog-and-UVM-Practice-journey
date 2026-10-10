module sv_054_inline_constraints;

    class transaction;

        rand int data;

        // Base constraint
        constraint data_range {
            data >= 0;
            data <= 100;
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Normal randomization using class constraint
        if (trans.randomize())
            trans.display("Base constraint");
        else
            $display("Randomization failed");


        // Inline constraint temporarily restricts the value
        if (trans.randomize() with {
            data >= 40;
            data <= 60;
        })
            trans.display("Inline constraint");
        else
            $display("Randomization failed");


        // Another inline constraint
        if (trans.randomize() with {
            data == 75;
        })
            trans.display("Exact value");
        else
            $display("Randomization failed");

    end

endmodule