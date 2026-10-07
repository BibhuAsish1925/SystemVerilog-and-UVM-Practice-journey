# 076 — SV-076 — Process Control

SystemVerilog provides process-control methods through the built-in `process` class.

A process handle can be used to control a concurrent process.

### Process Control Methods

| Method      | Purpose                                           |
| ----------- | ------------------------------------------------- |
| `kill()`    | Terminates the process                            |
| `suspend()` | Pauses the process                                |
| `resume()`  | Continues a suspended process                     |
| `await()`   | Waits until the process finishes or is terminated |

A process handle can be obtained from the currently executing process using:

```systemverilog
process::self()
```

For example:

```systemverilog
worker_process = process::self();
```

The process can then be controlled through the handle:

```systemverilog
worker_process.suspend();
worker_process.resume();
worker_process.await();
worker_process.kill();
```

### Process State Flow

A typical suspended process can transition as:

```text
RUNNING
   |
   | suspend()
   v
SUSPENDED
   |
   | resume()
   v
RUNNING
   |
   | completes
   v
FINISHED
```

A process terminated using `kill()` reaches the `KILLED` state.

### Complete Runnable Example

```systemverilog
module sv_076_process_control;

    process worker_process;
    process kill_process;

    function string process_status_name(process::state status);

        case (status)
            process::FINISHED:  return "FINISHED";
            process::RUNNING:   return "RUNNING";
            process::WAITING:   return "WAITING";
            process::SUSPENDED: return "SUSPENDED";
            process::KILLED:    return "KILLED";
            default:            return "UNKNOWN";
        endcase

    endfunction

    initial begin

        fork
            begin
                worker_process = process::self();

                $display("[%0t] Worker started", $time);

                #10;
                $display("[%0t] Worker reached first point", $time);

                #10;
                $display("[%0t] Worker completed", $time);
            end
        join_none

        #2;

        worker_process.suspend();

        $display("[%0t] Worker suspended | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        #3;

        worker_process.resume();

        $display("[%0t] Worker resumed | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        worker_process.await();

        $display("[%0t] Worker finished | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        fork
            begin
                kill_process = process::self();

                $display("[%0t] Kill-process started", $time);

                #20;

                $display("[%0t] Kill-process completed normally", $time);
            end
        join_none

        #5;

        kill_process.kill();

        $display("[%0t] Kill-process terminated | Status = %s",
                 $time,
                 process_status_name(kill_process.status()));

    end

endmodule
```

### Expected Behavior

Typical output with a 1-ps simulator time resolution:

```text
[0] Worker started
[2000] Worker suspended | Status = SUSPENDED
[5000] Worker resumed | Status = RUNNING
[15000] Worker reached first point
[25000] Worker completed
[25000] Worker finished | Status = FINISHED
[25000] Kill-process started
[30000] Kill-process terminated | Status = KILLED
```

The `await()` call blocks the controlling process until `worker_process` finishes.

The `kill()` call terminates `kill_process`, so its normal completion message is never reached.

### Verification Relevance

Process control is useful when a verification environment needs to manage concurrent activities.

For example, a testbench may start a stimulus process and a timeout process simultaneously. If the stimulus completes first, the timeout process can be terminated using `kill()`. Similarly, `suspend()` and `resume()` can temporarily control background activities, while `await()` can synchronize with process completion.
