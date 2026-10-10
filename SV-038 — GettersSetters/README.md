# 038 — SV-038 — Getters/Setters

**Getters and setters** provide controlled access to class properties.

Instead of allowing external code to directly modify an internal property, the class can provide methods for reading and modifying it.

## 1. Setter

A setter is a method used to modify a property.

```systemverilog id="n5x7q2"
function void set_data(int new_data);
    data = new_data;
endfunction
```

The setter receives a value and assigns it to the internal property.

Usage:

```systemverilog id="x4m8kc"
trans.set_data(100);
```

## 2. Getter

A getter is a method used to read a property.

```systemverilog id="v2q6mp"
function int get_data();
    return data;
endfunction
```

Usage:

```systemverilog id="r7k3hz"
$display("%0d", trans.get_data());
```

## 3. Controlled Access

The property can be declared `local`:

```systemverilog id="q9w4ns"
local int data;
```

This prevents external code from directly accessing it.

Instead of:

```systemverilog id="c3m8vx"
// trans.data = 100;
```

the class provides:

```systemverilog id="m6p2jd"
trans.set_data(100);
trans.get_data();
```

This creates a controlled interface between the object and external code.

## 4. Complete Runnable Example

```systemverilog id="h8r5kc"
module sv_038_getters_setters;

    class transaction;

        // Internal property
        local int data;

        // Setter: controlled write access
        function void set_data(int new_data);
            data = new_data;
        endfunction

        // Getter: controlled read access
        function int get_data();
            return data;
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // Set property through setter
        trans.set_data(100);

        // Read property through getter
        $display("Data = %0d", trans.get_data());

        // Update property through setter
        trans.set_data(250);

        $display("Updated Data = %0d", trans.get_data());

    end

endmodule
```

### Expected Output

```text id="b4t7mz"
Data = 100
Updated Data = 250
```

### Key Concepts

| Concept | Purpose |
|---|---|
| Getter | Reads and returns a property |
| Setter | Modifies a property |
| `local` | Restricts direct access to the declaring class |
| `get_data()` | Controlled read interface |
| `set_data()` | Controlled write interface |

### Basic Flow

```text id="w3n6kp"
External Code
     │
     ├── set_data(value) ──→ Internal Property
     │
     └── get_data() ←────── Internal Property
```

Getters and setters extend the idea of **encapsulation** by allowing a class to control how its internal properties are accessed and modified.