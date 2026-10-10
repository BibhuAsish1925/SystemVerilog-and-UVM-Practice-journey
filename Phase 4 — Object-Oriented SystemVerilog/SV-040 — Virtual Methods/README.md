# 040 — SV-040 — Virtual Methods

A **virtual method** enables **dynamic dispatch** in SystemVerilog.

Dynamic dispatch means that when a parent-class handle refers to a child object, an overridden virtual method is selected according to the **actual object type** at runtime.

## 1. Virtual Method in Parent Class

The parent class declares the method as `virtual`:

```systemverilog id="n8c3wq"
class transaction;

    virtual function void display();
        $display("Parent transaction");
    endfunction

endclass
```

This allows derived classes to provide specialized implementations.

## 2. Child Method Override

A child class can provide its own implementation:

```systemverilog id="m5r7kp"
class write_transaction extends transaction;

    function void display();
        $display("Write transaction");
    endfunction

endclass
```

Another child can provide a different implementation:

```systemverilog id="x2v9qd"
class read_transaction extends transaction;

    function void display();
        $display("Read transaction");
    endfunction

endclass
```

## 3. Dynamic Dispatch

A parent handle can refer to either child object:

```systemverilog id="c7p4mz"
transaction trans;

trans = write_trans;
trans.display();

trans = read_trans;
trans.display();
```

Because `display()` is virtual, the simulator determines which implementation to execute based on the actual object.

```text id="e4k8ws"
Parent handle
      │
      ├──→ Write object → Write display()
      │
      └──→ Read object  → Read display()
```

## 4. Complete Runnable Example

```systemverilog id="z6m3qv"
module sv_040_virtual_methods;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class 1
    class write_transaction extends transaction;

        function void display();
            $display("Write transaction");
        endfunction

    endclass


    // Child class 2
    class read_transaction extends transaction;

        function void display();
            $display("Read transaction");
        endfunction

    endclass


    // Parent handle
    transaction trans;

    // Child handles
    write_transaction write_trans;
    read_transaction read_trans;

    initial begin

        // Create write object
        write_trans = new();

        // Parent handle refers to write object
        trans = write_trans;

        // Dynamic dispatch calls write version
        trans.display();


        // Create read object
        read_trans = new();

        // Parent handle refers to read object
        trans = read_trans;

        // Dynamic dispatch calls read version
        trans.display();

    end

endmodule
```

### Expected Output

```text id="b3x8np"
Write transaction
Read transaction
```

### Key Concepts

| Concept | Meaning |
|---|---|
| `virtual` | Enables runtime/dynamic dispatch for a method |
| Parent handle | Handle declared using the base-class type |
| Child object | Object created from a derived class |
| Override | Child provides its own implementation of a parent method |
| Dynamic dispatch | Runtime selection of the overridden method |

### Dynamic Dispatch Flow

```text id="w5q2kc"
transaction trans
       │
       ├──→ write_transaction object
       │          ↓
       │      display()
       │          ↓
       │   "Write transaction"
       │
       └──→ read_transaction object
                  ↓
              display()
                  ↓
           "Read transaction"
```

The key idea is:

**The handle determines what members are accessible, while the actual object determines which virtual method implementation executes at runtime.**

Virtual methods are fundamental to **SystemVerilog polymorphism** and later become important when building reusable verification class hierarchies.