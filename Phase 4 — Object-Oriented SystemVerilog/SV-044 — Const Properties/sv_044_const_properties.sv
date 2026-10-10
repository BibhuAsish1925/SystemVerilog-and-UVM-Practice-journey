module sv_044_const_properties;

    class transaction;

        // Const property
        const int transaction_id;

        // Constructor
        function new(int id);
            transaction_id = id;
        endfunction

        function void display();
            $display("Transaction ID = %0d", transaction_id);
        endfunction

    endclass


    transaction trans1;
    transaction trans2;

    initial begin

        // Initialize const properties through constructors
        trans1 = new(101);
        trans2 = new(102);

        trans1.display();
        trans2.display();

        // Not allowed:
        // trans1.transaction_id = 200;

    end

endmodule