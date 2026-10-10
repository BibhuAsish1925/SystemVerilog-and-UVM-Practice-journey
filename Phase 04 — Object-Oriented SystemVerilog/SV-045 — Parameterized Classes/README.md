# 045 — SV-045 — Parameterized Classes

A **parameterized class** allows a class to be configured with parameters when the class is instantiated. This makes the class reusable for different data widths or configurations.

### Basic Syntax

```systemverilog
class transaction #(parameter int WIDTH = 8);
    logic [WIDTH-1:0] data;
endclass
```

Here, `WIDTH` controls the size of the `data` property.

Different specializations can then be created:

```systemverilog
transaction #(8)  trans_8;
transaction #(16) trans_16;
transaction #(32) trans_32;
```

Each specialization uses the same class definition but has a different parameter value.

### Why it is useful in verification

Parameterized classes are useful for creating reusable **transaction classes**. Instead of creating separate classes for every data width, one class can be configured according to the required interface or protocol width.

For example:

- `transaction #(8)` → 8-bit transaction
- `transaction #(16)` → 16-bit transaction
- `transaction #(32)` → 32-bit transaction

### Complete Runnable Code

```systemverilog
module sv_045_parameterized_classes;

    // Parameterized transaction class
    class transaction #(parameter int WIDTH = 8);

        logic [WIDTH-1:0] data;

        function new(logic [WIDTH-1:0] data);
            this.data = data;
        endfunction

        function void display();
            $display("WIDTH = %0d | DATA = %h", WIDTH, data);
        endfunction

    endclass


    // Different specializations of the same class
    transaction #(8)  trans_8;
    transaction #(16) trans_16;
    transaction #(32) trans_32;

    initial begin

        // Create 8-bit transaction
        trans_8 = new(8'hA5);

        // Create 16-bit transaction
        trans_16 = new(16'h1234);

        // Create 32-bit transaction
        trans_32 = new(32'h12345678);

        // Display transactions
        trans_8.display();
        trans_16.display();
        trans_32.display();

    end

endmodule
```

### Expected Output

```text
WIDTH = 8 | DATA = a5
WIDTH = 16 | DATA = 1234
WIDTH = 32 | DATA = 12345678
```

**Key concepts:** `class #(parameter)`, class specialization, reusable transaction classes, parameter-controlled data width.