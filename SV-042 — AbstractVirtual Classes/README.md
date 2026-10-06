# 042 — SV-042 — Abstract/Virtual Classes

A **virtual class** is an abstract base class that is designed to be extended by child classes.

It is declared using:

```systemverilog
virtual class transaction;
    // Members
endclass
```

A virtual class cannot be instantiated directly.

## 1. Pure Virtual Method

A pure virtual method defines a required interface without providing an implementation.

```systemverilog
pure virtual function void display();
```

A child class must provide an implementation of this method.

This allows the parent class to specify **what operation must exist**, while the child class defines **how the operation works**.

## 2. Concrete Child Class

A child class extends the virtual class and implements the pure virtual method:

```systemverilog
class write_transaction extends transaction;

    function void display();
        $display("Write transaction");
    endfunction

endclass
```

Another child can provide a different implementation:

```systemverilog
class read_transaction extends transaction;

    function void display();
        $display("Read transaction");
    endfunction

endclass
```

### Key Concepts

| Concept                 | Meaning                                                   |
| ----------------------- | --------------------------------------------------------- |
| `virtual class`         | Abstract class intended to be extended                    |
| Pure virtual method     | Method declaration without an implementation              |
| `pure virtual function` | Defines a required method interface                       |
| Concrete class          | Child class that implements required pure virtual methods |
| Parent handle           | Can refer to objects of concrete child classes            |
| `extends`               | Creates the inheritance relationship                      |

### Class Structure

```text
             virtual class
              transaction
                   │
        pure virtual display()
                   │
          ┌────────┴────────┐
          ▼                 ▼
 write_transaction    read_transaction
          │                 │
      display()          display()
          │                 │
     Write behavior     Read behavior
```

The key idea is:

**A virtual class defines a common interface, while concrete child classes provide the implementation.**

This pattern is important in verification because a base class can define common behavior and required methods, while specialized verification objects implement the protocol- or transaction-specific behavior.
