# 041 — SV-041 — `$cast` with Classes

`$cast` provides **safe dynamic casting** between compatible class handles.

It is especially useful when a parent-class handle refers to an object whose specific child type needs to be recovered.

## 1. Upcasting

**Upcasting** converts a child-class handle to a parent-class handle.

For example:

```systemverilog id="r4n7kc"
write_transaction write_trans;
transaction trans;

write_trans = new();
trans = write_trans;
```

This is valid because `write_transaction` is derived from `transaction`.

An explicit `$cast` is normally not required for upcasting.

```text id="u5m8q2"
Child handle
     │
     ▼
Parent handle
```

## 2. Downcasting

**Downcasting** converts a parent-class handle back to a child-class handle.

Because the parent handle could refer to different child types, `$cast` should be used to safely check the actual object type.

```systemverilog id="x8p3mz"
if ($cast(write_trans, trans)) begin
    write_trans.write_only();
end
```

If `trans` actually refers to a `write_transaction` object, the cast succeeds.

If it refers to another incompatible child type, the cast fails.

## 3. Safe Casting

`$cast()` returns:

- `1` → cast succeeded
- `0` → cast failed

Example:

```systemverilog id="m6q2vx"
if ($cast(write_trans, trans))
    $display("Cast successful");
else
    $display("Cast failed");
```

This prevents unsafe assumptions about the actual object type.

## 4. Complete Runnable Example

```systemverilog id="z7k4mp"
module sv_041_cast_with_classes;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class
    class write_transaction extends transaction;

        int data;

        function void display();
            $display("Write transaction | Data = %0d", data);
        endfunction

        function void write_only();
            $display("Write-specific method");
        endfunction

    endclass


    // Another child class
    class read_transaction extends transaction;

        function void read_only();
            $display("Read-specific method");
        endfunction

    endclass


    transaction trans;
    write_transaction write_trans;
    read_transaction read_trans;

    initial begin

        // Create child object
        write_trans = new();
        write_trans.data = 100;

        // Upcasting: child handle -> parent handle
        trans = write_trans;

        $display("Upcasting:");
        trans.display();


        // Downcasting: parent handle -> child handle
        if ($cast(write_trans, trans)) begin
            $display("\nDowncasting: SUCCESS");
            write_trans.write_only();
        end
        else begin
            $display("\nDowncasting: FAILED");
        end


        // Create a different child object
        read_trans = new();
        trans = read_trans;

        // Safe cast to the wrong child type
        if ($cast(write_trans, trans)) begin
            $display("\nWrong cast: SUCCESS");
        end
        else begin
            $display("\nWrong cast: FAILED");
        end

    end

endmodule
```

### Expected Output

```text id="h9w3qc"
Upcasting:
Write transaction | Data = 100

Downcasting: SUCCESS
Write-specific method

Wrong cast: FAILED
```

### Key Concepts

| Concept | Meaning |
|---|---|
| Upcasting | Child handle converted to parent handle |
| Downcasting | Parent handle converted to child handle |
| `$cast()` | Performs a checked dynamic cast |
| `$cast()` returns `1` | Cast succeeded |
| `$cast()` returns `0` | Cast failed |
| Safe casting | Checking compatibility before using the child handle |

### Casting Flow

```text id="b2m7kp"
Child object
     │
     │ Upcasting
     ▼
Parent handle
     │
     │ $cast()
     ▼
Child handle
```

The key distinction is:

**Upcasting is normally implicit, while downcasting should use `$cast()` when the actual object type must be checked safely.**

`$cast` becomes particularly useful in verification environments where generic parent-class handles may refer to different transaction types.