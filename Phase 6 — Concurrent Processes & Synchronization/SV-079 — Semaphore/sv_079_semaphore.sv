module sv_079_semaphore;

    semaphore sem;

    initial begin

        // Create semaphore with 2 keys
        sem = new(2);

        fork

            begin
                $display("[%0t] Process 1 requesting 1 key", $time);

                sem.get(1);

                $display("[%0t] Process 1 acquired key", $time);

                #10;

                sem.put(1);

                $display("[%0t] Process 1 returned key", $time);
            end

            begin
                #2;

                $display("[%0t] Process 2 requesting 1 key", $time);

                if (sem.try_get(1)) begin

                    $display("[%0t] Process 2 acquired key", $time);

                    #5;

                    sem.put(1);

                    $display("[%0t] Process 2 returned key", $time);

                end
                else begin

                    $display("[%0t] Process 2 could not acquire key",
                             $time);

                end
            end

        join

        $display("[%0t] All processes completed", $time);

    end

endmodule