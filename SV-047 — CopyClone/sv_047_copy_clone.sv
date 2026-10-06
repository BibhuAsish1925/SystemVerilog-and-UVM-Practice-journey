module sv_047_copy_clone;

    class transaction;

        int data;
        string name;

        function new(int data = 0, string name = "");
            this.data = data;
            this.name = name;
        endfunction

        // User-defined copy()
        function void copy(transaction rhs);
            this.data = rhs.data;
            this.name = rhs.name;
        endfunction

        // User-defined clone()
        function transaction clone();
            transaction copy_obj;

            copy_obj = new();
            copy_obj.copy(this);

            return copy_obj;
        endfunction

        function void display(string label);
            $display("%s | Name = %s | Data = %0d",
                     label, name, data);
        endfunction

    endclass


    transaction original;
    transaction copied;
    transaction cloned;

    initial begin

        // Create original object
        original = new(100, "Original");

        // Create destination object and copy into it
        copied = new();
        copied.copy(original);

        // Create a new object using clone()
        cloned = original.clone();

        // Modify copied and cloned objects
        copied.data = 200;
        cloned.data = 300;

        // Display all objects
        original.display("Original");
        copied.display("Copied");
        cloned.display("Cloned");

    end

endmodule