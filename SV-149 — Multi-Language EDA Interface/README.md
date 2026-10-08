
# SV-149 — Multi-Language EDA Interface

SV-149 is a practical SystemVerilog/EDA scripting exercise that connects **SystemVerilog, C, Python, Perl, and Tcl** in one workflow.

The project demonstrates:

- **SystemVerilog ↔ C** communication using DPI-C
- **Python** execution through Tcl
- **Perl** execution through Tcl
- **Tcl** as the master automation/orchestration script
- **Vivado/XSim** compilation, elaboration, DPI linking, and simulation

The same calculation is used throughout the demonstration:

```text
25 + 17 = 42
````

## Project Flow

```text
                 Tcl
                  |
        +---------+---------+
        |         |         |
        v         v         v
     Python     Perl    Vivado/XSim
                           |
                           v
                    SystemVerilog
                           |
                         DPI-C
                           |
                           v
                           C
```

## Files

### `sv_149_multilang_tb.sv`

SystemVerilog testbench.

It imports the C function through DPI-C:

```systemverilog
import "DPI-C" function int sv149_c_add(
    input int a,
    input int b
);
```

The testbench sends:

```text
a = 25
b = 17
```

and checks that the C function returns:

```text
42
```

### `sv_149_multilang.c`

C implementation of the DPI-C function.

```c
#include "svdpi.h"
#include <stdio.h>

DPI_DLLESPEC
int sv149_c_add(int a, int b)
{
    int result = a + b;

    printf("[C] C function: %d + %d = %d\n", a, b, result);

    return result;
}
```

The C code is compiled using Vivado's `xsc` command.

### `sv_149_multilang.py`

Python demonstration that performs:

```text
25 + 17 = 42
```

and reports PASS/FAIL.

### `sv_149_multilang.pl`

Perl demonstration that performs the same calculation and reports PASS/FAIL.

### `sv_149_multilang.tcl`

Master Tcl script.

It automatically:

1. Runs Python
2. Runs Perl
3. Compiles the C DPI code
4. Compiles SystemVerilog
5. Elaborates and links the DPI library
6. Runs XSim
7. Prints the final completion message

Important Tcl syntax:

```tcl
puts "\n\[TCL\] Tcl execution started"
```

The square brackets are escaped because Tcl normally interprets `[ ... ]` as command substitution.

The C compilation command uses:

```tcl
exec xsc sv_149_multilang.c 2>@1
```

The `2>@1` redirects stderr to stdout so compiler warnings do not stop the Tcl `exec` command when `xsc` has successfully completed.

### `Complete_Setup_and_Execution_Guide.txt`

Complete setup and execution reference for SV-149.

It contains:

* Required software
* Project file structure
* Vivado Tcl Shell setup
* Python and Perl verification
* DPI-C setup
* `xsc` compilation
* `xvlog` compilation
* `xelab -sv_lib dpi`
* `xsim -runall`
* Complete Tcl automation
* Expected output
* Troubleshooting
* Final verification status

## Vivado Execution

Use the **Vivado Tcl Shell / Tcl Console**.

Go to the project directory:

```tcl
cd {D:/Downloads/Concept practice SV and UVM/sv phase 12/sv phase 12.srcs/sim_1/new}
```

Check the files:

```tcl
glob sv_149_*
```

Run the complete project:

```tcl
source sv_149_multilang.tcl
```

The individual Vivado DPI-C flow is:

```tcl
exec xsc sv_149_multilang.c 2>@1
exec xvlog -sv sv_149_multilang_tb.sv
exec xelab sv_149_multilang_tb -sv_lib dpi
exec xsim sv_149_multilang_tb -runall
```

## Expected Output

Python:

```text
[PYTHON] Python calculation: 25 + 17 = 42
[PYTHON] Python test: PASS
```

Perl:

```text
[PERL] Perl calculation: 25 + 17 = 42
[PERL] Perl test: PASS
```

C and SystemVerilog:

```text
[C] C function: 25 + 17 = 42

[SV] SystemVerilog: a = 25
[SV] SystemVerilog: b = 17
[SV] C result through DPI-C = 42
[SV] DPI-C communication: PASS
```

Final Tcl message:

```text
========================================
ALL LANGUAGE TESTS COMPLETED
========================================
```

## Verified Environment

Tested successfully with:

```text
Vivado 2025.1
Python 3.14.0
Perl 5.8.8
```

## Final Status

**SV-149 — Multi-Language EDA Interface: COMPLETE ✅**

Verified:

```text
Python              PASS
Perl                PASS
C compilation       PASS
DPI library         PASS
SystemVerilog       PASS
DPI-C communication PASS
XSim simulation     PASS
Overall flow        PASS
```

This project is a learning/practice example showing how different programming languages and EDA tools can be combined in a SystemVerilog verification workflow.

````

**Repository file set for SV-149:**

```text
SV-149/
├── sv_149_multilang_tb.sv
├── sv_149_multilang.c
├── sv_149_multilang.py
├── sv_149_multilang.pl
├── sv_149_multilang.tcl
└── Complete_Setup_and_Execution_Guide.txt
````

This gives you a self-contained **SV-149 practice folder**: the source files demonstrate the concept, the `.tcl` automates it, and the `.txt` preserves the exact setup/troubleshooting procedure you used to get it working in Vivado 2025.1.
