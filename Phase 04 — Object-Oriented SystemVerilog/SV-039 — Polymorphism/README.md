# 039 — SV-039 — Polymorphism

**Polymorphism** allows a parent-class handle to refer to an object of a child class.

When a method is declared `virtual`, the implementation selected at runtime is based on the **actual object type**.

## 1. Parent Handle

A parent-class handle can be declared normally:

```systemverilog id="h2m7qk"
transaction trans;
```

It can then refer to an object created from a derived class:

```systemverilog id="v8n3px"
write_transaction write_trans;

write_trans = new();
trans = write_trans;
```

The handle type is `transaction`, but the actual object is a `write_transaction`.

## 2. Virtual Method

The parent declares the method as `virtual`:

```systemverilog id="x5k9mz"
virtual function void display();
    $display("Parent transaction");
endfunction
```

The child provides its own implementation:

```systemverilog id="q4r8vc"
function void display();
    $display("Write transaction");
endfunction
```

When the parent handle refers to the child object:

```systemverilog id="n7p2wd"
trans.display();
```

the child's `display()` implementation is executed.

## 3. Multiple Child Classes

The same parent handle can refer to different child objects:

```text id="b6x3qm"
             transaction
                  │
          ┌───────┴────────┐
          ▼                ▼
 write_transaction   read_transaction
```

This allows common code to work with different derived object types.

## 4. Complete Runnable Example

```systemverilog id="z3m8kp"
module sv_039_polymorphism;

    // Parent class
    class transaction;

        virtual function void display();
            $display("Parent transaction");
        endfunction

    endclass


    // Child class
    class write_transaction extends transaction;

        function void display();
            $display("Write transaction");
        endfunction

    endclass


    // Another child class
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

        // Create write child object
        write_trans = new();

        // Parent handle refers to write child object
        trans = write_trans;

        // Calls write_transaction implementation
        trans.display();


        // Create read child object
        read_trans = new();

        // Parent handle now refers to read child object
        trans = read_trans;

        // Calls read_transaction implementation
        trans.display();

    end

endmodule
```

### Expected Output

```text id="c7w2nd"
Write transaction
Read transaction
```

### Key Concepts

| Concept | Meaning |
|---|---|
| Parent handle | Handle declared using the parent class type |
| Child object | Object created from a derived class |
| `extends` | Creates the parent-child relationship |
| `virtual` | Enables runtime method dispatch |
| Method overriding | Child provides its own implementation of a parent method |
| Polymorphism | One parent handle can refer to different child object types |

### Important Relationship

```text id="e8m4qp"
Parent handle
     │
     ├──→ Child object A → Child A method
     │
     └──→ Child object B → Child B method
```

Without `virtual`, a parent-handle method call does not provide the same runtime polymorphic behavior. With virtual methods, the **actual object type determines which overridden method executes**.

Polymorphism is a key foundation for later **UVM class hierarchies and reusable verification components**.