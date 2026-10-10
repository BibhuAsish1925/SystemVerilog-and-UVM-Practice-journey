module sv_003_signed_unsigned;

    logic signed [7:0]   signed_8;
    logic        [7:0]   unsigned_8;

    logic signed [15:0]  signed_16;
    logic        [15:0]  unsigned_16;

    initial begin
        signed_8   = -8'sd5;
        unsigned_8 = 8'd251;       // Same bits as -5

        // Sign extension: signed value extends with its sign bit
        signed_16   = signed_8;
        unsigned_16 = unsigned_8;

        $display("signed_8    = %0d", signed_8);
        $display("unsigned_8  = %0d", unsigned_8);

        $display("signed_16   = %0d", signed_16);
        $display("unsigned_16 = %0d", unsigned_16);

        $display("signed 8 + 3   = %0d", signed_8 + 8'sd3);
        $display("unsigned 8 + 3 = %0d", unsigned_8 + 8'd3);
    end

endmodule