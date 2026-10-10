module sv_006_typedef;

    // Create user-defined type names
    typedef logic [7:0] data_t;
    typedef int unsigned count_t;

    // Create an enum type for named states
    typedef enum {
        IDLE,
        START,
        DONE
    } state_t;

    data_t  data;
    count_t count;
    state_t state;

    initial begin
        data  = 8'hA5;
        count = 100;
        state = IDLE;

        $display("data  = %h", data);
        $display("count = %0d", count);
        $display("state = %s", state.name());

        state = START;
        $display("state = %s", state.name());

        state = DONE;
        $display("state = %s", state.name());
    end

endmodule