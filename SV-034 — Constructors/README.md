# 034 — SV-034 — Constructors

A **constructor** is a special class method used to initialize an object when it is created.

In SystemVerilog, the constructor is declared using:

```systemverilog
function new();
```

It can also accept arguments:

```systemverilog
function new(int data, string name);
```

The constructor is called automatically when an object is created using `new()`.

## 1. Constructor Without Arguments

A constructor can initialize properties without receiving external values:

```systemverilog
function new();
    data = 0;
    name = "Default";
endfunction
```

## 2. Constructor With Arguments

Arguments allow each object to receive different initial values:

```systemverilog
function new(int data, string name);
    this.data = data;
    this.name = name;
endfunction
```

`this` refers to the **current object**.

Therefore:

```systemverilog
this.data = data;
```

means the object's `data` property receives the constructor argument `data`.

## 3. Object Creation

The constructor is invoked during object creation:

```systemverilog
trans1 = new(100, "Transaction-1");
trans2 = new(200, "Transaction-2");
```

This creates two independent objects with different initialized values.

## 4. Initialization Flow

The basic flow is:

```text
Class declaration
       ↓
Object handle
       ↓
new(arguments)
       ↓
Constructor executes
       ↓
Object properties initialized
```

## 5. Complete Runnable Example

```systemverilog
module sv_034_constructors;

    class transaction;

        // Data members
        int data;
        string name;

        // Constructor with arguments
        function new(int data, string name);
            this.data = data;
            this.name = name;
        endfunction

        // Display method
        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

    endclass

    // Object handles
    transaction trans1;
    transaction trans2;

    initial begin

        // Create objects and initialize using constructor
        trans1 = new(100, "Transaction-1");
        trans2 = new(200, "Transaction-2");

        // Display initialized objects
        trans1.display();
        trans2.display();

    end

endmodule
```

### Expected Output

```text
Name = Transaction-1 | Data = 100
Name = Transaction-2 | Data = 200
```

### Key Concepts

| Concept | Meaning |
|---|---|
| `new()` | Constructor used during object creation |
| Constructor arguments | Values passed to initialize an object |
| `this` | Refers to the current class object |
| Initialization | Assigning initial values to object properties |
| `object = new(...)` | Creates and initializes a class object |

Constructors are especially useful for **verification transaction classes**, where fields such as address, data, command, or control information can be initialized when the transaction object is created.