# 011 — SV-011 — `$cast`

## Dynamic Casting with `$cast`

`$cast` performs a **dynamic cast** at runtime. It is commonly used with class handles when a base-class handle may refer to either a base-class object or a derived-class object.

The syntax is:

```systemverilog
$cast(destination, source)
```

`$cast` returns:

- `1` when the cast succeeds
- `0` when the cast fails

This makes it a **safe casting mechanism**.

### Class Handles

Consider a base class and a derived class:

```systemverilog
class parent;
endclass

class child extends parent;
endclass
```

A parent handle can refer to a child object:

```systemverilog
parent p;
child c;

c = new();
p = c;
```

The object is actually a `child`, even though it is accessed through the `parent` handle.

We can safely recover the child handle using:

```systemverilog
child c_cast;

if ($cast(c_cast, p)) begin
    // Cast succeeded
end
```

### Successful Cast

When the object referenced by the source handle is actually a `child`:

```systemverilog
c = new();
p = c;

$cast(c_cast, p);
```

the cast succeeds because the actual object is compatible with `child`.

The child-specific methods can then be accessed through `c_cast`.

### Failed Cast

If the source handle refers to a real `parent` object:

```systemverilog
p = new();
```

then:

```systemverilog
$cast(c_cast, p)
```

fails because the actual object is not a `child`.

The return value allows the testbench to detect this safely:

```systemverilog
if ($cast(c_cast, p))
    $display("SUCCESS");
else
    $display("FAILED");
```

### Static Cast vs `$cast`

| Feature | Static Cast | `$cast` |
|---|---|---|
| Syntax | `type'(value)` | `$cast(dest, source)` |
| Evaluation | Static/explicit conversion | Runtime check |
| Return value | Cast value | `1` or `0` |
| Common use | Type conversion | Class-handle casting |
| Failed cast detection | Not through a success return | Yes |

### Why `$cast` Matters in Verification

`$cast` is important in object-oriented verification because testbenches frequently use:

- Base-class handles
- Derived transaction classes
- Polymorphism
- Factory-created objects
- Different transaction types handled through common interfaces

The main idea is:

> **`$cast` checks at runtime whether the source object can safely be treated as the destination type.**

## Complete Runnable Code

**Code type:** SystemVerilog simulation/demo — class-based testbench example, no DUT.

```systemverilog
module sv_011_cast;

    class parent;
        virtual function void show();
            $display("Parent object");
        endfunction
    endclass

    class child extends parent;
        function void show();
            $display("Child object");
        endfunction

        function void child_method();
            $display("Child-specific method");
        endfunction
    endclass

    parent p;
    child  c;
    child  c_cast;

    initial begin
        // Create a child object through a parent handle
        c = new();
        p = c;

        // Safe dynamic cast: succeeds
        if ($cast(c_cast, p)) begin
            $display("Cast 1: SUCCESS");
            c_cast.child_method();
        end
        else begin
            $display("Cast 1: FAILED");
        end

        // Create a real parent object
        p = new();

        // Safe dynamic cast: fails
        if ($cast(c_cast, p)) begin
            $display("Cast 2: SUCCESS");
        end
        else begin
            $display("Cast 2: FAILED");
        end
    end

endmodule
```

## Expected Output

```text
Cast 1: SUCCESS
Child-specific method
Cast 2: FAILED
```

## Key Syntax

```systemverilog
$cast(destination, source)
```

Typical usage:

```systemverilog
if ($cast(child_handle, parent_handle)) begin
    // Cast succeeded
end
else begin
    // Cast failed
end
```

Remember:

- `type'(expression)` → **static casting**
- `$cast(destination, source)` → **dynamic/safe casting**
- `$cast` is particularly important for **class handles and polymorphism**