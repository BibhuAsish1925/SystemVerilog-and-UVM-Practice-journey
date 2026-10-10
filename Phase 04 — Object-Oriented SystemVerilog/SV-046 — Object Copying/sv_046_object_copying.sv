module sv_046_object_copying;

    // Simple nested class
    class payload;

        int value;

        function new(int value);
            this.value = value;
        endfunction

    endclass


    // Transaction class
    class transaction;

        int data;
        payload p;

        function new(int data, int value);
            this.data = data;
            this.p = new(value);
        endfunction

        // Shallow copy
        function transaction shallow_copy();
            transaction copy;

            copy = new(this.data, 0);
            copy.p = this.p;

            return copy;
        endfunction

        // Deep copy
        function transaction deep_copy();
            transaction copy;

            copy = new(this.data, this.p.value);

            return copy;
        endfunction

    endclass


    transaction original;
    transaction handle_copy;
    transaction shallow;
    transaction deep;

    initial begin

        // Original object
        original = new(100, 50);

        // Handle copy: both handles refer to the same object
        handle_copy = original;

        // Modify through handle copy
        handle_copy.data = 200;

        $display("Handle Copy:");
        $display("original.data     = %0d", original.data);
        $display("handle_copy.data  = %0d", handle_copy.data);


        // Create a separate object using shallow copy
        shallow = original.shallow_copy();

        // Both objects share the same nested payload
        shallow.p.value = 75;

        $display("\nShallow Copy:");
        $display("original.p.value = %0d", original.p.value);
        $display("shallow.p.value  = %0d", shallow.p.value);


        // Create a separate object using deep copy
        deep = original.deep_copy();

        // Deep copy has its own nested payload
        deep.p.value = 100;

        $display("\nDeep Copy:");
        $display("original.p.value = %0d", original.p.value);
        $display("deep.p.value     = %0d", deep.p.value);

    end

endmodule