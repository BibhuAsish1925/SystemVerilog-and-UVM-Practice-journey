module sv_077_wait_order;

    event start_event;
    event data_event;
    event done_event;

    bit start_seen;
    bit data_seen;
    bit done_seen;

    initial begin

        fork

            begin
                #5;
                $display("[%0t] Start event triggered", $time);
                -> start_event;
                start_seen = 1;
            end

            begin
                #10;
                $display("[%0t] Data event triggered", $time);
                -> data_event;
                data_seen = 1;
            end

            begin
                #15;
                $display("[%0t] Done event triggered", $time);
                -> done_event;
                done_seen = 1;
            end

        join_none

        @start_event;

        if (!start_seen)
            $display("[%0t] Start event order error", $time);
        else
            $display("[%0t] Start event received", $time);

        @data_event;

        if (!data_seen)
            $display("[%0t] Data event order error", $time);
        else
            $display("[%0t] Data event received", $time);

        @done_event;

        if (!done_seen)
            $display("[%0t] Done event order error", $time);
        else
            $display("[%0t] Done event received", $time);

        $display("[%0t] Events occurred in required order", $time);

    end

endmodule