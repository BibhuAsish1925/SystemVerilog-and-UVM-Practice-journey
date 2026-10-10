
# 151 — UVM-002 — Component Hierarchy

### 1. Small Introduction

A UVM component hierarchy is a tree-like structure of verification components. The base class `uvm_component` provides hierarchy management and UVM phase functionality.

Key concepts:

- `uvm_component`: Base class for structural UVM components.
- Parent/child hierarchy: Components create other components beneath themselves.
- `get_full_name()`: Returns a component's complete hierarchical path.
- `get_parent()`: Returns the immediate parent component.
- `type_id::create()`: Creates components through the UVM factory.

Example hierarchy:

```text
uvm_test_top
└── env
    └── agent
        └── monitor
```

### 2. Vivado Flow

1. Open the existing project:

   ```tcl
   start_gui
   open_project {D:/Downloads/Concept practice SV and UVM/UVM phase 13/UVM phase 13.xpr}
   ```

2. Under **Simulation Sources**, select **Add Sources → Add or Create Simulation Sources**.

3. Create `uvm_002_component_hierarchy.sv` as a SystemVerilog simulation source.

4. Paste the complete code below.

5. Right-click `uvm_002_component_hierarchy_tb` and select **Set as Top**.

6. Select **Run Simulation → Run Behavioral Simulation**.

7. In the Tcl Console, run:

   ```tcl
   run 1000ns
   ```

8. Check the Tcl Console for the component names and parent paths.

### 3. Compact Running Code

File: `uvm_002_component_hierarchy.sv`

```systemverilog
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

class uvm_002_monitor extends uvm_monitor;
    `uvm_component_utils(uvm_002_monitor)

    function new(string name = "monitor",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)
    endfunction
endclass

class uvm_002_agent extends uvm_agent;
    `uvm_component_utils(uvm_002_agent)

    uvm_002_monitor monitor;

    function new(string name = "agent",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        monitor = uvm_002_monitor::type_id::create("monitor", this);
    endfunction
endclass

class uvm_002_env extends uvm_env;
    `uvm_component_utils(uvm_002_env)

    uvm_002_agent agent;

    function new(string name = "env",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        agent = uvm_002_agent::type_id::create("agent", this);
    endfunction
endclass

class uvm_002_test extends uvm_test;
    `uvm_component_utils(uvm_002_test)

    uvm_002_env env;

    function new(string name = "uvm_002_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("HIERARCHY",
            $sformatf("Component: %s | Parent: %s",
                get_full_name(), get_parent().get_full_name()),
            UVM_LOW)

        env = uvm_002_env::type_id::create("env", this);
    endfunction
endclass

module uvm_002_component_hierarchy_tb;
    initial run_test("uvm_002_test");
endmodule
```

### 4. Expected Output

The Tcl Console should contain these hierarchy messages:

```text
[HIERARCHY] Component: uvm_test_top | Parent: uvm_top
[HIERARCHY] Component: uvm_test_top.env | Parent: uvm_test_top
[HIERARCHY] Component: uvm_test_top.env.agent | Parent: uvm_test_top.env
[HIERARCHY] Component: uvm_test_top.env.agent.monitor | Parent: uvm_test_top.env.agent
```

Standard UVM report messages may appear around these lines.

### 5. Key Learning Points

- `uvm_component` provides the base functionality for UVM components.
- The UVM test instance is normally named `uvm_test_top`.
- `type_id::create("name", this)` creates a child under the current component.
- `get_full_name()` shows the complete hierarchical path.
- `get_parent()` identifies the immediate parent.
- The hierarchy in this example is `test → environment → agent → monitor`.

**Verification context:** This example demonstrates component construction and hierarchy inspection. It does not generate or check transactions.
