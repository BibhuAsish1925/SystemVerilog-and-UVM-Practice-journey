module sv_032_classes_objects;

    // Class declaration
    class transaction;

        int data;
        string name;

        // Constructor
        function new(int data, string name);
            this.data = data;
            this.name = name;
        endfunction

        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

    endclass

    // Object handle
    transaction trans;

    initial begin

        // Create object using new()
        trans = new(100, "Transaction-1");

        // Access object properties and method
        trans.display();

    end

endmodule