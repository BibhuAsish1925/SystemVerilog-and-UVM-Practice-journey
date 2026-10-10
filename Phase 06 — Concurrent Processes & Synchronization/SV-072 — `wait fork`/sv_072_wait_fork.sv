module sv_072_wait_fork;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #10;
                $display("[%0t] Background process 1 completed", $time);
            end

            begin
                #5;
                $display("[%0t] Background process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Background process 3 completed", $time);
            end

        join_none

        $display("[%0t] Main process continues", $time);

        // Wait for all spawned processes
        wait fork;

        $display("[%0t] All spawned processes completed", $time);

    end

endmodule