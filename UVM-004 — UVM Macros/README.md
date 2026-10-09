# 152 — UVM-004 — UVM Macros

### 1. Small Introduction

UVM macros simplify registering classes with the UVM factory.

- `uvm_component_utils`: Registers component classes derived from `uvm_component`, including classes derived from `uvm_env` and `uvm_test`.
- `uvm_object_utils`: Registers object classes derived from `uvm_object`, such as transactions and sequence items.

| Macro | Purpose | Example |
|---|---|---|
| `uvm_component_utils` | Register a component | Environment, test |
| `uvm_object_utils` | Register a data object | Transaction, sequence item |

These macros register classes; they do not create instances. Instances can be requested through `type_id::create()`.

### 2. Vivado Flow

1. Open the existing Vivado project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. In **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create `uvm_004_uvm_macros.sv` as a SystemVerilog simulation source.

4. Paste the complete code below.

5. Right-click `uvm_004_uvm_macros_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Check the Tcl Console for the object data and environment hierarchy messages.

### 3. Compact Running Code

File: `uvm_004_uvm_macros.sv`

```systemverilog
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_004_transaction extends uvm_object;
    `uvm_object_utils(uvm_004_transaction)

    bit [7:0] data;

    function new(string name = "transaction");
        super.new(name);
        data = 8'h5A;
    endfunction
endclass

class uvm_004_env extends uvm_env;
    `uvm_component_utils(uvm_004_env)

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MACRO_DEMO",
            $sformatf("Environment created: %s", get_full_name()),
            UVM_LOW)
    endfunction
endclass

class uvm_004_test extends uvm_test;
    `uvm_component_utils(uvm_004_test)

    uvm_004_env env;
    uvm_004_transaction transaction;

    function new(string name = "uvm_004_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uvm_004_env::type_id::create("env", this);
        transaction =
            uvm_004_transaction::type_id::create("transaction");

        `uvm_info("MACRO_DEMO",
            $sformatf("Object created: %s | Data = 0x%02h",
                transaction.get_name(), transaction.data),
            UVM_LOW)
    endfunction
endclass

module uvm_004_uvm_macros_tb;
    initial run_test("uvm_004_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [RNTST] Running test uvm_004_test...
UVM_INFO ... [MACRO_DEMO] Object created: transaction | Data = 0x5a
UVM_INFO ... [MACRO_DEMO] Environment created: uvm_test_top.env
```

Source line numbers and message ordering may vary.

### 5. Key Learning Points

- `uvm_object_utils` registers an object class with the factory.
- `uvm_component_utils` registers a component class with the factory.
- `run_test("uvm_004_test")` selects the registered test class.
- `type_id::create()` requests an instance through the factory.
- The second argument `this` in component creation establishes the parent-child relationship.
- `uvm_macros.svh` must be included for these macros to be available.

**Verification context:** This lesson demonstrates UVM class registration and factory-based creation. It does not yet generate or check DUT transactions.