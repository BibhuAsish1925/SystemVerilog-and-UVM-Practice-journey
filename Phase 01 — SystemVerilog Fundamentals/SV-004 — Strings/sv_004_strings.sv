module sv_004_strings;

    string name;
    string message;

    initial begin
        // Declaration and assignment
        name    = "Bibhu";
        message = "SystemVerilog";

        $display("name    = %s", name);
        $display("message = %s", message);

        // String methods
        $display("length  = %0d", message.len());

        message = message.toupper();
        $display("upper   = %s", message);

        message = message.tolower();
        $display("lower   = %s", message);

        // Comparison
        if (name == "Bibhu")
            $display("comparison = MATCH");
        else
            $display("comparison = NO MATCH");

        // Formatting
        $display("formatted = Name: %s | Topic: %s", name, message);
    end

endmodule