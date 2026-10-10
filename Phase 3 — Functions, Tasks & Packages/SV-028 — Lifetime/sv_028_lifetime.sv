module sv_028_lifetime;

    // Static lifetime: one variable is shared by all calls
    function int static_count();
        static int count = 0;
        count++;
        return count;
    endfunction

    // Automatic lifetime: new variable for every call
    function automatic int automatic_count();
        int count = 0;
        count++;
        return count;
    endfunction

    initial begin
        $display("Static lifetime:");
        $display("Call 1 = %0d", static_count());
        $display("Call 2 = %0d", static_count());
        $display("Call 3 = %0d", static_count());

        $display("\nAutomatic lifetime:");
        $display("Call 1 = %0d", automatic_count());
        $display("Call 2 = %0d", automatic_count());
        $display("Call 3 = %0d", automatic_count());
    end

endmodule