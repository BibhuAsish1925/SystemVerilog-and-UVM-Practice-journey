module sv_053_post_randomize;

    class transaction;

        rand int data;
        int double_data;

        // Post-randomization callback
        function void post_randomize();
            double_data = data * 2;
            $display("post_randomize() called");
        endfunction

        function void display();
            $display("Randomized data = %0d", data);
            $display("Double data     = %0d", double_data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // post_randomize() is called automatically
        if (trans.randomize())
            trans.display();
        else
            $display("Randomization failed");

    end

endmodule