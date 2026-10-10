module sv_090_simulation_time_tb;

    time start_time;
    time end_time;
    time elapsed_time;

    initial begin

        start_time = $time;

        $display("[%0t] Simulation started",
                 $time);

        #10;

        end_time = $time;
        elapsed_time = end_time - start_time;

        $display("[%0t] After #10 delay",
                 $time);

        $display("Start time   = %0t",
                 start_time);

        $display("End time     = %0t",
                 end_time);

        $display("Elapsed time = %0t",
                 elapsed_time);

        #5;

        $display("[%0t] After additional #5 delay",
                 $time);

        $finish;

    end

endmodule