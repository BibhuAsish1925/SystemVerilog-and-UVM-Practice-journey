module sv_074_events;

    event transaction_done;

    initial begin
        #10;
        $display("[%0t] Producer: Transaction completed", $time);

        -> transaction_done;

        $display("[%0t] Producer: Event triggered", $time);
    end

    initial begin
        $display("[%0t] Consumer: Waiting for event", $time);

        @transaction_done;

        $display("[%0t] Consumer: Event received", $time);
    end

    initial begin
        #10;

        if (transaction_done.triggered)
            $display("[%0t] Monitor: Event was triggered", $time);
        else
            $display("[%0t] Monitor: Event was not triggered", $time);
    end

endmodule