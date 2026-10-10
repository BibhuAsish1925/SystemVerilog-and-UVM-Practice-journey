module sv_069_fork_join;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #10;
                $display("[%0t] Process 1 completed", $time);
            end

            begin
                #5;
                $display("[%0t] Process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Process 3 completed", $time);
            end

        join

        $display("[%0t] All processes completed", $time);

    end

endmodule