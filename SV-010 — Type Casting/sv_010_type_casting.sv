module sv_010_type_casting;

    logic [7:0]  data;
    logic [15:0] extended_data;
    int          int_value;
    logic        logic_value;

    initial begin
        data = 8'hA5;

        // Static cast to int
        int_value = int'(data);

        // Static cast to logic
        logic_value = logic'(1'b1);

        // Type conversion with a wider destination
        extended_data = int'(data);

        $display("Original data    = %h", data);
        $display("int'(data)       = %0d", int_value);
        $display("logic'(1'b1)     = %b", logic_value);
        $display("Extended data    = %h", extended_data);
    end

endmodule