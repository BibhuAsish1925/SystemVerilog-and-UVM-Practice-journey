module sv_050_basic_constraints;

    class transaction;

        rand int data;
        rand int address;

        // Relational constraints
        constraint data_range {
            data >= 10;
            data <= 50;
        }

        constraint address_range {
            address >= 100;
            address < 200;
        }

        function void display(int count);
            $display("Transaction %0d: data = %0d | address = %0d",
                     count, data, address);
        endfunction

    endclass


    transaction trans;
    int count;

    initial begin

        trans = new();

        for (count = 1; count <= 5; count++) begin

            if (trans.randomize())
                trans.display(count);
            else
                $display("Randomization failed");

        end

    end

endmodule