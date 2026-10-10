
# 132 — SV-132 — Monitor

## 1. Small Introduction

A **Monitor** observes DUT-facing signals through a virtual interface and converts the observed pin-level activity back into a transaction object.

The basic flow is:

**DUT Pins → Monitor → Transaction**

The Monitor performs the reverse operation of the Driver:

- **Driver:** Transaction → Pins
- **Monitor:** Pins → Transaction

In this example, the Monitor waits for `valid`, samples `address`, `data`, and `write`, and creates a transaction object.

## 2. Important Concepts

### Virtual Interface

The Monitor stores a virtual interface handle:

```systemverilog
virtual dut_if vif;
````

This provides the class with access to the actual interface signals.

### Waiting for Valid Activity

The Monitor waits until a valid transaction is present:

```systemverilog
wait (vif.valid == 1'b1);
```

### Creating a Transaction

Once valid activity is detected, the Monitor creates a transaction:

```systemverilog
tx = new();
```

### Pin-to-Transaction Conversion

The interface signals are sampled into the transaction:

```systemverilog
tx.address = vif.address;
tx.data    = vif.data;
tx.write   = vif.write;
```

This converts signal-level activity back into an abstract transaction.

## 3. Verification Relevance

The Monitor allows the verification environment to observe what is actually happening at the DUT interface.

The basic architecture is:

```text
DUT Pins
    |
    | signal-level activity
    v
Monitor
    |
    | transaction
    v
Transaction
```

Combined with the Driver, the verification flow becomes:

```text
              Transaction
                  |
                  v
              Generator
                  |
                  v
               Mailbox
                  |
                  v
               Driver
                  |
                  v
               DUT Pins
                  |
                  v
               Monitor
                  |
                  v
              Transaction
```

The generated transaction and monitored transaction can later be compared by a Scoreboard.

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

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class monitor;

    virtual dut_if vif;

    function new(virtual dut_if vif);
        this.vif = vif;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.write   = vif.write;

            tx.display("Monitored");

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


module sv_132_monitor_tb;

    dut_if vif();

    monitor mon;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        mon = new(vif);

        fork

            mon.run(5);

            begin

                #10;
                vif.address = 8'h10;
                vif.data    = 8'hA5;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h15;
                vif.data    = 8'h3C;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1A;
                vif.data    = 8'h72;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1F;
                vif.data    = 8'hD4;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h12;
                vif.data    = 8'h56;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

            end

        join

        $display("Monitor completed pin-to-transaction conversion.");

        $finish;

    end

endmodule
```

## 5. Expected Output

```text
[10] Monitored: address=10 data=A5 write=1
[30] Monitored: address=15 data=3C write=0
[50] Monitored: address=1A data=72 write=1
[70] Monitored: address=1F data=D4 write=0
[90] Monitored: address=12 data=56 write=1
Monitor completed pin-to-transaction conversion.
$finish called at time : 100 ns
```

## 6. Key Takeaway

SV-132 introduces the **Monitor** as the component responsible for converting DUT pin-level activity back into transaction-level information.

The main conversion is:

```text
DUT Pins → Monitor → Transaction
```

The Driver and Monitor therefore perform opposite operations:

```text
Driver  : Transaction → Pins
Monitor : Pins → Transaction
```

This monitored transaction can later be sent to a Scoreboard for comparison and checking.


