# 151 — UVM-003 — Object vs Component

### 1. Small Introduction

`uvm_object` and `uvm_component` are two important UVM base classes.

- `uvm_object` represents data objects such as transactions and sequence items.
- `uvm_component` represents verification structure such as tests, environments, agents, drivers, monitors, and scoreboards.

| Feature | `uvm_object` | `uvm_component` |
|---|---|---|
| Purpose | Store or process data | Build verification structure |
| Parent-child hierarchy | No | Yes |
| UVM component phases | No | Yes |
| Factory creation | Supported | Supported |
| Examples | Transaction, sequence | Test, environment, agent |

A transaction is an object; an environment is a component.

### 2. Vivado Flow

1. Open the existing Vivado project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. Under **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create the SystemVerilog file `uvm_003_object_vs_component.sv`.

4. Paste the complete code from Section 3.

5. Right-click `uvm_003_object_vs_component_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Check the Tcl Console for the object name and component paths.

### 3. Compact Running Code

File: `uvm_003_object_vs_component.sv`

```systemverilog
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_003_transaction extends uvm_object;
    `uvm_object_utils(uvm_003_transaction)

    bit [7:0] data;

    function new(string name = "transaction");
        super.new(name);
        data = 8'hA5;
    endfunction
endclass

class uvm_003_env extends uvm_env;
    `uvm_component_utils(uvm_003_env)

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Component path: %s", get_full_name()),
            UVM_LOW)
    endfunction
endclass

class uvm_003_test extends uvm_test;
    `uvm_component_utils(uvm_003_test)

    uvm_003_env env;
    uvm_003_transaction transaction;

    function new(string name = "uvm_003_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = uvm_003_env::type_id::create("env", this);
        transaction =
            uvm_003_transaction::type_id::create("transaction");

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Test component path: %s", get_full_name()),
            UVM_LOW)

        `uvm_info("OBJECT_COMPONENT",
            $sformatf("Object name: %s | Data: 0x%02h",
                transaction.get_name(), transaction.data),
            UVM_LOW)
    endfunction
endclass

module uvm_003_object_vs_component_tb;
    initial run_test("uvm_003_test");
endmodule
```

### 4. Expected Output

```text
UVM_INFO ... [RNTST] Running test uvm_003_test...
UVM_INFO ... [OBJECT_COMPONENT] Test component path: uvm_test_top
UVM_INFO ... [OBJECT_COMPONENT] Object name: transaction | Data: 0xa5
UVM_INFO ... [OBJECT_COMPONENT] Component path: uvm_test_top.env
```

Source line numbers and message ordering may vary.

### 5. Key Learning Points

- `uvm_object` is suitable for transaction data and other lightweight objects.
- `uvm_component` is suitable for structural verification elements.
- Components have parent-child hierarchy and participate in UVM component phases.
- Objects can have names, but they do not have component hierarchy paths.
- Both types support UVM factory creation, using their respective registration macros.
- The test creates the environment as a child with `create("env", this)`.
- The transaction is created with `create("transaction")` without a component parent.

**Verification context:** This lesson demonstrates UVM object and component creation; it does not drive or check transactions on a DUT.