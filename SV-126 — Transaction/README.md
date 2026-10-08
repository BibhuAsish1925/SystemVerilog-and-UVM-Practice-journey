
# 126 — SV-126 — Transaction

## 1. Small Introduction

A **transaction** is a class that represents one unit of stimulus or activity exchanged between a testbench and the DUT.

Instead of passing individual signals such as `addr`, `data`, and `write`, a transaction groups related information into a single object.

A transaction typically contains:

- **Fields** — data that describes the operation.
- **Methods** — functions/tasks used to create, display, or manipulate the transaction.

Transactions become the foundation for later non-UVM verification components such as the generator, driver, monitor, and scoreboard.

## 2. Important Syntax

### Transaction Class

```systemverilog
class transaction;

    logic [7:0] data;
    logic [7:0] address;
    logic       write;

endclass
````

The class fields represent the information carried by the transaction.

### Constructor

```systemverilog
function new(...);
    ...
endfunction
```

The constructor initializes a newly created transaction object.

### Method

```systemverilog
function void display();
    ...
endfunction
```

A method operates on the transaction object and can access its fields.

### Object Creation

```systemverilog
transaction tx;

initial begin
    tx = new(...);
end
```

`new()` creates an object of the transaction class.

## 3. Verification Relevance

Transactions allow the testbench to work with high-level operations instead of individual DUT signals.

For example:

```text
Transaction
    |
    +-- address
    +-- data
    +-- write
```

Later, a generator can create transactions and a driver can convert them into signal-level activity.

This gives the verification environment a clear separation between:

```text
High-level transaction
        ↓
      Driver
        ↓
   DUT interface
```

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

// ============================================================
// Transaction class
// ============================================================

class transaction;

    // Transaction fields
    rand logic [7:0]  data;
    rand logic [7:0]  address;
    rand logic        write;

    // Constructor
    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00,
        input logic        write   = 1'b0
    );
        this.address = address;
        this.data    = data;
        this.write   = write;
    endfunction

    // Display transaction contents
    function void display();
        $display("[%0t] Transaction: address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


// ============================================================
// Testbench
// ============================================================

module sv_126_transaction_tb;

    transaction tx1;
    transaction tx2;

    initial begin

        // Create first transaction
        tx1 = new(8'h10, 8'hA5, 1'b1);

        // Create second transaction
        tx2 = new(8'h20, 8'h3C, 1'b0);

        // Display transactions
        tx1.display();
        tx2.display();

        $finish;

    end

endmodule
```

## 5. Expected Behavior

The simulation displays:

```text
[0] Transaction: address=10 data=a5 write=1
[0] Transaction: address=20 data=3c write=0
$finish called at time : 0 ns
```

`tx1` and `tx2` are separate objects, each containing its own transaction fields.

## 6. Key Takeaway

```text
Transaction
    |
    +-- Fields  → describe the operation
    |
    +-- Methods → operate on the transaction
```

A transaction provides a high-level representation of stimulus and is a fundamental building block for a non-UVM SystemVerilog verification environment.
