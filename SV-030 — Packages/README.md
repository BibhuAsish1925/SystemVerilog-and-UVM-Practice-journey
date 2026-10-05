# SV-030 — Packages

A **package** groups related SystemVerilog declarations into a common namespace.

Packages can contain items such as:

* Parameters
* Typedefs
* Functions
* Tasks
* Classes

They are especially useful in verification because common definitions can be shared across multiple testbench components.

## 1. `package`

A package is declared using:

```systemverilog id="r4c7k2"
package common_pkg;

    parameter int DATA_WIDTH = 8;

    typedef logic [DATA_WIDTH-1:0] data_t;

endpackage
```

Everything declared inside the package belongs to its package scope.

## 2. `import`

The package can be imported using:

```systemverilog id="j7p3m5"
import common_pkg::*;
```

The `*` imports the package members so they can be referenced directly.

For example:

```systemverilog id="w6x2q9"
data_t data;
```

instead of explicitly qualifying the type.

## 3. Scope Resolution `::`

The scope resolution operator accesses a package member explicitly:

```systemverilog id="c8n5v1"
common_pkg::DATA_WIDTH
```

This is useful when you want to clearly identify where a declaration comes from or avoid namespace conflicts.

A package member can therefore be accessed either through an import:

```systemverilog id="m2v7k4"
DATA_WIDTH
```

or explicitly:

```systemverilog id="h9q3z6"
common_pkg::DATA_WIDTH
```

## Verification Relevance

Packages are fundamental in larger verification environments because they allow common definitions to be shared between:

* Testbenches
* Transactions
* Interfaces
* Drivers
* Monitors
* Scoreboards
* UVM components

For example, transaction types and common parameters can be declared once in a package and reused throughout the verification environment.

