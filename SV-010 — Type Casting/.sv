module sv_011_cast;

    class parent;
        virtual function void show();
            $display("Parent object");
        endfunction
    endclass

    class child extends parent;
        function void show();
            $display("Child object");
        endfunction

        function void child_method();
            $display("Child-specific method");
        endfunction
    endclass

    parent p;
    child  c;
    child  c_cast;

    initial begin
        // Create a child object through a parent handle
        c = new();
        p = c;

        // Safe dynamic cast: succeeds
        if ($cast(c_cast, p)) begin
            $display("Cast 1: SUCCESS");
            c_cast.child_method();
        end
        else begin
            $display("Cast 1: FAILED");
        end

        // Create a real parent object
        p = new();

        // Safe dynamic cast: fails
        if ($cast(c_cast, p)) begin
            $display("Cast 2: SUCCESS");
        end
        else begin
            $display("Cast 2: FAILED");
        end
    end

endmodule