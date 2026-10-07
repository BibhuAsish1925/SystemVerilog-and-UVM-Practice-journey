# 077 — SV-077 — `wait_order`

SystemVerilog provides the **`wait_order`** statement for ordered event synchronization.

It allows a process to wait for multiple events while requiring those events to occur in a specific order.

### Syntax

```systemverilog
wait_order(event1, event2, event3)
    success_statement;
else
    failure_statement;
```

For example:

```systemverilog
wait_order(start_event, data_event, done_event)
    $display("Correct order");
else
    $display("Wrong order");
```

The required sequence is:

```text
start_event → data_event → done_event
```

If the events occur in this order, the success statement executes.

If the required order is violated, the `else` statement executes.

### Complete Runnable Example

```systemverilog
module sv_077_wait_order;

    event start_event;
    event data_event;
    event done_event;

    bit start_seen;
    bit data_seen;
    bit done_seen;

    initial begin

        fork

            begin
                #5;
                $display("[%0t] Start event triggered", $time);
                -> start_event;
                start_seen = 1;
            end

            begin
                #10;
                $display("[%0t] Data event triggered", $time);
                -> data_event;
                data_seen = 1;
            end

            begin
                #15;
                $display("[%0t] Done event triggered", $time);
                -> done_event;
                done_seen = 1;
            end

        join_none

        @start_event;

        if (!start_seen)
            $display("[%0t] Start event order error", $time);
        else
            $display("[%0t] Start event received", $time);

        @data_event;

        if (!data_seen)
            $display("[%0t] Data event order error", $time);
        else
            $display("[%0t] Data event received", $time);

        @done_event;

        if (!done_seen)
            $display("[%0t] Done event order error", $time);
        else
            $display("[%0t] Done event received", $time);

        $display("[%0t] Events occurred in required order", $time);

    end

endmodule
```

### Expected Output

With a 1-ps simulator time resolution:

```text
# run 1000ns
[5000] Start event triggered
[5000] Start event received
[10000] Data event triggered
[10000] Data event received
[15000] Done event triggered
[15000] Done event received
[15000] Events occurred in required order
```

The required order is:

```text
start_event → data_event → done_event
```

If the events occur out of order, the `else` branch executes.

### Verification Relevance

`wait_order` is useful when a verification environment must ensure that important activities happen in a specific sequence.

For example, a testbench may require:

```text
Reset complete
      ↓
Configuration complete
      ↓
Transaction started
      ↓
Transaction completed
```

This makes `wait_order` useful for checking and synchronizing ordered verification activities.
