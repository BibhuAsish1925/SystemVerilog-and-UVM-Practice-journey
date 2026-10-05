package verification_pkg;

    typedef logic [7:0] data_t;

    typedef enum {
        IDLE,
        WRITE,
        READ,
        DONE
    } operation_t;

    class transaction;

        data_t data;
        operation_t operation;

        function new(data_t data, operation_t operation);
            this.data = data;
            this.operation = operation;
        endfunction

        function void display();
            $display("Transaction: operation=%s, data=%h",
                     operation.name(), data);
        endfunction

    endclass

    function automatic int add_numbers(input int a, input int b);
        return a + b;
    endfunction

endpackage


module sv_031_package_types_classes;

    import verification_pkg::*;

    transaction trans;
    int result;

    initial begin

        trans = new(8'hA5, WRITE);
        trans.display();

        result = add_numbers(10, 20);
        $display("Package function result = %0d", result);

    end

endmodule