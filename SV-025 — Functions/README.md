# 025 — SV-025 — Functions

A **function** is a reusable block of SystemVerilog code that performs a specific operation and returns a value.

Functions help reduce repeated code and make verification code easier to organize.

## 1. Function Declaration

Basic syntax:

```systemverilog
function return_type function_name(input type argument);
    // function body
    return value;
endfunction
```

Example:

```systemverilog
function int add_numbers(input int a, input int b);
    return a + b;
endfunction
```

Here:

- `function` declares the function.
- `int` is the return type.
- `add_numbers` is the function name.
- `a` and `b` are input arguments.
- `return` provides the function result.

## 2. Function Arguments

Arguments allow values to be passed into a function.

```systemverilog
add_numbers(10, 20);
```

The value `10` is passed to `a`, and `20` is passed to `b`.

## 3. Return Value

The function returns the result using:

```systemverilog
return a + b;
```

The returned value can be assigned to a variable:

```systemverilog
result = add_numbers(10, 20);
```

It can also be used directly in an expression:

```systemverilog
$display("%0d", add_numbers(5, 15));
```

## Verification Relevance

Functions are commonly used in verification for:

- Data calculations
- Reference-model operations
- Comparisons and checks
- Reusable testbench utilities
- Address/data transformations
- Protocol-related helper operations

## Complete Runnable Code

```systemverilog
module sv_025_functions;

    // Function declaration with two arguments and an integer return value
    function int add_numbers(input int a, input int b);
        return a + b;
    endfunction

    int result;

    initial begin
        result = add_numbers(10, 20);

        $display("10 + 20 = %0d", result);
        $display("5 + 15  = %0d", add_numbers(5, 15));
    end

endmodule
```