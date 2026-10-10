module sv_052_pre_randomize;

    class transaction;

        rand int data;

        // Pre-randomization callback
        function void pre_randomize();
            $display("pre_randomize() called");
        endfunction

        function void display();
            $display("Randomized data = %0d", data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // pre_randomize() is called automatically
        if (trans.randomize())
            trans.display();
        else
            $display("Randomization failed");

    end

endmodule