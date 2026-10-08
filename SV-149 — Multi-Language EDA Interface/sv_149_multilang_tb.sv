module sv_149_multilang_tb;

    import "DPI-C" function int sv149_c_add(
        input int a,
        input int b
    );

    int a;
    int b;
    int c_result;

    initial begin

        a = 25;
        b = 17;

        c_result = sv149_c_add(a, b);

        $display("[SV] SystemVerilog: a = %0d", a);
        $display("[SV] SystemVerilog: b = %0d", b);
        $display("[SV] C result through DPI-C = %0d", c_result);

        if (c_result == 42)
            $display("[SV] DPI-C communication: PASS");
        else
            $display("[SV] DPI-C communication: FAIL");

        $finish;
    end

endmodule