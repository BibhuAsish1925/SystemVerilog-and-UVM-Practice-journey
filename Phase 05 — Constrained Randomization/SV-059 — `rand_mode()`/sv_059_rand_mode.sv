module sv_059_rand_mode;

    class transaction;

        rand int data;
        rand int address;

        constraint data_range {
            data inside {[10:20]};
        }

        constraint address_range {
            address inside {[100:200]};
        }

        function void display(string label);
            $display("%s: data = %0d | address = %0d",
                     label, data, address);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Both variables are randomized
        trans.randomize();
        trans.display("Both enabled");


        // Disable randomization of data
        trans.data.rand_mode(0);

        // Only address is randomized
        trans.randomize();
        trans.display("Data disabled");


        // Re-enable randomization of data
        trans.data.rand_mode(1);

        // Both variables are randomized again
        trans.randomize();
        trans.display("Both enabled again");

    end

endmodule