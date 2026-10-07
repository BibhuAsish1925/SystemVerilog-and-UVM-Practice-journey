module sv_091_event_control_tb;

    logic clk;
    logic enable;
    logic done;

    initial begin

        clk    = 1'b0;
        enable = 1'b0;
        done   = 1'b0;

        // @ waits for a signal event
        @(posedge clk);

        $display("[%0t] @: Detected clock rising edge",
                 $time);

        // wait waits until the condition becomes true
        wait (enable == 1'b1);

        $display("[%0t] wait: Enable became 1",
                 $time);

        // Event expression: wait for either condition
        @(posedge clk or posedge done);

        $display("[%0t] Event expression: clock or done detected",
                 $time);

        $finish;

    end


    // Generate clock
    always #5 clk = ~clk;


    initial begin

        #12;
        enable = 1'b1;

        #8;
        done = 1'b1;

    end

endmodule