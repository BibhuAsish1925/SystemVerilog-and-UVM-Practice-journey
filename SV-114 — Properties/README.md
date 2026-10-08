
# 114 — SV-114 — Properties

### Concept

A property is a named temporal expression that describes expected behavior over simulation time.

Properties are declared using:

```systemverilog
property property_name;
    property_expression;
endproperty
````

The property can then be checked using:

```systemverilog
assert property (property_name);
```

For example:

```systemverilog
property valid_requires_ready;
    @(posedge clk) valid |-> ready;
endproperty

assert property (valid_requires_ready);
```

The property defines the behavior, while `assert property` checks that behavior.

### Why Use Properties?

Named properties make SVA code:

* Easier to read
* Easier to reuse
* Easier to maintain
* Easier to debug
* More suitable for complex temporal checks

Instead of repeating a temporal expression in multiple assertions, it can be defined once as a property.

### Important Syntax

```systemverilog
property valid_requires_ready;
    @(posedge clk) valid |-> ready;
endproperty
```

Here:

* `property` starts the property declaration.
* `valid_requires_ready` is the property name.
* `@(posedge clk)` specifies the sampling event.
* `valid |-> ready` describes the required temporal relationship.
* `endproperty` terminates the property declaration.

The property is checked using:

```systemverilog
assert property (valid_requires_ready)
    else $error("Property failed");
```

### Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_114_properties_tb;

    logic clk;
    logic valid;
    logic ready;

    // Named property
    property valid_requires_ready;
        @(posedge clk) valid |-> ready;
    endproperty

    // Check the property
    ap_valid_requires_ready:
        assert property (valid_requires_ready)
        else $error("[%0t] Property failed: valid requires ready",
                    $time);

    initial begin

        clk   = 1'b0;
        valid = 1'b0;
        ready = 1'b0;

        #10;

        // Property passes
        valid = 1'b1;
        ready = 1'b1;

        #10;

        // Property fails
        valid = 1'b1;
        ready = 1'b0;

        #10;

        // Property is not violated because valid is 0
        valid = 1'b0;
        ready = 1'b0;

        #10;

        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

### Expected Output

The property is violated when `valid=1` and `ready=0` at the relevant clock edge.

Conceptually:

```text
[15000] Property failed: valid requires ready
$finish called at time : 40 ns
```

The exact XSim diagnostic formatting may vary.

### Verification Relevance

Properties provide a reusable way to describe temporal requirements.

For example, a larger verification environment could define properties for:

```systemverilog
property valid_requires_ready;
    @(posedge clk) valid |-> ready;
endproperty

property reset_clears_valid;
    @(posedge clk) reset |-> !valid;
endproperty
```

These properties can then be checked using separate `assert property` statements.

Named properties become particularly useful when learning more advanced SVA concepts such as sequences, delays, implication, repetition, and multi-cycle protocol checking.

