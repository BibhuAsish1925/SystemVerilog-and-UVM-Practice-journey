# 074 — SV-074 — Events

SystemVerilog **events** provide a simple way for concurrent processes to synchronize with each other.

An event is declared using `event`:

```systemverilog
event transaction_done;
```

The event can then be triggered using the event trigger operator:

```systemverilog
-> transaction_done;
```

Another process can wait for the event using:

```systemverilog
@transaction_done;
```

The waiting process continues when the event is triggered.

SystemVerilog also provides the `triggered` property:

```systemverilog
transaction_done.triggered
```

It can be used to check whether the event has been triggered during the current simulation time slot.

Events are useful in verification environments when one process needs to notify another process that an operation, transaction, or synchronization point has been reached.

### Important Syntax

| Syntax           | Purpose                                |
| ---------------- | -------------------------------------- |
| `event name;`    | Declares an event                      |
| `-> name;`       | Triggers the event                     |
| `@name;`         | Waits for the event                    |
| `name.triggered` | Checks whether the event was triggered |

### Complete Runnable Example

```systemverilog
module sv_074_events;

    event transaction_done;

    initial begin
        #10;
        $display("[%0t] Producer: Transaction completed", $time);

        -> transaction_done;

        $display("[%0t] Producer: Event triggered", $time);
    end

    initial begin
        $display("[%0t] Consumer: Waiting for event", $time);

        @transaction_done;

        $display("[%0t] Consumer: Event received", $time);
    end

    initial begin
        #10;

        if (transaction_done.triggered)
            $display("[%0t] Monitor: Event was triggered", $time);
        else
            $display("[%0t] Monitor: Event was not triggered", $time);
    end

endmodule
```

### Expected Behavior

The consumer initially waits for the event. At time 10, the producer triggers `transaction_done`. The waiting consumer then continues execution.

Typical output:

```text
[0] Consumer: Waiting for event
[10] Producer: Transaction completed
[10] Producer: Event triggered
[10] Consumer: Event received
[10] Monitor: Event was triggered
```

The exact ordering of messages at the same simulation time can vary because the processes execute concurrently.

### Verification Relevance

Events are useful for synchronizing independent testbench processes. For example, one process can trigger an event after completing a transaction while another process waits for that event before continuing.

They provide a lightweight synchronization mechanism that becomes useful when building more advanced SystemVerilog testbenches and verification components.
