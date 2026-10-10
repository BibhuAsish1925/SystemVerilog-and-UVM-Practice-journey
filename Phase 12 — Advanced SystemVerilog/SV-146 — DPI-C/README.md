
# 146 — SV-146 — DPI-C

### 1. Small Introduction

DPI-C (Direct Programming Interface — C) allows SystemVerilog code to communicate directly with functions written in C.

In this example, SystemVerilog calls a C function that receives two integers, adds them, and returns the result back to SystemVerilog.

> **Important:** Before executing this example, follow the complete setup and execution procedure in `Complete_Setup_and_Execution_Guide.txt`.

The required files are:

- `sv_146_dpi_c_tb.sv` — SystemVerilog testbench
- `sv_146_dpi_c.c` — C implementation of the DPI function
- `Complete_Setup_and_Execution_Guide.txt` — complete DPI-C setup and execution procedure

**The `.sv` and `.c` files must be executed through the Vivado Tcl Shell / Tcl Console using the commands described in `Complete_Setup_and_Execution_Guide.txt`.**

### 2. Compact Running Code

#### SystemVerilog — `sv_146_dpi_c_tb.sv`

```systemverilog
module sv_146_dpi_c_tb;

    import "DPI-C" function int sv146_c_add(
        input int a,
        input int b
    );

    int a;
    int b;
    int result;

    initial begin

        a = 25;
        b = 17;

        result = sv146_c_add(a, b);

        $display("SystemVerilog: a = %0d", a);
        $display("SystemVerilog: b = %0d", b);
        $display("C function result = %0d", result);

        if (result == 42)
            $display("DPI-C communication: PASS");
        else
            $display("DPI-C communication: FAIL");

        $finish;
    end

endmodule
````

#### C — `sv_146_dpi_c.c`

```c
#include "svdpi.h"
#include <stdio.h>

DPI_DLLESPEC
int sv146_c_add(int a, int b)
{
    printf("C function: received a=%d b=%d\n", a, b);
    return a + b;
}
```

### 3. Expected Output

```text
C function: received a=25 b=17

SystemVerilog: a = 25
SystemVerilog: b = 17
C function result = 42
DPI-C communication: PASS
$finish called at time : 0 fs
```

The expected calculation is:

```text
25 + 17 = 42
```

### 4. Vivado Usage

**Follow `Complete_Setup_and_Execution_Guide.txt` for the complete setup and execution procedure.**

**Use the Vivado Tcl Shell / Tcl Console to compile, link, and execute the `.sv` and `.c` files.**

The basic DPI-C flow is:

```text
XSC → XVLOG → XELAB -SV_LIB → XSIM
```

The commands used for this example are:

```tcl
cd {D:/Downloads/Concept practice SV and UVM/sv phase 12/sv phase 12.srcs/sim_1/new}

exec xsc sv_146_dpi_c.c

exec xvlog -sv sv_146_dpi_c_tb.sv

exec xelab sv_146_dpi_c_tb -sv_lib dpi

exec xsim sv_146_dpi_c_tb -runall
```

`xsc` compiles the C DPI implementation, `xvlog` compiles the SystemVerilog testbench, `xelab -sv_lib dpi` links the DPI library, and `xsim -runall` runs the simulation.

### 5. Verification Result

The DPI-C communication was successfully verified in Vivado/XSim 2025.1.

```text
SystemVerilog
      ↓
DPI-C function call
      ↓
C function
      ↓
25 + 17
      ↓
42
      ↓
SystemVerilog
      ↓
DPI-C communication: PASS
```

**Reference files for this topic:**

* `Complete_Setup_and_Execution_Guide.txt`
* `sv_146_dpi_c_tb.sv`
* `sv_146_dpi_c.c`

