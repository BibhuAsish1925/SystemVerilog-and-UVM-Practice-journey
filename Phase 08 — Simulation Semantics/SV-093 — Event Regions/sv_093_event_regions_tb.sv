`timescale 1ns/1ps

module sv_093_event_regions_tb;

    logic a;
    logic b;

    initial begin

        a = 1'b0;
        b = 1'b0;

        $display("[%0t] Active    : a=%b b=%b",
                 $time, a, b);

        // Active region: blocking assignment
        a = 1'b1;

        // NBA region: scheduled update
        b <= a;

        // Active region executes before NBA
        $display("[%0t] Active    : a=%b b=%b",
                 $time, a, b);

        // Inactive region
        #0;
        $display("[%0t] Inactive  : a=%b b=%b",
                 $time, a, b);

        // Postponed region observation
        $strobe("[%0t] Postponed : a=%b b=%b",
                $time, a, b);

        #1;

        $finish;

    end

endmodule