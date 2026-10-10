module sv_038_getters_setters;

    class transaction;

        // Internal property
        local int data;

        // Setter: controlled write access
        function void set_data(int new_data);
            data = new_data;
        endfunction

        // Getter: controlled read access
        function int get_data();
            return data;
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Set property through setter
        trans.set_data(100);

        // Read property through getter
        $display("Data = %0d", trans.get_data());

        // Update property through setter
        trans.set_data(250);

        $display("Updated Data = %0d", trans.get_data());

    end

endmodule