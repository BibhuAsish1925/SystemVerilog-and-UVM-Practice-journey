`timescale 1ns/1ps

module sv_106_transition_bins_tb;

    logic [1:0] state;

    covergroup state_cg;

        coverpoint state {

            // Individual state values
            bins idle   = {2'b00};
            bins active = {2'b01};
            bins done   = {2'b10};

            // State transitions
            bins idle_to_active = (2'b00 => 2'b01);
            bins active_to_done = (2'b01 => 2'b10);
            bins done_to_idle   = (2'b10 => 2'b00);

        }

    endgroup

    state_cg cg;

    initial begin

        cg = new();

        // IDLE -> ACTIVE
        state = 2'b00;
        cg.sample();

        state = 2'b01;
        cg.sample();

        // ACTIVE -> DONE
        state = 2'b10;
        cg.sample();

        // DONE -> IDLE
        state = 2'b00;
        cg.sample();

        $display("[%0t] Transition coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule