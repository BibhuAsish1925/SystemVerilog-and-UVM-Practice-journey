# 029 — SV-029 — Void Functions

A **void function** performs an operation without returning a value.

SystemVerilog also provides `void'(expression)` to explicitly evaluate an expression and discard its return value.

## 1. `void` Return Type

A function can be declared with `void` as its return type:

```systemverilog
function void print_sum(input int a, input int b);
    $display("Sum = %0d", a + b);
endfunction
```

The function performs an operation but does not return a value to the caller.

It can be called normally:

```systemverilog
print_sum(10, 20);
```

## 2. `void'(expression)`

`void'(expression)` is a casting expression used when the result of an expression is intentionally not needed.

For example:

```systemverilog
void'(multiply(7, 3));
```

The `multiply()` function still returns its integer result, but the result is explicitly discarded.

This is different from declaring the function itself as `void`.

## Difference

| Syntax | Meaning |
|---|---|
| `function void ...` | Function has no return value |
| `void'(expression)` | Evaluate expression and discard its result |

## Verification Relevance

Void functions are useful for reusable operations that only perform an action, while `void'(expression)` is useful when a returned value is intentionally ignored.

They can appear in verification code for:

- Utility functions
- Logging operations
- Display/reporting helpers
- Explicitly discarded function results

## Complete Runnable Code

```systemverilog
module sv_029_void_functions;

    // Void function: performs an operation without returning a value
    function void print_sum(input int a, input int b);
        $display("Sum = %0d", a + b);
    endfunction

    // Normal function returning an integer
    function int multiply(input int a, input int b);
        return a * b;
    endfunction

    int result;

    initial begin
        print_sum(10, 20);

        result = multiply(5, 4);
        $display("Product = %0d", result);

        // Evaluate the function but intentionally discard its return value
        void'(multiply(7, 3));
        $display("Return value discarded using void'()");
    end

endmodule
```