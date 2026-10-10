module sv_049_cyclic_randomization;

    class transaction;

        // 2-bit cyclic random variable
        randc logic [1:0] data;

        function void display(int count);
            $display("Transaction %0d: data = %0d", count, data);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        trans = new();

        // Generate two complete cycles
        for (count = 1; count <= 8; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule