# 005 — SV-005 — Parameters

## Concept

A `parameter` is a constant value that can be used to configure
a module or other SystemVerilog construct.

Parameters are useful when the same design needs to work with
different sizes or configurations.

## `parameter`

A parameter can be declared inside a module:

```systemverilog
parameter int WIDTH = 8;
```

The default value is `8`, but it can be overridden when the module
is instantiated.

Example:

```systemverilog
sv_005_parameters #(
    .WIDTH(16)
) dut ();
```

The module now uses `WIDTH = 16`.

## `localparam`

A `localparam` is a constant value that is local to the module
and **cannot be overridden during module instantiation**.

Example:

```systemverilog
localparam int ADDR_WIDTH = $clog2(DEPTH);
```

This is useful when a value must be calculated or defined internally
from other parameters.

For example, if:

```text
DEPTH = 64
```

then:

```text
ADDR_WIDTH = $clog2(64) = 6
```

## Parameterized Values

Parameters can control widths, depths, sizes, and other design
configuration values.

Example:

```systemverilog
logic [WIDTH-1:0] data;
```

If:

```text
WIDTH = 8
```

then `data` is 8 bits wide.

If:

```text
WIDTH = 16
```

then `data` becomes 16 bits wide.

This allows one module to be reused with different configurations.

## `parameter` vs `localparam`

| Feature           | `parameter`          | `localparam`               |
| ----------------- | -------------------- | -------------------------- |
| Constant value    | Yes                  | Yes                        |
| Default value     | Yes                  | Yes                        |
| Can be overridden | Yes                  | No                         |
| Common use        | Module configuration | Internal derived constants |

## Verification Relevance

Parameters are useful in verification for creating reusable testbench
components and configuring designs with different:

* Data widths
* FIFO depths
* Address widths
* Number of transactions
* Buffer sizes
* Protocol configurations

Parameterized designs reduce duplicated code and make the same
verification environment easier to reuse with different configurations.

## Key Points to Remember

* `parameter` defines a configurable constant.
* Parameters have default values.
* Module parameters can be overridden during instantiation.
* `localparam` defines a constant that cannot be overridden.
* Parameters are commonly used for widths, depths, and configurations.
* `localparam` is useful for internally derived values.
* `$clog2()` can be used to calculate address widths from depths.
