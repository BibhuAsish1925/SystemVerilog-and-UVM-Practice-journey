# 001 — SV-001 — Data Types

## Concept

SystemVerilog provides several built-in data types for representing
logic values, integers, and simulation time.

### 1. `bit`

`bit` is a **2-state** data type.

It can contain only:

```text
0
1
```

It cannot retain `X` or `Z`.

```systemverilog
bit b;
```

### 2. `logic`

`logic` is a **4-state** data type.

It can represent:

```text
0, 1, X, Z
```

It is commonly used in SystemVerilog instead of the older `reg` type.

```systemverilog
logic signal;
```

### 3. `reg`

`reg` is the traditional Verilog variable type.

It is a **4-state** type:

```text
0, 1, X, Z
```

SystemVerilog generally uses `logic` instead of `reg`, but `reg` is
still important when reading or understanding older Verilog code.

### 4. Integer Data Types

| Type       |  Width | State   | Default signedness |
| ---------- | -----: | ------- | ------------------ |
| `byte`     |  8-bit | 2-state | signed             |
| `shortint` | 16-bit | 2-state | signed             |
| `int`      | 32-bit | 2-state | signed             |
| `longint`  | 64-bit | 2-state | signed             |
| `integer`  | 32-bit | 4-state | signed             |
| `time`     | 64-bit | 4-state | unsigned           |

`int` is particularly common in verification code for counters,
loop variables, calculations, and temporary values.

### 5. `time`

`time` is used for storing simulation-time values.

Example:

```systemverilog
#10;
t = $time;
```

The value of `$time` is assigned to the `time` variable.

## Important Difference

The main distinction to remember is:

```text
2-state → 0, 1
4-state → 0, 1, X, Z
```

Therefore:

```text
bit   → 2-state
logic → 4-state
reg   → 4-state
```

The integer atom types `byte`, `shortint`, `int`, and `longint`
are 2-state types, while `integer` and `time` are 4-state types.

## Verification Relevance

These data types are used throughout SystemVerilog verification:

* `logic` for DUT/interface signals
* `bit` when X/Z states are not required
* `int` for counters and verification variables
* `byte` for byte-oriented data
* `longint` for larger numerical values
* `time` for simulation-time measurements
* Integer types inside transactions, constraints, monitors,
  scoreboards, coverage, and UVM components

## Complete Example

```systemverilog
module sv_001_data_types;

    bit       b;       // 2-state: 0, 1
    logic     l;       // 4-state: 0, 1, X, Z
    reg       r;       // 4-state, legacy Verilog type

    byte      by;      // 8-bit signed integer
    shortint  si;      // 16-bit signed integer
    int       i;       // 32-bit signed integer
    longint   li;      // 64-bit signed integer
    integer   iv;      // 32-bit signed, 4-state
    time      t;       // 64-bit unsigned simulation time

    initial begin
        b  = 1'b1;
        l  = 1'bx;
        r  = 1'bz;

        by = 8'd100;
        si = 16'd1000;
        i  = 32'd100000;
        li = 64'd1000000;
        iv = -50;

        #10;
        t = $time;

        $display("bit       = %b", b);
        $display("logic     = %b", l);
        $display("reg       = %b", r);
        $display("byte      = %0d", by);
        $display("shortint  = %0d", si);
        $display("int       = %0d", i);
        $display("longint   = %0d", li);
        $display("integer   = %0d", iv);
        $display("time      = %0t", t);
    end

endmodule
```

## Expected Output

```text
bit       = 1
logic     = x
reg       = z
byte      = 100
shortint  = 1000
int       = 100000
longint   = 1000000
integer   = -50
time      = 10
```

## Key Points to Remember

* `bit` → 2-state.
* `logic` → 4-state.
* `reg` → legacy 4-state Verilog type.
* `byte` → 8-bit.
* `shortint` → 16-bit.
* `int` → 32-bit.
* `longint` → 64-bit.
* `integer` → 32-bit, 4-state signed type.
* `time` → used for simulation time.
* `logic` is generally preferred over `reg` in SystemVerilog.
* Choosing the correct data type is important for reliable verification code.
