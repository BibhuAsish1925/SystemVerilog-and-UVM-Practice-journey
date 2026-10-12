
# UVM-000 — Smoke Test ✅

## 1. Overview

The UVM Smoke Test is the starting point of the UVM learning journey. Its purpose is to verify that the basic UVM simulation environment is configured correctly and can execute a simple UVM test.

This example defines a minimal test class derived from `uvm_test`, registers it with the UVM factory, prints a success message using the UVM reporting system, and finishes the simulation by dropping its objection.

**The smoke test validates the basic UVM test execution flow.** It does not verify any DUT functionality because this example does not contain a DUT, driver, sequencer, monitor, or scoreboard.

## 2. Purpose — Why Do We Need a Smoke Test?

Before developing a complete UVM environment, we should verify that the basic simulation setup works.

The smoke test helps check that:

- The simulator can compile and elaborate the SystemVerilog code.
- The UVM library is available and can be imported.
- UVM macros are accessible.
- A custom class can extend `uvm_test`.
- The UVM factory can register the test class.
- `run_test()` can start the selected test.
- The `run_phase()` executes and displays a UVM message.
- Objection handling allows the simulation to finish normally.

If this basic example fails, debugging a larger UVM environment becomes more difficult because the problem may be related to the simulator setup, UVM library, compilation settings, or test execution.

## 3. Complete SystemVerilog Code

**File:** `uvm_001_smoke_test.sv`

```systemverilog
`timescale 1ns/1ps

module uvm_001_smoke_test;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class uvm_001_test extends uvm_test;

        `uvm_component_utils(uvm_001_test)

        function new(string name = "uvm_001_test",
                     uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);

            `uvm_info("UVM001",
                      "UVM smoke test PASS",
                      UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass

    initial begin
        run_test("uvm_001_test");
    end

endmodule
```

## 4. Code Explanation

### 4.1 Timescale

```systemverilog
`timescale 1ns/1ps
```

- `1ns` defines the simulation time unit.
- `1ps` defines the simulation time precision.

This example does not use explicit delays, but the directive establishes the module's time settings.

### 4.2 Top Module

```systemverilog
module uvm_001_smoke_test;
```

This is the top-level SystemVerilog module used to launch the smoke test.

The module provides an `initial` block that calls `run_test()`.

### 4.3 Import UVM

```systemverilog
import uvm_pkg::*;
```

This makes the UVM package's visible classes, types, and definitions available in the module's scope.

For example, the test uses `uvm_test` and `uvm_phase` from UVM.

### 4.4 Include UVM Macros

```systemverilog
`include "uvm_macros.svh"
```

This includes the UVM macro definitions required by the source code.

The example uses:

- `uvm_component_utils`
- `uvm_info`

The UVM library must be configured correctly in the simulator for these definitions to be available.

### 4.5 Define the Test Class

```systemverilog
class uvm_001_test extends uvm_test;
```

The class extends `uvm_test`, making it a UVM test class that can be selected by the UVM test-running mechanism.

### 4.6 Register the Test with the Factory

```systemverilog
`uvm_component_utils(uvm_001_test)
```

This macro registers the component class with the UVM factory.

It enables factory-based creation of the test and supports factory overrides.

### 4.7 Constructor

```systemverilog
function new(string name = "uvm_001_test",
             uvm_component parent = null);
    super.new(name, parent);
endfunction
```

The constructor initializes the UVM component.

- `name` is the component's instance name.
- `parent` identifies its parent component.
- `super.new()` invokes the base-class constructor.

The default parent is `null`, which is appropriate for a test at the top of the UVM component hierarchy.

### 4.8 Run Phase

```systemverilog
task run_phase(uvm_phase phase);
```

The `run_phase()` task contains the test's runtime behavior.

UVM calls this phase as part of its phase mechanism. In this example, it prints a message and controls the phase's objection state.

### 4.9 Raise an Objection

```systemverilog
phase.raise_objection(this);
```

This tells UVM that the test is active and is not yet ready for the run phase to finish.

Objections are used to coordinate when the simulation can leave the run phase.

### 4.10 Print a UVM Message

```systemverilog
`uvm_info("UVM001",
          "UVM smoke test PASS",
          UVM_LOW)
```

The reporting macro prints an informational message.

- `UVM001` is the message ID or tag.
- `UVM smoke test PASS` is the message text.
- `UVM_LOW` is the verbosity level.

The message indicates that execution reached this point. It is not, by itself, a check of DUT behavior.

### 4.11 Drop the Objection

```systemverilog
phase.drop_objection(this);
```

This tells UVM that this test no longer needs to keep the run phase active.

When all relevant objections are dropped, UVM can proceed toward ending the run phase and completing the simulation.

### 4.12 Start the Test

```systemverilog
initial begin
    run_test("uvm_001_test");
end
```

The `initial` block executes once at the start of simulation.

`run_test("uvm_001_test")` starts the UVM test by name. UVM uses the factory to create the selected test and then executes its phase callbacks.

## 5. Execution Flow

The smoke test follows this sequence:

1. The simulator starts the top module.
2. The UVM package and macros are made available.
3. `run_test("uvm_001_test")` starts UVM test execution.
4. UVM creates the registered `uvm_001_test` class.
5. UVM enters the runtime phases.
6. The test raises an objection.
7. The informational PASS message is printed.
8. The test drops its objection.
9. UVM completes the run phase and proceeds toward simulation shutdown.

## 6. Expected Output

The main informational message should appear similar to this:

```text
UVM_INFO ... [UVM001] UVM smoke test PASS
```

The complete log may also contain UVM version information, phase messages, and a final simulation-finished message. Exact formatting and timestamps depend on the simulator and UVM configuration.

**Success criteria:** The PASS message appears, and the simulation completes without fatal errors.

## 7. Vivado Usage

### Step 1 — Create a Project

1. Open AMD Vivado.
2. Create a new RTL project.
3. Select the appropriate project location.
4. Choose the simulator and language settings supported by your installed Vivado version.

### Step 2 — Add the Source File

1. Create `uvm_001_smoke_test.sv`.
2. Paste the complete code from Section 3.
3. Add the file under **Design Sources**.
4. Ensure the UVM library and include paths are configured for your Vivado installation.

### Step 3 — Set the Top Module

Set the top module to:

```text
uvm_001_smoke_test
```

Do not set the top to the class `uvm_001_test`; it is a class, not a module.

### Step 4 — Compile and Run

1. Run **Compile** or **Elaborate** as appropriate.
2. Resolve any missing UVM package, macro include, or library errors.
3. Select **Run Simulation → Run Behavioral Simulation**.
4. Inspect the Tcl Console or simulation log for the PASS message.

### Step 5 — Verify Completion

Confirm that:

- Compilation and elaboration succeed.
- The test class is created and its `run_phase()` executes.
- The `UVM smoke test PASS` message appears.
- Simulation terminates normally.

**Note:** This source assumes that the UVM package is available to the simulator. The exact library setup can vary with the Vivado version and project configuration.

## 8. Common Issues and Troubleshooting

| Issue | Possible Cause | What to Check |
|---|---|---|
| `uvm_pkg` not found | UVM library is unavailable or not configured | Confirm the UVM library setup |
| `uvm_macros.svh` not found | Include path is missing | Check the UVM include directory |
| Test class cannot be created | Class was not registered or name is incorrect | Check `uvm_component_utils` and the `run_test()` name |
| PASS message does not appear | Test was not started or runtime execution failed | Check the top module and simulation log |
| Simulation does not finish | An objection remains raised elsewhere or a runtime issue occurs | Inspect phase and objection messages |

## 9. Limitations

This is a minimal UVM smoke test. It does not include:

- A design under test (DUT)
- A sequence or sequence item
- A sequencer or driver
- A virtual interface
- A monitor or scoreboard
- Functional coverage or assertions

These components are introduced in later lessons as the verification environment grows.

## 10. Learning Outcomes

After completing this lesson, you should be able to:

- Explain why a UVM smoke test is used.
- Import `uvm_pkg` and include UVM macros.
- Define a basic class extending `uvm_test`.
- Register a component using `uvm_component_utils`.
- Understand the purpose of the constructor and `super.new()`.
- Start a UVM test using `run_test()`.
- Print messages using `uvm_info`.
- Use objections to coordinate runtime phase completion.
- Run the test in Vivado and interpret its output.

## 11. GitHub Repository Usage

Suggested folder structure:

```text
Phase 13 — UVM/
└── UVM-000 — Smoke Test/
    ├── uvm_001_smoke_test.sv
    └── README.md
```

Keep the source code and README together so that the example can be reviewed and reused easily.

After testing the code:

1. Save the SystemVerilog file.
2. Save this README in the same lesson folder.
3. Review the files in Git.
4. Commit the changes with a descriptive message, such as:

```text
Add UVM-000 smoke test and documentation
```

## 12. Final Summary

The UVM smoke test is the first checkpoint in the UVM learning phase. It confirms that a basic UVM test can be registered, started, executed, reported, and terminated through the standard UVM phase mechanism. Once this foundation works, later lessons can introduce the components and communication paths needed for complete verification environments.
