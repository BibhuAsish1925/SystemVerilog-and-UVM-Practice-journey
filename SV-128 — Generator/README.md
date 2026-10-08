
# 128 — SV-128 — Generator

## 1. Small Introduction

A **Generator** is a verification component responsible for creating transaction objects and supplying generated stimulus to the verification environment.

In this example, the generator:

- Creates a transaction object.
- Randomizes the transaction.
- Generates multiple transactions.
- Displays each generated transaction.

This separates **transaction generation** from the main testbench and forms the foundation of a class-based verification architecture.

## 2. Important Concepts

### Transaction

A transaction represents one unit of stimulus.

```systemverilog
class transaction;
````

The transaction contains randomized fields:

```systemverilog
rand logic [7:0] address;
rand logic [7:0] data;
rand logic       write;
```

### Generator

The generator owns a transaction object:

```systemverilog
class generator;

    transaction tx;
```

The constructor creates the transaction:

```systemverilog
function new();
    tx = new();
endfunction
```

### Transaction Generation

The `generate_transactions()` task creates multiple randomized transactions:

```systemverilog
task generate_transactions(input int count);
```

Each transaction is randomized using:

```systemverilog
if (!tx.randomize())
    $fatal(1, "Transaction randomization failed");
```

The generator can therefore produce a sequence of valid stimulus transactions without placing the generation logic directly inside the testbench.

## 3. Verification Relevance

A generator is important because it separates:

**Testbench → Generator → Transactions → Future Driver**

Later, this generator can be connected to a driver so that generated transactions are converted into actual DUT signal activity.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

class transaction;

    rand logic [7:0] address;
    rand logic [7:0] data;
    rand logic       write;

    constraint address_range {
        address inside {[8'h10:8'h1F]};
    }

    constraint data_range {
        data inside {[8'h20:8'hEF]};
    }

    function void display();
        $display("[%0t] Transaction: address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


class generator;

    transaction tx;

    function new();
        tx = new();
    endfunction

    task generate_transactions(input int count);

        repeat (count) begin

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            tx.display();

        end

    endtask

endclass


module sv_128_generator_tb;

    generator gen;

    initial begin

        gen = new();

        $display("Starting transaction generation...");

        gen.generate_transactions(5);

        $display("Transaction generation completed.");

        $finish;

    end

endmodule
```

## 5. Expected Output

The transaction values are randomized, so the exact output can change between simulations.

Example:

```text
Starting transaction generation...
[0] Transaction: address=1A data=73 write=1
[0] Transaction: address=11 data=C4 write=0
[0] Transaction: address=1F data=52 write=1
[0] Transaction: address=16 data=AE write=0
[0] Transaction: address=1B data=38 write=1
Transaction generation completed.
$finish called at time : 0 ns
```

## 6. Key Takeaway

SV-128 introduces the **Generator** as a separate verification component.

The generator is responsible for creating randomized transactions, while the testbench controls the generator.

This separation prepares the verification environment for the next components such as the **Driver, Monitor, and Scoreboard**.

