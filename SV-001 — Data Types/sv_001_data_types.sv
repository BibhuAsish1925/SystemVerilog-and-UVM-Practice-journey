module sv_001_data_types;

    bit       b;       // 2-state: 0, 1
    logic     l;       // 4-state: 0, 1, X, Z
    reg       r;       // 4-state, legacy Verilog type

    byte      by;      // 8-bit signed integer
    shortint  si;      // 16-bit signed integer
    int       i;       // 32-bit signed integer
    longint   li;      // 64-bit signed integer
    integer   iv;      // 32-bit signed, 4-state
    time      t;       // 64-bit unsigned simulation time

    initial begin
        b  = 1'b1;
        l  = 1'bx;
        r  = 1'bz;

        by = 8'd100;
        si = 16'd1000;
        i  = 32'd100000;
        li = 64'd1000000;
        iv = -50;

        #10;
        t = $time;

        $display("bit       = %b", b);
        $display("logic     = %b", l);
        $display("reg       = %b", r);
        $display("byte      = %0d", by);
        $display("shortint  = %0d", si);
        $display("int       = %0d", i);
        $display("longint   = %0d", li);
        $display("integer   = %0d", iv);
        $display("time      = %0t", t);
    end

endmodule