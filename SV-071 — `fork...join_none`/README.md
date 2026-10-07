# 071 — SV-071 — `fork...join_none`

## Concept

`fork...join_none` starts multiple processes concurrently and allows the parent process to continue **immediately**.

The parent does not wait for any of the forked processes to complete.

```systemverilog id="q1p6zv"
fork
    process_1;
    process_2;
    process_3;
join_none
```

The forked processes continue running independently in the background.

## Important Difference

```text id="z5m8ck"
fork...join
    → Wait for ALL processes

fork...join_any
    → Wait for ANY ONE process

fork...join_none
    → Do NOT wait
```

For example:

```text id="8g3x2n"
Process 1 → #10
Process 2 → #5
Process 3 → #15
```

With `join_none`, the parent continues immediately at time 0.

The background processes then complete at 5 ns, 10 ns, and 15 ns.

## Verification Relevance

`fork...join_none` is useful for starting background activities that should run independently of the main verification flow.

Typical examples include background monitoring, timeout processes, periodic checks, and other concurrent verification activities.

## Complete Runnable Code

```systemverilog id="r6t2wp"
module sv_071_fork_join_none;

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

        #20;

        $display("[%0t] Main process completed", $time);

    end

endmodule
```

## Expected Output

```text id="f9q4mv"
[0] Main process started
[0] Main process continues
[5] Background process 2 completed
[10] Background process 1 completed
[15] Background process 3 completed
[20] Main process completed
```

The parent continues immediately, while the forked processes execute in the background.
