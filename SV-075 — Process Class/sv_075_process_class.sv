module sv_075_process_class;

    process current_process;
    process worker_process;

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

        current_process = process::self();

        $display("[%0t] Current process status = %s",
                 $time,
                 process_status_name(current_process.status()));

        fork

            begin
                worker_process = process::self();

                $display("[%0t] Worker started", $time);

                $display("[%0t] Worker status = %s",
                         $time,
                         process_status_name(worker_process.status()));

                #10;

                $display("[%0t] Worker completed", $time);
            end

        join_none

        #2;

        $display("[%0t] Worker process status = %s",
                 $time,
                 process_status_name(worker_process.status()));

        wait fork;

        $display("[%0t] Worker process status after completion = %s",
                 $time,
                 process_status_name(worker_process.status()));

    end

endmodule