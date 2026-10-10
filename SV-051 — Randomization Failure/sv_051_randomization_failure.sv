module sv_051_randomization_failure;

    class transaction;

        rand int data;

        // Conflicting constraints
        constraint valid_range {
            data >= 10;
            data <= 20;
        }

        constraint impossible_range {
            data > 50;
        }

    endclass


    transaction trans;
    bit status;

    initial begin

        trans = new();

        // Try to randomize
        status = trans.randomize();

        if (status) begin
            $display("Randomization SUCCESS");
            $display("data = %0d", trans.data);
        end
        else begin
            $display("Randomization FAILED");
            $display("No value satisfies all constraints");
        end

    end

endmodule