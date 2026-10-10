
# 175 — UVM-026 — Field Macros

## 1. Introduction

UVM field macros register class fields for common UVM data operations,
including printing, copying, and comparison.

Use `uvm_object_utils_begin` and `uvm_object_utils_end` to define a
field registration block.

### Integer Fields

```systemverilog
`uvm_field_int(data, UVM_DEFAULT)
```

Registers an integral field such as `bit`, `logic`, or `int`.

### Enum Fields

```systemverilog
`uvm_field_enum(uvm_026_operation_e, operation, UVM_DEFAULT)
```

Registers an enumeration field using its enum type.

### Array Fields

```systemverilog
`uvm_field_array_int(payload, UVM_DEFAULT)
```

Registers an array of integral elements.

### Object Fields

```systemverilog
`uvm_field_object(details, UVM_DEFAULT)
```

Registers a nested UVM object so supported field operations can
also process that object.

## 2. Complete Runnable Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [1:0] {
    IDLE, WRITE, READ, DONE
} uvm_026_operation_e;

class uvm_026_details extends uvm_object;
    `uvm_object_utils_begin(uvm_026_details)
        `uvm_field_int(id, UVM_DEFAULT)
    `uvm_object_utils_end

    int unsigned id;

    function new(string name = "uvm_026_details");
        super.new(name);
    endfunction
endclass

class uvm_026_transaction extends uvm_object;
    `uvm_object_utils_begin(uvm_026_transaction)
        `uvm_field_int(data, UVM_DEFAULT)
        `uvm_field_enum(uvm_026_operation_e, operation, UVM_DEFAULT)
        `uvm_field_array_int(payload, UVM_DEFAULT)
        `uvm_field_object(details, UVM_DEFAULT)
    `uvm_object_utils_end

    bit [7:0] data;
    uvm_026_operation_e operation;
    bit [7:0] payload[];
    uvm_026_details details;

    function new(string name = "uvm_026_transaction");
        super.new(name);
    endfunction
endclass

class uvm_026_test extends uvm_test;
    `uvm_component_utils(uvm_026_test)

    uvm_026_transaction tx;

    function new(string name = "uvm_026_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        tx = uvm_026_transaction::type_id::create("tx");
        tx.data = 8'hA5;
        tx.operation = WRITE;

        tx.payload = new[3];
        tx.payload[0] = 8'h11;
        tx.payload[1] = 8'h22;
        tx.payload[2] = 8'h33;

        tx.details = uvm_026_details::type_id::create("details");
        tx.details.id = 25;

        `uvm_info("FIELDS", "Printing transaction fields", UVM_LOW)
        tx.print();
    endfunction
endclass

module uvm_026_field_macros_tb;
    initial
        run_test("uvm_026_test");
endmodule
```

## 3. Expected Output

The printer output should show:

- `data = 0xA5`
- `operation = WRITE`
- `payload = 11, 22, 33`
- `details.id = 25`

Exact printer formatting can vary.

## 4. Vivado Usage

1. Create `uvm_026_field_macros.sv` under Simulation Sources.
2. Set `uvm_026_field_macros_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Confirm that `tx.print()` displays all registered fields.

## 5. Key Takeaways

- Field macros register fields for UVM automation.
- Use `uvm_field_int` for integral fields.
- Use `uvm_field_enum` for enum fields.
- Use `uvm_field_array_int` for integral arrays.
- Use `uvm_field_object` for nested objects.
- Field registration does not automatically print anything; call `print()` to display fields.
