# 109 — SV-109 — Coverage Options

## 1. Concept

Coverage options control how a covergroup measures and reports functional coverage.

The important options in this topic are:

| Option | Purpose |
|--------|---------|
| `option.goal` | Defines the target coverage percentage |
| `option.at_least` | Defines the minimum number of hits required for a bin |
| `option.name` | Assigns a custom name to the covergroup |
| `option.per_instance` | Maintains coverage separately for each instance |

## 2. `option.goal`

```systemverilog
option.goal = 100;
````

This sets the desired coverage goal to 100%.

The goal is a reporting target; it does not automatically make uncovered bins covered.

## 3. `option.at_least`

```systemverilog
option.at_least = 2;
```

This requires each applicable bin to be hit at least twice before it is considered covered.

For example, if a bin is sampled only once, it does not satisfy an `at_least = 2` requirement.

## 4. `option.name`

```systemverilog
option.name = "Opcode Coverage";
```

This gives the covergroup a meaningful name.

It can also be accessed through the covergroup instance:

```systemverilog
cg.option.name
```

## 5. `option.per_instance`

```systemverilog
option.per_instance = 1;
```

This enables coverage tracking separately for each instance of the covergroup.

This is useful when the same coverage model is instantiated multiple times and each instance needs independent coverage information.

## 6. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_109_coverage_options_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        // Coverage options
        option.goal = 100;
        option.at_least = 2;
        option.name = "Opcode Coverage";
        option.per_instance = 1;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        // ADD: two hits
        opcode = 2'b00;
        cg.sample();

        opcode = 2'b00;
        cg.sample();

        // SUB: two hits
        opcode = 2'b01;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        // MUL: two hits
        opcode = 2'b10;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        $display("[%0t] %s = %0.2f%%",
                 $time,
                 cg.option.name,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 7. Expected Result

```text
[0] Opcode Coverage = 100.00%
$finish called at time : 0 ns
```

Each bin is sampled twice, satisfying:

```systemverilog
option.at_least = 2;
```

All three bins are therefore covered.

## 8. Verification Relevance

Coverage options become important when building larger and reusable verification environments.

### `option.goal`

Defines the desired coverage target.

### `option.at_least`

Prevents a bin from being considered covered after only a single occurrence.

### `option.name`

Makes coverage models easier to identify and report.

### `option.per_instance`

Allows separate coverage tracking for multiple instances of the same covergroup type.

Together, these options provide more control over how functional coverage is measured and interpreted.

