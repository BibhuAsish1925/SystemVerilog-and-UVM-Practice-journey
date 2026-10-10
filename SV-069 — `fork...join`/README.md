# 069 — SV-069 — `fork...join`

## Concept

`fork...join` is used to execute multiple procedural blocks **concurrently**.

Each statement or `begin...end` block inside `fork...join` becomes an independent process.

```systemverilog
fork
    process_1;
    process_2;
    process_3;
join
```

All three processes start concurrently.

The `join` statement waits until **all forked processes have completed** before the parent process continues.

## Important Syntax

```systemverilog
fork

    begin
        // Process 1
    end

    begin
        // Process 2
    end

    begin
        // Process 3
    end

join
```

For example:

```text
Process 1 → #10
Process 2 → #5
Process 3 → #15
```

They execute concurrently, so their completion order is:

```text
5 ns  → Process 2
10 ns → Process 1
15 ns → Process 3
```

The parent process continues after 15 ns because that is when the last forked process completes.

## Verification Relevance

Concurrent processes are fundamental to SystemVerilog verification environments.

They are commonly used when multiple activities need to operate simultaneously, such as stimulus generation, monitoring, protocol checking, and timeout handling.

## Complete Runnable Code

```systemverilog
module sv_069_fork_join;

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

        join

        $display("[%0t] All processes completed", $time);

    end

endmodule
```

## Expected Output

```text
[0] Main process started
[5] Process 2 completed
[10] Process 1 completed
[15] Process 3 completed
[15] All processes completed
```

The exact output times depend on the delays specified in the processes.