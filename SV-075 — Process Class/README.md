# 075 — SV-075 — Process Class

SystemVerilog provides the built-in **`process` class** for inspecting and controlling simulation processes.

A process handle can be declared using:

```systemverilog
process worker_process;
```

The static method:

```systemverilog
process::self()
```

returns the process object representing the currently executing process.

For example:

```systemverilog
worker_process = process::self();
```

The current state of a process can be obtained using:

```systemverilog
worker_process.status()
```

Common process states include:

* `RUNNING` — the process is currently executing.
* `WAITING` — the process is waiting for a delay, event, or synchronization condition.
* `FINISHED` — the process has completed execution.
* `SUSPENDED` — the process has been suspended.
* `KILLED` — the process has been terminated.

### Complete Runnable Example

```systemverilog
module sv_075_process_class;

    process current_process;
    process worker_process;

    initial begin

        current_process = process::self();

        $display("[%0t] Current process status = %s",
                 $time, current_process.status());

        fork
            begin
                worker_process = process::self();

                $display("[%0t] Worker started", $time);
                $display("[%0t] Worker status = %s",
                         $time, worker_process.status());

                #10;

                $display("[%0t] Worker completed", $time);
            end
        join_none

        #2;

        $display("[%0t] Worker process status = %s",
                 $time, worker_process.status());

        wait fork;

        $display("[%0t] Worker process status after completion = %s",
                 $time, worker_process.status());

    end

endmodule
```

### Expected Output

Typical output:

```text
[0] Current process status = RUNNING
[0] Worker started
[0] Worker status = RUNNING
[2] Worker process status = WAITING
[10] Worker completed
[10] Worker process status after completion = FINISHED
```

The process state changes as the process executes and waits.

### Verification Relevance

The `process` class becomes useful when a verification environment has multiple concurrent activities that need to be monitored or controlled.

`process::self()` allows a process to obtain its own process handle, while `status()` allows another part of the testbench to inspect its current state.

This provides the foundation for later process-control operations such as suspending, resuming, or terminating concurrent verification processes.
