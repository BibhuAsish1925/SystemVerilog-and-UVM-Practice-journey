module sv_073_disable_fork;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #5;
                $display("[%0t] Process 1 completed", $time);
            end

            begin
                #10;
                $display("[%0t] Process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Process 3 completed", $time);
            end

        join_any

        $display("[%0t] First process completed", $time);

        // Terminate remaining forked processes
        disable fork;

        $display("[%0t] Remaining processes terminated", $time);

    end

endmodule