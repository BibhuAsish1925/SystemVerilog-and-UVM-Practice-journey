# 073 — SV-073 — `disable fork`

## Concept

`disable fork` terminates the currently active child processes spawned by the current process.

It is commonly used together with `fork...join_any`.

```systemverilog id="6p3v9x"
fork
    process_1;
    process_2;
    process_3;
join_any

disable fork;
```

`join_any` releases the parent when the first process completes. `disable fork` then terminates the remaining active processes.

## Execution Flow

In this example:

```text id="2n8c5m"
Process 1 → #5
Process 2 → #10
Process 3 → #15
```

Process 1 finishes first at 5 ns.

Then:

```systemverilog id="8w4k1z"
join_any
```

allows the parent process to continue.

Next:

```systemverilog id="3r7m2q"
disable fork;
```

terminates Process 2 and Process 3.

Therefore, they never reach their `$display()` statements.

## Important Difference

```text id="0v6k3p"
fork...join
    → Wait for all processes

fork...join_any
    → Continue after first process

fork...join_none
    → Continue immediately

wait fork
    → Wait for spawned processes

disable fork
    → Terminate active spawned processes
```

## Verification Relevance

`disable fork` is useful when multiple concurrent activities are racing and only the first completed activity matters.

A common verification example is waiting for either a DUT response or a timeout. Once one event occurs, the remaining process can be terminated to avoid unnecessary activity.

## Complete Runnable Code

```systemverilog id="1q9m4x"
module sv_073_disable_fork;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #5;
                $display("[%0t] Process 1 completed", $time);
            end

            begin
                #10;
                $display("[%0t] Process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Process 3 completed", $time);
            end

        join_any

        $display("[%0t] First process completed", $time);

        // Terminate remaining forked processes
        disable fork;

        $display("[%0t] Remaining processes terminated", $time);

    end

endmodule
```

## Expected Output

```text id="7c5n2m"
[0] Main process started
[5] Process 1 completed
[5] First process completed
[5] Remaining processes terminated
```

Process 1 completes first. `disable fork` then terminates the remaining active processes.
