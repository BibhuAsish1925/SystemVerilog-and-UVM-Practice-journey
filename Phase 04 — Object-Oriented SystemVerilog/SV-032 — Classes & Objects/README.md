# 032 — SV-032 — Classes & Objects

Classes are the foundation of **object-oriented programming in SystemVerilog** and are widely used in verification.

A class defines the properties and behavior of an object.

## 1. Class Declaration

A class is declared using the `class` keyword:

```systemverilog
class transaction;

    int data;
    string name;

endclass
```

The class contains:

- **Properties** — data stored by the object.
- **Methods** — functions or tasks that operate on the object.

## 2. Object Handle

A class variable is actually an **object handle**:

```systemverilog
transaction trans;
```

At this point, `trans` does not refer to a created object.

The handle must be assigned an object before its members are accessed.

## 3. `new()`

The `new()` constructor creates an object:

```systemverilog
trans = new(100, "Transaction-1");
```

The constructor can initialize the object's properties.

Inside the constructor:

```systemverilog
this.data = data;
this.name = name;
```

`this` refers to the current object.

## Basic Flow

```text
Class declaration
       ↓
Object handle
       ↓
new()
       ↓
Object created
       ↓
Access properties/methods
```

## Verification Relevance

Classes are fundamental to SystemVerilog verification because they are used to model:

- Transactions
- Stimulus
- Configuration objects
- Drivers
- Monitors
- Scoreboards
- Reusable verification components

This concept is the starting point for the object-oriented features used later in SystemVerilog and UVM.

## Complete Runnable Code

```systemverilog
module sv_032_classes_objects;

    // Class declaration
    class transaction;

        int data;
        string name;

        // Constructor
        function new(int data, string name);
            this.data = data;
            this.name = name;
        endfunction

        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

    endclass

    // Object handle
    transaction trans;

    initial begin

        // Create object using new()
        trans = new(100, "Transaction-1");

        // Access object properties and method
        trans.display();

    end

endmodule
```