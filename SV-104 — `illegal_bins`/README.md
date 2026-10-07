
## 104 — SV-104 — `illegal_bins`

## 1. Concept

`illegal_bins` identifies values or combinations that should never occur according to the design specification.

When an illegal value is sampled, the simulator can generate an illegal-bin diagnostic.

For example:

```systemverilog
illegal_bins illegal_opcode = {2'b11};
````

This declares `2'b11` as an illegal coverage value.

## 2. `illegal_bins` vs `ignore_bins`

These two constructs have different purposes:

| Construct      | Purpose                                    |
| -------------- | ------------------------------------------ |
| `ignore_bins`  | Exclude irrelevant scenarios from coverage |
| `illegal_bins` | Detect scenarios that should never occur   |

`ignore_bins` represents a deliberate coverage exclusion.

`illegal_bins` represents a condition that indicates an invalid or forbidden scenario was observed.

## 3. Important Syntax

```systemverilog
coverpoint opcode {

    bins add = {2'b00};
    bins sub = {2'b01};
    bins mul = {2'b10};

    illegal_bins illegal_opcode = {2'b11};

}
```

If `2'b11` is sampled, the simulator can report an illegal-bin diagnostic.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_104_illegal_bins_tb;

    logic [1:0] opcode;

    covergroup opcode_cg;

        coverpoint opcode {

            bins add = {2'b00};
            bins sub = {2'b01};
            bins mul = {2'b10};

            // Opcode 11 is illegal
            illegal_bins illegal_opcode = {2'b11};

        }

    endgroup

    opcode_cg cg;

    initial begin

        cg = new();

        opcode = 2'b00;
        cg.sample();

        opcode = 2'b01;
        cg.sample();

        opcode = 2'b10;
        cg.sample();

        // Intentionally demonstrate an illegal scenario
        opcode = 2'b11;
        cg.sample();

        $display("[%0t] Coverage = %0.2f%%",
                 $time,
                 cg.get_coverage());

        $finish;

    end

endmodule
```

## 5. Expected Result

The simulation should produce the normal coverage display:

```text
[0] Coverage = 100.00%
$finish called at time : 0 ns
```

and the simulator may additionally report an illegal-bin diagnostic when `2'b11` is sampled.

The exact diagnostic wording is simulator/version dependent.

## 6. Verification Relevance

`illegal_bins` is useful for detecting scenarios such as:

* Reserved protocol values.
* Forbidden commands.
* Invalid state encodings.
* Unsupported configuration combinations.
* Values that violate the design specification.

The important principle is:

`ignore_bins` → "This scenario is not part of the coverage goal."

`illegal_bins` → "This scenario should never happen."

Therefore, an illegal-bin hit should be investigated as a potential design, stimulus, or verification problem.


