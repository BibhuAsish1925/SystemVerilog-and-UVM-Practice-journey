module sv_027_function_task_arguments;

    // input: value is passed into the task
    task automatic show_input(input int value);
        $display("input  value  = %0d", value);
    endtask

    // output: task produces a result for the caller
    task automatic calculate_sum(
        input  int a,
        input  int b,
        output int result
    );
        result = a + b;
    endtask

    // inout: task can read and modify the argument
    task automatic increment_inout(inout int value);
        value = value + 1;
    endtask

    // ref: task directly accesses the caller's variable
    task automatic increment_ref(ref int value);
        value = value + 10;
    endtask

    int result;
    int data;

    initial begin

        show_input(25);

        calculate_sum(10, 20, result);
        $display("output result = %0d", result);

        data = 5;
        increment_inout(data);
        $display("inout data     = %0d", data);

        data = 5;
        increment_ref(data);
        $display("ref data       = %0d", data);

    end

endmodule