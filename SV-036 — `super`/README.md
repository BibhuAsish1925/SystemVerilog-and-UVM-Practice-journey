# 036 — SV-036 — `super`

The SystemVerilog `super` keyword allows a child class to explicitly access members of its parent class.

Two important uses are:

```systemverilog id="t8v3q1"
super.new(...)
```

and

```systemverilog id="7j2m5n"
super.method(...)
```

## 1. `super.new()`

`super.new()` calls the constructor of the parent class.

Example:

```systemverilog id="9q4k2p"
class extended_transaction extends transaction;

    function new(int data, string name);
        super.new(data);
        this.name = name;
    endfunction

endclass
```

Here, the child constructor first calls the parent constructor to initialize the inherited `data` property.

The child then initializes its own `name` property.

When a parent class has a constructor with required arguments, the child constructor can explicitly call it using `super.new(...)`.

## 2. `super.method()`

`super.method()` calls a method defined in the parent class.

Example:

```systemverilog id="m2c8vz"
function void display_child();

    super.display();

    $display("Child method: Name = %s", name);

endfunction
```

This allows the child method to reuse the parent's behavior and then add child-specific behavior.

## 3. Complete Runnable Example

```systemverilog id="x7q1mb"
module sv_036_super;

    // Parent class
    class transaction;

        int data;

        // Parent constructor
        function new(int data);
            this.data = data;
            $display("Parent constructor called");
        endfunction

        // Parent method
        function void display();
            $display("Parent method: Data = %0d", data);
        endfunction

    endclass


    // Child class
    class extended_transaction extends transaction;

        string name;

        // Child constructor
        function new(int data, string name);

            // Call parent constructor
            super.new(data);

            this.name = name;

            $display("Child constructor called");

        endfunction

        // Child method
        function void display_child();

            // Call parent method
            super.display();

            $display("Child method: Name = %s", name);

        endfunction

    endclass


    extended_transaction trans;

    initial begin

        // Create child object
        trans = new(100, "Transaction-1");

        // Call child method
        trans.display_child();

    end

endmodule
```

### Expected Output

```text id="2w8z5c"
Parent constructor called
Child constructor called
Parent method: Data = 100
Child method: Name = Transaction-1
```

### Key Concepts

| Syntax | Purpose |
|---|---|
| `super` | Refers to the parent-class portion of the current object |
| `super.new()` | Calls the parent constructor |
| `super.method()` | Calls a parent-class method |
| `this` | Refers to the current object |
| `extends` | Creates the parent-child inheritance relationship |

### Execution Order

For the constructor:

```text
Child new()
   ↓
super.new()
   ↓
Parent constructor
   ↓
Child initialization
```

For the method:

```text
Child method
   ↓
super.method()
   ↓
Parent method
   ↓
Child-specific behavior
```

`super` is especially useful when a derived verification class needs to **reuse parent initialization or behavior while adding its own functionality**.