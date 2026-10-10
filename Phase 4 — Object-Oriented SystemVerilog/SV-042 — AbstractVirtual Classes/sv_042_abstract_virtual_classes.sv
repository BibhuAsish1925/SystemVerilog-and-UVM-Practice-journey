module sv_042_abstract_virtual_classes;

    // Abstract base class
    virtual class transaction;

        // Pure virtual method
        pure virtual function void display();

    endclass


    // Concrete child class
    class write_transaction extends transaction;

        int data;

        function new(int data);
            this.data = data;
        endfunction

        // Implementation of pure virtual method
        function void display();
            $display("Write transaction | Data = %0d", data);
        endfunction

    endclass


    // Another concrete child class
    class read_transaction extends transaction;

        int address;

        function new(int address);
            this.address = address;
        endfunction

        // Implementation of pure virtual method
        function void display();
            $display("Read transaction | Address = %0d", address);
        endfunction

    endclass


    // Parent handle
    transaction trans;

    // Child handles
    write_transaction write_trans;
    read_transaction read_trans;

    initial begin

        // Create write object
        write_trans = new(100);

        // Parent handle refers to write object
        trans = write_trans;
        trans.display();


        // Create read object
        read_trans = new(200);

        // Parent handle refers to read object
        trans = read_trans;
        trans.display();

    end

endmodule