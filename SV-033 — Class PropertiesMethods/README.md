# 033 — SV-033 — Class Properties/Methods

SystemVerilog classes can contain **data members** and **methods**. Data members represent the state of an object, while methods operate on that state.

In verification, this concept is fundamental because objects such as transactions, generators, drivers, monitors, and scoreboards are commonly implemented using classes.

## 1. Data Members

Data members are variables declared inside a class.

```systemverilog
class transaction;
    int data;
    string name;
endclass
```

Each object created from the class has its own copy of these members.

They can be accessed using the object handle:

```systemverilog
trans.name = "Transaction-1";
trans.data = 100;
```

## 2. Function Methods

A function declared inside a class is called a **method**.

```systemverilog
function void display();
    $display("Name = %s | Data = %0d", name, data);
endfunction
```

A method can directly access the class object's data members.

Functions cannot consume simulation time, so they cannot contain timing controls such as `#10` or `@(...)`.

## 3. Task Methods

A task can also be declared inside a class.

```systemverilog
task process_transaction();
    $display("Processing %s...", name);
    #10;
    $display("Process complete | Data = %0d", data);
endtask
```

Unlike functions, tasks can consume simulation time using delays or event controls.

## 4. Complete Runnable Example

```systemverilog
module sv_033_class_properties_methods;

    class transaction;

        // Data members
        int data;
        string name;

        // Function method
        function void display();
            $display("Name = %s | Data = %0d", name, data);
        endfunction

        // Function method to modify data
        function void set_data(int new_data);
            data = new_data;
        endfunction

        // Task method
        task process_transaction();
            $display("Processing %s...", name);
            #10;
            $display("Process complete | Data = %0d", data);
        endtask

    endclass

    // Object handle
    transaction trans;

    initial begin

        // Create object
        trans = new();

        // Access data members
        trans.name = "Transaction-1";
        trans.data = 100;

        // Call function methods
        trans.display();

        trans.set_data(200);
        trans.display();

        // Call task method
        trans.process_transaction();

    end

endmodule
```

### Expected Output

```text
Name = Transaction-1 | Data = 100
Name = Transaction-1 | Data = 200
Processing Transaction-1...
Process complete | Data = 200
```

### Key Concepts

| Concept | Meaning |
|---|---|
| Data member | Variable declared inside a class |
| Function method | Class function that performs an operation without consuming simulation time |
| Task method | Class task that can consume simulation time |
| Object handle | Variable that refers to a class object |
| `new()` | Creates the class object |
| `object.member` | Accesses a data member or method |
| `#10` | Simulation delay allowed inside a task |

This distinction between **functions and tasks inside classes** becomes important later when verification components such as drivers and monitors are introduced.