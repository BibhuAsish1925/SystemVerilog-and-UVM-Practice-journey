# 070 — SV-070 — `fork...join_any`

## Concept

`fork...join_any` starts multiple processes concurrently and allows the parent process to continue as soon as **any one** of those processes finishes.

Unlike `fork...join`, it does not wait for all forked processes.

```systemverilog
fork
    process_1;
    process_2;
    process_3;
join_any
```

The parent process continues when the first process completes.

## Example

If the processes have these delays:

```text
Process 1 → #10
Process 2 → #5
Process 3 → #15
```

Process 2 finishes first at 5 ns.

Therefore, `join_any` releases the parent process at 5 ns.

## Important Difference

```text
fork...join
    → Wait for ALL processes

fork...join_any
    → Wait for ANY ONE process
```

The other forked processes are **not automatically terminated** by `join_any`.

## Verification Relevance

`fork...join_any` is useful when a verification process should continue after the first of several events occurs.

Common examples include waiting for either a response or a timeout, or waiting for the first completion among multiple concurrent activities.

## Complete Runnable Code

```systemverilog
module sv_070_fork_join_any;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #10;
                $display("[%0t] Process 1 completed", $time);
            end

            begin
                #5;
                $display("[%0t] Process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Process 3 completed", $time);
            end

        join_any

        $display("[%0t] First process completed", $time);

    end

endmodule
```

## Expected Output

```text
[0] Main process started
[5] Process 2 completed
[5] First process completed
```

Process 2 finishes first, so the parent process continues at 5 ns.