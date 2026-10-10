`timescale 1ns/1ps

module sv_142_generate_unit #(
    parameter bit USE_XOR = 1'b0
)(
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [3:0] y
);

    logic [3:0] and_result;

    // Generate-for: create four AND operations
    genvar i;

    generate
        for (i = 0; i < 4; i++) begin : gen_and
            assign and_result[i] = a[i] & b[i];
        end
    endgenerate

    // Generate-if: select hardware at elaboration time
    generate
        if (USE_XOR) begin : gen_xor
            assign y = a ^ b;
        end
        else begin : gen_and_output
            assign y = and_result;
        end
    endgenerate

endmodule


module sv_142_generate_constructs_tb;

    logic [3:0] a;
    logic [3:0] b;

    logic [3:0] y_and;
    logic [3:0] y_xor;

    sv_142_generate_unit #(
        .USE_XOR(1'b0)
    ) and_unit (
        .a(a),
        .b(b),
        .y(y_and)
    );

    sv_142_generate_unit #(
        .USE_XOR(1'b1)
    ) xor_unit (
        .a(a),
        .b(b),
        .y(y_xor)
    );

    initial begin

        a = 4'b1100;
        b = 4'b1010;

        #1;

        $display("Generate-for AND result = %b", y_and);
        $display("Generate-if  XOR result = %b", y_xor);

        a = 4'b1111;
        b = 4'b0011;

        #1;

        $display("Generate-for AND result = %b", y_and);
        $display("Generate-if  XOR result = %b", y_xor);

        $finish;

    end

endmodule