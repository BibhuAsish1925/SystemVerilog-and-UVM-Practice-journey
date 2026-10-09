 # 173 — UVM-024 — Factory

## 1. Introduction

The UVM Factory creates registered UVM objects and components. It allows classes to be constructed through the factory instead of directly using `new()`.

### Type Registration

Register a class using the appropriate macro:

* `uvm_object_utils(ClassName)` for objects.
* `uvm_component_utils(ClassName)` for components.

Registration makes the class available to the factory; it does not create an instance.

### Factory Creation

Create a registered object using:

systemverilog

```
item = uvm_024_item::type_id::create("item");
```

Factory creation supports factory overrides, allowing a compatible replacement class to be selected without changing the creation call.

## 2. Complete Runnable Code

systemverilog

```
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_024_item extends uvm_object;
    `uvm_object_utils(uvm_024_item)

    bit [7:0] data;

    function new(string name = "uvm_024_item");
        super.new(name);
    endfunction
endclass

class uvm_024_test extends uvm_test;
    `uvm_component_utils(uvm_024_test)

    uvm_024_item item;

    function new(string name = "uvm_024_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        item = uvm_024_item::type_id::create("item");
        item.data = 8'hA5;

        `uvm_info("FACTORY",
            $sformatf("Object created: %s, data = 0x%02h",
                      item.get_name(), item.data),
            UVM_MEDIUM)
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);

        `uvm_info("FACTORY",
            $sformatf("Test component: %s", get_full_name()),
            UVM_MEDIUM)
    endfunction
endclass

module uvm_024_factory_tb;
    initial
        run_test("uvm_024_test");
endmodule
```

## 3. Expected Output

```
UVM_INFO ... [FACTORY] Object created: item, data = 0xA5
UVM_INFO ... [FACTORY] Test component: uvm_test_top
```

## 4. Key Takeaways

* Register objects with `uvm_object_utils`.
* Register components with `uvm_component_utils`.
* Use `type_id::create()` for factory-based creation.
* Factory registration and object creation are separate operations.
* Factory overrides are a major benefit of factory-based creation.

## 5. Vivado Usage

1. Create `uvm_024_factory.sv` under Simulation Sources.
2. Set `uvm_024_factory_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Check the Tcl Console for the two `[FACTORY]` messages.
