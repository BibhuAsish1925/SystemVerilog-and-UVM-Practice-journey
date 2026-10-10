
# 174 — UVM-025 — Factory Override

## 1. Introduction

Factory overrides let a UVM testbench substitute a registered class
without changing the original `type_id::create()` call.

### Type Override

A type override replaces the requested type wherever the factory resolves
that type, unless a more specific applicable override takes precedence.

```systemverilog
uvm_025_base_item::type_id::set_type_override(
    uvm_025_type_item::get_type()
);
```

### Instance Override

An instance override replaces the requested type only for a matching
factory instance path.

```systemverilog
uvm_025_base_item::type_id::set_inst_override(
    uvm_025_inst_item::get_type(),
    "inst_item",
    this
);
```

## 2. Complete Runnable Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_025_base_item extends uvm_object;
    `uvm_object_utils(uvm_025_base_item)

    function new(string name = "uvm_025_base_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "BASE";
    endfunction
endclass

class uvm_025_type_item extends uvm_025_base_item;
    `uvm_object_utils(uvm_025_type_item)

    function new(string name = "uvm_025_type_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "TYPE_REPLACEMENT";
    endfunction
endclass

class uvm_025_inst_item extends uvm_025_base_item;
    `uvm_object_utils(uvm_025_inst_item)

    function new(string name = "uvm_025_inst_item");
        super.new(name);
    endfunction

    virtual function string get_kind();
        return "INSTANCE_REPLACEMENT";
    endfunction
endclass

class uvm_025_test extends uvm_test;
    `uvm_component_utils(uvm_025_test)

    uvm_025_base_item type_item;
    uvm_025_base_item normal_item;
    uvm_025_base_item inst_item;

    function new(string name = "uvm_025_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_025_base_item::type_id::set_inst_override(
            uvm_025_inst_item::get_type(),
            "inst_item",
            this
        );

        uvm_025_base_item::type_id::set_type_override(
            uvm_025_type_item::get_type()
        );

        type_item = uvm_025_base_item::type_id::create(
            "type_item", this
        );

        normal_item = uvm_025_base_item::type_id::create(
            "normal_item", this
        );

        inst_item = uvm_025_base_item::type_id::create(
            "inst_item", this
        );

        `uvm_info("TYPE_OVERRIDE",
            $sformatf("type_item = %s", type_item.get_kind()),
            UVM_MEDIUM)

        `uvm_info("TYPE_OVERRIDE",
            $sformatf("normal_item = %s", normal_item.get_kind()),
            UVM_MEDIUM)

        `uvm_info("INSTANCE_OVERRIDE",
            $sformatf("inst_item = %s", inst_item.get_kind()),
            UVM_MEDIUM)
    endfunction
endclass

module uvm_025_factory_override_tb;
    initial begin
        $display("[TOP] Starting UVM-025 Factory Override");
        run_test("uvm_025_test");
    end
endmodule
```

## 3. Expected Output

```text
[TOP] Starting UVM-025 Factory Override
UVM_INFO ... [TYPE_OVERRIDE] type_item = TYPE_REPLACEMENT
UVM_INFO ... [TYPE_OVERRIDE] normal_item = TYPE_REPLACEMENT
UVM_INFO ... [INSTANCE_OVERRIDE] inst_item = INSTANCE_REPLACEMENT
```

## 4. Key Takeaways

- Type override changes factory resolution for a class type.
- Instance override targets a specific factory instance path.
- Register original and replacement classes using factory macros.
- Use `type_id::create()` for factory-controlled creation.
- A matching instance override can take precedence over a type override.

## 5. Vivado Usage

1. Create `uvm_025_factory_override.sv` under Simulation Sources.
2. Set `uvm_025_factory_override_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Verify the two type-override results and the instance-override result.