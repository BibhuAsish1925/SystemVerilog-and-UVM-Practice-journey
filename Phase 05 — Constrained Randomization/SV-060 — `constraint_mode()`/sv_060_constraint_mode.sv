module sv_060_constraint_mode;

    class transaction;

        rand int data;

        // Normal data range
        constraint data_range {
            data inside {[10:20]};
        }

        function void display(string label);
            $display("%s: data = %0d", label, data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Constraint enabled
        trans.randomize();
        trans.display("Constraint enabled");


        // Disable data_range constraint
        trans.data_range.constraint_mode(0);

        // data is now unrestricted by data_range
        trans.randomize();
        trans.display("Constraint disabled");


        // Re-enable data_range constraint
        trans.data_range.constraint_mode(1);

        // data is restricted to 10-20 again
        trans.randomize();
        trans.display("Constraint enabled again");

    end

endmodule