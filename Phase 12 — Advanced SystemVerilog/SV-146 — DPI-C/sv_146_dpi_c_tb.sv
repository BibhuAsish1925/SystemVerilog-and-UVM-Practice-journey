`timescale 1ns/1ps

module sv_146_dpi_c_tb;

    import "DPI-C" function int sv146_c_add(
        input int a,
        input int b
    );

    int a;
    int b;
    int result;

    initial begin

        a = 25;
        b = 17;

        result = sv146_c_add(a, b);

        $display("SystemVerilog: a = %0d", a);
        $display("SystemVerilog: b = %0d", b);
        $display("C function result = %0d", result);

        if (result == (a + b))
            $display("DPI-C communication: PASS");
        else
            $error("DPI-C communication: FAIL");

        $finish;

    end

endmodule