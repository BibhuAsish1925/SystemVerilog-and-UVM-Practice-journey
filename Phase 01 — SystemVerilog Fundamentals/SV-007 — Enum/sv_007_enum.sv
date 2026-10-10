module sv_007_enum;

    typedef enum {
        IDLE,
        START,
        ACTIVE,
        DONE
    } state_t;

    state_t state;

    initial begin
        state = ACTIVE;

        $display("Current = %s", state.name());
        $display("First   = %s", state.first().name());
        $display("Last    = %s", state.last().name());
        $display("Next    = %s", state.next().name());
        $display("Previous= %s", state.prev().name());
        $display("Number  = %0d", state.num());
    end

endmodule