module sv_045_parameterized_classes;

    // Parameterized transaction class
    class transaction #(parameter int WIDTH = 8);

        logic [WIDTH-1:0] data;

        function new(logic [WIDTH-1:0] data);
            this.data = data;
        endfunction

        function void display();
            $display("WIDTH = %0d | DATA = %h", WIDTH, data);
        endfunction

    endclass


    // Different specializations of the same class
    transaction #(8)  trans_8;
    transaction #(16) trans_16;
    transaction #(32) trans_32;

    initial begin

        // Create 8-bit transaction
        trans_8 = new(8'hA5);

        // Create 16-bit transaction
        trans_16 = new(16'h1234);

        // Create 32-bit transaction
        trans_32 = new(32'h12345678);

        // Display transactions
        trans_8.display();
        trans_16.display();
        trans_32.display();

    end

endmodule