
# 130 — SV-130 — Driver

## 1. Small Introduction

A **Driver** receives transaction objects and converts their abstract fields into actual DUT-facing signals, often called pins.

The basic verification flow is:

**Transaction → Driver → DUT Pins**

In this example, the Driver receives transactions from a mailbox and drives:

- `address`
- `data`
- `write`
- `valid`

The Driver therefore forms the bridge between the transaction-level and signal-level parts of the testbench.

## 2. Important Concepts

### Interface

The DUT-facing signals are grouped inside an interface:

```systemverilog
interface dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface
````

### Virtual Interface

The Driver stores a virtual interface handle:

```systemverilog
virtual dut_if vif;
```

This allows a class-based component to access the interface signals.

### Receiving a Transaction

The Driver receives a transaction from the mailbox:

```systemverilog
gen_mbx.get(tx);
```

### Transaction-to-Pin Conversion

The transaction fields are converted into signal-level activity:

```systemverilog
vif.address = tx.address;
vif.data    = tx.data;
vif.write   = tx.write;
vif.valid   = 1'b1;
```

The Driver does not generate the transaction. It consumes the transaction and converts it into DUT-facing signals.

## 3. Verification Relevance

The Driver separates transaction-level stimulus from DUT signal-level activity.

The architecture is:

```text
Generator
    |
    | transaction
    v
Mailbox
    |
    | transaction
    v
Driver
    |
    | address/data/write/valid
    v
DUT Pins
```

This separation makes the verification environment easier to extend because the Generator can focus on creating transactions while the Driver focuses on applying them to the DUT.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

interface dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface


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

endclass


class driver;

    mailbox #(transaction) gen_mbx;
    virtual dut_if vif;

    function new(
        mailbox #(transaction) gen_mbx,
        virtual dut_if vif
    );
        this.gen_mbx = gen_mbx;
        this.vif     = vif;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            vif.address = tx.address;
            vif.data    = tx.data;
            vif.write   = tx.write;
            vif.valid   = 1'b1;

            $display("[%0t] Driver: address=%h data=%h write=%b",
                     $time, vif.address, vif.data, vif.write);

            #10;

            vif.valid = 1'b0;

        end

    endtask

endclass


class generator;

    mailbox #(transaction) gen_mbx;

    function new(mailbox #(transaction) gen_mbx);
        this.gen_mbx = gen_mbx;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            tx = new();

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            gen_mbx.put(tx);

        end

    endtask

endclass


module sv_130_driver_tb;

    dut_if vif();

    mailbox #(transaction) gen_mbx;

    generator gen;
    driver    drv;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        gen_mbx = new();

        gen = new(gen_mbx);
        drv = new(gen_mbx, vif);

        fork
            gen.run(5);
            drv.run(5);
        join

        $display("Generator-to-driver communication completed.");

        $finish;

    end

endmodule
```

## 5. Expected Output

The transaction values are randomized, so the exact values can change.

Example:

```text
[0] Driver: address=1A data=73 write=1
[10] Driver: address=11 data=C4 write=0
[20] Driver: address=1F data=52 write=1
[30] Driver: address=16 data=AE write=0
[40] Driver: address=1B data=38 write=1
Generator-to-driver communication completed.
$finish called at time : 50 ns
```

## 6. Key Takeaway

SV-130 introduces the **Driver** as the component responsible for converting transaction-level stimulus into DUT-facing signals.

The main flow is:

```text
Generator → Mailbox → Driver → DUT Pins
```

The Generator creates transactions, the Mailbox transfers them, and the Driver converts their fields into actual signal activity.

