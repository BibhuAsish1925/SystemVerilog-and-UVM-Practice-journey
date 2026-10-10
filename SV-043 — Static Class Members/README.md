# 043 — SV-043 — Static Class Members

A **static class member** belongs to the class rather than to an individual object.

SystemVerilog supports:

- Static properties
- Static methods

## 1. Static Property

A static property is declared using `static`:

```systemverilog id="p4m8x2"
static int object_count;
```

Only one copy exists for the entire class.

Therefore, multiple objects share the same property:

```text
trans1 ──┐
         ├──→ object_count
trans2 ──┘
```

For example, the constructor can increment the shared counter:

```systemverilog id="v7k3q9"
function new(int data);
    this.data = data;
    object_count++;
endfunction
```

After two objects are created:

```text
object_count = 2
```

## 2. Static Method

A static method is declared using `static`:

```systemverilog id="x5n2mc"
static function void display_count();
    $display("Total objects created = %0d", object_count);
endfunction
```

It can be called using the class scope operator:

```systemverilog id="r8q4kp"
transaction::display_count();
```

An object is not required.

## 3. Static vs Instance Members

An instance property belongs to each object:

```systemverilog id="z6m3vx"
int data;
```

For example:

```text
trans1.data = 100
trans2.data = 200
```

Each object has its own `data`.

A static property is shared:

```systemverilog id="n9p2wd"
static int object_count;
```

Both objects access the same `object_count`.

A static method also does not represent a particular object, so it should not directly access instance properties such as `data`.

## 4. Complete Runnable Example

```systemverilog id="c7m4qz"
module sv_043_static_class_members;

    class transaction;

        // Static property shared by all objects
        static int object_count;

        // Instance property
        int data;

        // Constructor
        function new(int data);
            this.data = data;
            object_count++;
        endfunction

        // Static method
        static function void display_count();
            $display("Total objects created = %0d", object_count);
        endfunction

        // Instance method
        function void display_data();
            $display("Data = %0d", data);
        endfunction

    endclass


    transaction trans1;
    transaction trans2;

    initial begin

        // Create first object
        trans1 = new(100);

        // Create second object
        trans2 = new(200);

        // Instance methods access individual object data
        trans1.display_data();
        trans2.display_data();

        // Static property is shared by both objects
        $display("Shared count = %0d", transaction::object_count);

        // Static method called using class scope
        transaction::display_count();

    end

endmodule
```

### Expected Output

```text
Data = 100
Data = 200
Shared count = 2
Total objects created = 2
```

### Key Concepts

| Concept | Meaning |
|---|---|
| `static` property | One shared property for the entire class |
| `static` method | Method associated with the class rather than a particular object |
| Instance property | Separate copy for each object |
| Instance method | Operates in the context of a particular object |
| `ClassName::member` | Class-scope access to a static member |
| Shared property | Same value is visible across all objects |

### Static vs Instance

```text
Class: transaction
│
├── static object_count ──→ One shared copy
│
├── trans1
│    └── data = 100
│
└── trans2
     └── data = 200
```

The key idea is:

**Instance members belong to individual objects, while static members belong to the class and are shared across its objects.**

Static class members are useful in verification for shared counters, utility functions, and class-level configuration or state.