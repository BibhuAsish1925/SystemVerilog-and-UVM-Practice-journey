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

        // Create a worker process
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

        // Suspend the worker
        worker_process.suspend();

        $display("[%0t] Worker suspended | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        #3;

        // Resume the worker
        worker_process.resume();

        $display("[%0t] Worker resumed | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        // Wait for worker to finish
        worker_process.await();

        $display("[%0t] Worker finished | Status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        // Create another process for kill() demonstration
        fork
            begin
                kill_process = process::self();

                $display("[%0t] Kill-process started", $time);

                #20;

                $display("[%0t] Kill-process completed normally", $time);
            end
        join_none

        #5;

        // Terminate the process
        kill_process.kill();

        $display("[%0t] Kill-process terminated | Status = %s",
                 $time,
                 process_status_name(kill_process.status()));

    end

endmodule