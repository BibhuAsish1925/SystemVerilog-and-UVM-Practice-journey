module sv_089_assignments_tb;

    logic a;
    logic b;

    logic blocking_x;
    logic blocking_y;

    logic nonblocking_x;
    logic nonblocking_y;

    initial begin

        a = 1'b1;
        b = 1'b0;

        // Blocking assignments execute immediately
        blocking_x = a;
        blocking_y = blocking_x;

        $display("[%0t] Blocking    : x=%b y=%b",
                 $time,
                 blocking_x,
                 blocking_y);

        // Nonblocking assignments update later
        nonblocking_x <= a;
        nonblocking_y <= nonblocking_x;

        // At this point nonblocking updates have not occurred yet
        $display("[%0t] Before NBA  : x=%b y=%b",
                 $time,
                 nonblocking_x,
                 nonblocking_y);

        #1;

        // NBA updates have now occurred
        $display("[%0t] After NBA   : x=%b y=%b",
                 $time,
                 nonblocking_x,
                 nonblocking_y);

        $finish;

    end

endmodule