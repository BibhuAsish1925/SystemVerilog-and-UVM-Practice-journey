module sv_078_mailbox;

    mailbox #(int) mbx;

    int value;
    int result;

    initial begin

        mbx = new(2);

        // put()
        mbx.put(10);
        mbx.put(20);

        $display("[%0t] After put(): mailbox size = %0d",
                 $time, mbx.num());

        // peek()
        mbx.peek(value);
        $display("[%0t] peek()    = %0d", $time, value);

        // try_peek()
        if (mbx.try_peek(value))
            $display("[%0t] try_peek() = %0d", $time, value);
        else
            $display("[%0t] try_peek() failed", $time);

        // get()
        mbx.get(value);
        $display("[%0t] get()     = %0d", $time, value);

        // try_get()
        if (mbx.try_get(value))
            $display("[%0t] try_get() = %0d", $time, value);
        else
            $display("[%0t] try_get() failed", $time);

        // try_put()
        if (mbx.try_put(30))
            $display("[%0t] try_put(30) = SUCCESS", $time);
        else
            $display("[%0t] try_put(30) = FAILED", $time);

        // Remove remaining item
        mbx.get(result);

        $display("[%0t] Final get() = %0d", $time, result);
        $display("[%0t] Final mailbox size = %0d",
                 $time, mbx.num());

    end

endmodule