# 031 — SV-031 — Package + Types + Classes

A SystemVerilog package can group reusable **typedefs, enums, classes, and functions** into one namespace.

This structure is especially useful in verification environments where common transaction types, states, classes, and utility functions need to be shared across multiple components.

## 1. Typedefs in a Package

A custom data type can be defined inside the package:

```systemverilog
typedef logic [7:0] data_t;
```

This allows `data_t` to be reused wherever the package is imported.

## 2. Enums in a Package

An enumeration can represent defined transaction or protocol states:

```systemverilog
typedef enum {
    IDLE,
    WRITE,
    READ,
    DONE
} operation_t;
```

The enum type can then be used by classes or other testbench components.

## 3. Classes in a Package

Classes can also be declared inside a package:

```systemverilog
class transaction;

    data_t data;
    operation_t operation;

    function new(data_t data, operation_t operation);
        this.data = data;
        this.operation = operation;
    endfunction

endclass
```

The class can use types defined earlier in the same package.

## 4. Package Functions

Reusable utility functions can be placed inside the package:

```systemverilog
function automatic int add_numbers(input int a, input int b);
    return a + b;
endfunction
```

After importing the package:

```systemverilog
import verification_pkg::*;
```

the package members can be used directly.

## Verification Relevance

This organization is commonly used to share:

- Transaction data types
- Protocol enums
- Verification classes
- Utility functions
- Common parameters and typedefs

It provides a foundation for larger non-UVM and UVM verification environments.

## Complete Runnable Code

```systemverilog
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
```