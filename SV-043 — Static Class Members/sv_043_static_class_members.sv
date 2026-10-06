module sv_043_static_class_members;

    class transaction;

        // Static property shared by all objects
        static int object_count;

        // Instance property
        int data;

        // Constructor
        function new(int data);
            this.data = data;
            object_count++;
        endfunction

        // Static method
        static function void display_count();
            $display("Total objects created = %0d", object_count);
        endfunction

        // Instance method
        function void display_data();
            $display("Data = %0d", data);
        endfunction

    endclass


    transaction trans1;
    transaction trans2;

    initial begin

        // Create first object
        trans1 = new(100);

        // Create second object
        trans2 = new(200);

        // Instance methods access individual object data
        trans1.display_data();
        trans2.display_data();

        // Static property is shared by both objects
        $display("Shared count = %0d", transaction::object_count);

        // Static method called using class scope
        transaction::display_count();

    end

endmodule