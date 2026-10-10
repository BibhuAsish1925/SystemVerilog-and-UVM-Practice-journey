module sv_092_delta_cycles_tb;

    logic a;
    logic b;
    logic c;

    initial begin

        a = 1'b0;
        b = 1'b0;
        c = 1'b0;

        $display("[%0t] Initial: a=%b b=%b c=%b",
                 $time, a, b, c);

        // Blocking assignment updates immediately
        a = 1'b1;

        // Nonblocking assignments are scheduled
        b <= a;
        c <= b;

        // Still the same simulation time,
        // but NBA updates have not executed yet.
        $display("[%0t] Before NBA: a=%b b=%b c=%b",
                 $time, a, b, c);

        // #0 advances to another delta cycle
        #0;

        $display("[%0t] After #0: a=%b b=%b c=%b",
                 $time, a, b, c);

        #1;

        $display("[%0t] After #1: a=%b b=%b c=%b",
                 $time, a, b, c);

        $finish;

    end

endmodule