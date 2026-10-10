module sv_009_union;

    // Unpacked union
    typedef union {
        int  int_value;
        byte byte_value;
    } data_u;

    // Packed union
    // All members must have the same size: 8 bits
    typedef union packed {
        logic [7:0] byte_value;
        logic [7:0] bits;
        logic signed [7:0] signed_value;
    } packed_u;

    data_u   data;
    packed_u packet;

    initial begin
        // -------------------------------
        // Unpacked Union
        // -------------------------------
        data.int_value = 32'h12345678;

        $display("Unpacked Union:");
        $display("int_value  = %h", data.int_value);

        // Same storage is now written through byte_value
        data.byte_value = 8'hA5;

        $display("byte_value = %h", data.byte_value);

        // -------------------------------
        // Packed Union
        // -------------------------------
        packet.bits = 8'hA5;

        $display("\nPacked Union:");
        $display("bits         = %h", packet.bits);
        $display("byte_value   = %h", packet.byte_value);
        $display("signed_value = %0d", packet.signed_value);
    end

endmodule