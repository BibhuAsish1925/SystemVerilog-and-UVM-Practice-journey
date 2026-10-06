module sv_034_constructors;

    class transaction;

        // Data members
        int data;
        string name;

        // Constructor with arguments
        function new(int data, string name);
            this.data = data;
            this.name = name;
        endfunction

        // Display method
        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

    endclass

    // Object handles
    transaction trans1;
    transaction trans2;

    initial begin

        // Create objects and initialize using constructor
        trans1 = new(100, "Transaction-1");
        trans2 = new(200, "Transaction-2");

        // Display initialized objects
        trans1.display();
        trans2.display();

    end

endmodule