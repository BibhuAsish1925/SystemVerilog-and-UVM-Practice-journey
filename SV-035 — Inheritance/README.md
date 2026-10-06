# 035 — SV-035 — Inheritance

**Inheritance** allows a child class to reuse properties and methods from a parent class.

The inheritance relationship is created using the `extends` keyword:

```systemverilog id="0yy6gv"
class child extends parent;
    // Additional properties and methods
endclass
```

The child class automatically gets access to the accessible members of the parent class.

## 1. Parent Class

The parent class contains common functionality:

```systemverilog id="o9fr7d"
class transaction;

    int data;

    function void display();
        $display("Parent: Data = %0d", data);
    endfunction

endclass
```

## 2. Child Class

The child class extends the parent:

```systemverilog id="3e5n6k"
class extended_transaction extends transaction;

    string name;

    function void display_child();
        $display("Child: Name = %s | Data = %0d", name, data);
    endfunction

endclass
```

The child inherits:

* `data`
* `display()`

The child additionally defines:

* `name`
* `display_child()`

Therefore, the child object can access both inherited and child-specific members.


### Key Concepts

| Concept            | Meaning                                            |
| ------------------ | -------------------------------------------------- |
| Parent class       | Base class containing common functionality         |
| Child class        | Class derived from the parent                      |
| `extends`          | Creates an inheritance relationship                |
| Inherited property | Parent data member accessible through child object |
| Inherited method   | Parent method accessible through child object      |
| Child property     | Additional data member defined by the child        |
| Child method       | Additional method defined by the child             |

### Inheritance Relationship

```text
transaction
     │
     │ extends
     ▼
extended_transaction
```

Inheritance becomes especially important later for **polymorphism, virtual methods, base transaction classes, and UVM component/transaction hierarchies**.
