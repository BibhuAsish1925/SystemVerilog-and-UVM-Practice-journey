
# 129 — SV-129 — Generator + Mailbox

## 1. Small Introduction

A **mailbox** provides communication between independent SystemVerilog processes or verification components.

In this example, the Generator creates randomized transactions and places them into a mailbox. A separate receiver retrieves the transactions.

The communication flow is:

**Generator → Mailbox → Receiver**

This creates separation between transaction generation and transaction consumption.

## 2. Important Concepts

### Typed Mailbox

A typed mailbox is declared as:

```systemverilog
mailbox #(transaction) gen_mbx;
````

This mailbox is designed to communicate `transaction` objects.

### `put()`

The generator places a transaction into the mailbox:

```systemverilog
gen_mbx.put(tx);
```

### `get()`

The receiver retrieves a transaction:

```systemverilog
gen_mbx.get(rx);
```

`get()` is blocking. If the mailbox is empty, the receiving process waits until a transaction becomes available.

### Concurrent Generator and Receiver

The generator and receiver execute concurrently using:

```systemverilog
fork
    ...
    ...
join
```

This models communication between independent verification components.

## 3. Verification Relevance

A mailbox allows verification components to communicate without directly depending on each other's implementation.

The architecture introduced here is:

```text
Generator
    |
    | transaction
    v
 Mailbox
    |
    | transaction
    v
 Receiver
```

This communication mechanism will be useful when connecting components such as a Generator, Driver, Monitor, and Scoreboard.

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

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class generator;

    mailbox #(transaction) gen_mbx;

    function new(mailbox #(transaction) gen_mbx);
        this.gen_mbx = gen_mbx;
    endfunction

    task generate_transactions(input int count);

        transaction tx;

        repeat (count) begin

            tx = new();

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            gen_mbx.put(tx);

            tx.display("Generated");

        end

    endtask

endclass


module sv_129_generator_mailbox_tb;

    mailbox #(transaction) gen_mbx;
    generator gen;

    initial begin

        gen_mbx = new();
        gen = new(gen_mbx);

        fork

            gen.generate_transactions(5);

            begin
                transaction rx;

                repeat (5) begin

                    gen_mbx.get(rx);

                    rx.display("Received");

                end
            end

        join

        $display("Generator and mailbox communication completed.");

        $finish;

    end

endmodule
```

## 5. Expected Output

The randomized values can change between simulations.

Example:

```text
[0] Generated: address=1A data=73 write=1
[0] Received:  address=1A data=73 write=1
[0] Generated: address=11 data=C4 write=0
[0] Received:  address=11 data=C4 write=0
[0] Generated: address=1F data=52 write=1
[0] Received:  address=1F data=52 write=1
[0] Generated: address=16 data=AE write=0
[0] Received:  address=16 data=AE write=0
[0] Generated: address=1B data=38 write=1
[0] Received:  address=1B data=38 write=1
Generator and mailbox communication completed.
$finish called at time : 0 ns
```

The exact ordering of the `Generated` and `Received` messages can vary because both processes execute concurrently.

## 6. Key Takeaway

SV-129 introduces a mailbox as a communication channel between verification components.

The main operations are:

* `put()` → sends a transaction.
* `get()` → receives a transaction.
* `mailbox #(transaction)` → creates a typed transaction mailbox.

The resulting architecture is:

```text
Generator → Mailbox → Receiver
```

This forms the foundation for transaction-based communication in a larger non-UVM verification environment.

