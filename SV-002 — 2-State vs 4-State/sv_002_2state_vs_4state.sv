module sv_002_2state_vs_4state;

    bit   bit_signal;       // 2-state: only 0, 1
    logic logic_signal;     // 4-state: 0, 1, X, Z

    initial begin
        // X/Z cannot be retained by a 2-state variable
        bit_signal   = 1'bx;
        logic_signal = 1'bx;

        $display("After assigning X:");
        $display("bit   = %b", bit_signal);
        $display("logic = %b", logic_signal);

        bit_signal   = 1'bz;
        logic_signal = 1'bz;

        $display("\nAfter assigning Z:");
        $display("bit   = %b", bit_signal);
        $display("logic = %b", logic_signal);

        bit_signal   = 1'b1;
        logic_signal = 1'b1;

        $display("\nAfter assigning 1:");
        $display("bit   = %b", bit_signal);
        $display("logic = %b", logic_signal);
    end

endmodule