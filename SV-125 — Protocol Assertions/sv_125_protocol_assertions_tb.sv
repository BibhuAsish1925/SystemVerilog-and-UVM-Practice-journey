`timescale 1ns/1ps

module sv_125_protocol_assertions_tb;

    logic clk;
    logic reset;

    logic valid;
    logic ready;

    logic req;
    logic ack;

    logic fifo_write;
    logic fifo_read;
    logic fifo_full;
    logic fifo_empty;

    // ============================================================
    // VALID / READY
    // ============================================================

    // A transfer occurs only when valid and ready are high.
    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] VALID/READY failed: ready=0 while valid=1",
                    $time);

    // ============================================================
    // HANDSHAKE
    // ============================================================

    // A request must receive an acknowledgement on the next cycle.
    ap_request_ack:
        assert property (@(posedge clk)
                          disable iff (reset)
                          req |=> ack)
        else $error("[%0t] HANDSHAKE failed: ack missing after request",
                    $time);

    // ============================================================
    // FIFO PROPERTIES
    // ============================================================

    // Cannot write into a full FIFO.
    ap_no_write_when_full:
        assert property (@(posedge clk)
                          disable iff (reset)
                          fifo_full |-> !fifo_write)
        else $error("[%0t] FIFO failed: write attempted while full",
                    $time);

    // Cannot read from an empty FIFO.
    ap_no_read_when_empty:
        assert property (@(posedge clk)
                          disable iff (reset)
                          fifo_empty |-> !fifo_read)
        else $error("[%0t] FIFO failed: read attempted while empty",
                    $time);

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        valid = 1'b0;
        ready = 1'b0;

        req = 1'b0;
        ack = 1'b0;

        fifo_write = 1'b0;
        fifo_read  = 1'b0;
        fifo_full  = 1'b0;
        fifo_empty = 1'b1;

        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------

        @(negedge clk);
        reset = 1'b1;

        // --------------------------------------------------------
        // VALID / READY PASS
        // --------------------------------------------------------

        @(negedge clk);
        reset = 1'b0;

        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // --------------------------------------------------------
        // HANDSHAKE PASS
        // --------------------------------------------------------

        @(negedge clk);
        req = 1'b1;
        ack = 1'b0;

        @(negedge clk);
        req = 1'b0;
        ack = 1'b1;

        @(negedge clk);
        ack = 1'b0;

        // --------------------------------------------------------
        // FIFO PASS
        // --------------------------------------------------------

        @(negedge clk);
        fifo_empty = 1'b0;
        fifo_read  = 1'b1;

        @(negedge clk);
        fifo_read = 1'b0;

        fifo_full  = 1'b1;
        fifo_write = 1'b0;

        @(negedge clk);

        // --------------------------------------------------------
        // Intentional protocol failures
        // --------------------------------------------------------

        // VALID/READY failure
        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;

        // HANDSHAKE failure
        req = 1'b1;
        ack = 1'b0;

        @(negedge clk);
        req = 1'b0;

        // FIFO write-while-full failure
        fifo_full  = 1'b1;
        fifo_write = 1'b1;

        @(negedge clk);
        fifo_write = 1'b0;

        // FIFO read-while-empty failure
        fifo_full  = 1'b0;
        fifo_empty = 1'b1;
        fifo_read  = 1'b1;

        @(negedge clk);
        fifo_read = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule