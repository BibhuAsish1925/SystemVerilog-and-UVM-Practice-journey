# 072 — SV-072 — `wait fork`

## Concept

`wait fork` is used to wait until all currently spawned child processes of the calling process have completed.

It is particularly useful with `fork...join_none`, because `join_none` allows the parent process to continue immediately.

```systemverilog id="1s7k3m"
fork
    // Concurrent processes
join_none

// Parent continues

wait fork;

// All spawned processes are complete
```

## Execution Flow

In this example:

```text id="8q2m5v"
Process 1 → #10
Process 2 → #5
Process 3 → #15
```

The parent continues immediately after `join_none`.

When it reaches:

```systemverilog id="6p4x8z"
wait fork;
```

it waits until all three processes have completed.

The last process completes at 15 ns, so the parent continues at 15 ns.

## Important Difference

```text id="4n8w2c"
fork...join
    → Waits automatically for all processes

fork...join_none
    → Does not wait

wait fork
    → Explicitly waits for spawned processes
```

## Verification Relevance

`wait fork` is useful for synchronizing a verification process with background activities.

A test can start multiple concurrent operations using `fork...join_none`, perform other work, and later use `wait fork` when it needs to ensure all spawned activities have completed.

## Complete Runnable Code

```systemverilog id="6j3p9w"
module sv_072_wait_fork;

    initial begin

        $display("[%0t] Main process started", $time);

        fork

            begin
                #10;
                $display("[%0t] Background process 1 completed", $time);
            end

            begin
                #5;
                $display("[%0t] Background process 2 completed", $time);
            end

            begin
                #15;
                $display("[%0t] Background process 3 completed", $time);
            end

        join_none

        $display("[%0t] Main process continues", $time);

        // Wait for all spawned processes
        wait fork;

        $display("[%0t] All spawned processes completed", $time);

    end

endmodule
```

## Expected Output

```text id="r4v7mx"
[0] Main process started
[0] Main process continues
[5] Background process 2 completed
[10] Background process 1 completed
[15] Background process 3 completed
[15] All spawned processes completed
```

The parent continues immediately after `join_none`, then `wait fork` synchronizes it with all spawned processes.
