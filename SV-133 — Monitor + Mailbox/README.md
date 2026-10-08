
# 133 — SV-133 — Monitor + Mailbox

## 1. Small Introduction

A **Monitor + Mailbox** allows the Monitor to communicate observed transactions to another verification component without directly depending on that component.

The Monitor observes DUT pins, converts the observed activity into a transaction object, and places that transaction into a mailbox.

The basic flow is:

**DUT Pins → Monitor → Mailbox → Receiver**

This communication mechanism is important for later connecting the Monitor to a Scoreboard.

## 2. Important Concepts

### Typed Mailbox

The Monitor contains a mailbox for transaction objects:

```systemverilog
mailbox #(transaction) mon_mbx;
````

### Sending an Observed Transaction

After converting the pin activity into a transaction, the Monitor sends it through the mailbox:

```systemverilog
mon_mbx.put(tx);
```

### Receiving the Transaction

Another process retrieves the transaction:

```systemverilog
mon_mbx.get(rx);
```

`get()` is blocking, so the receiver waits when the mailbox is empty.

### Monitor Connectivity

The Monitor receives both a virtual interface and mailbox:

```systemverilog
function new(
    virtual dut_if vif,
    mailbox #(transaction) mon_mbx
);
    this.vif     = vif;
    this.mon_mbx = mon_mbx;
endfunction
```

This allows the Monitor to observe pins and communicate the resulting transaction independently.

## 3. Verification Relevance

The Monitor converts signal-level activity into transaction-level information and sends the transaction through a mailbox.

The architecture is:

```text
DUT Pins
    |
    | signal activity
    v
Monitor
    |
    | transaction
    v
Mailbox
    |
    | transaction
    v
Receiver / Scoreboard
```

This creates loose coupling between the Monitor and the component consuming its transactions.

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
    mailbox #(transaction) mon_mbx;

    function new(
        virtual dut_if vif,
        mailbox #(transaction) mon_mbx
    );
        this.vif     = vif;
        this.mon_mbx = mon_mbx;
    endfunction

    task run(input int count);

        transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.write   = vif.write;

            mon_mbx.put(tx);

            tx.display("Monitored");

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


module sv_133_monitor_mailbox_tb;

    dut_if vif();

    mailbox #(transaction) mon_mbx;
    monitor mon;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        mon_mbx = new();
        mon = new(vif, mon_mbx);

        fork

            mon.run(5);

            begin
                transaction rx;

                repeat (5) begin

                    mon_mbx.get(rx);

                    rx.display("Received");

                end
            end

            begin

                #10;
                vif.address = 8'h10;
                vif.data = 8'hA5;
                vif.write = 1'b1;
                vif.valid = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h15;
                vif.data = 8'h3C;
                vif.write = 1'b0;
                vif.valid = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1A;
                vif.data = 8'h72;
                vif.write = 1'b1;
                vif.valid = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1F;
                vif.data = 8'hD4;
                vif.write = 1'b0;
                vif.valid = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h12;
                vif.data = 8'h56;
                vif.write = 1'b1;
                vif.valid = 1'b1;

                #10;
                vif.valid = 1'b0;

            end

        join

        $display("Monitor-to-mailbox communication completed.");

        $finish;

    end

endmodule
```

## 5. Expected Output

```text
[10] Monitored: address=10 data=A5 write=1
[10] Received: address=10 data=A5 write=1
[30] Monitored: address=15 data=3C write=0
[30] Received: address=15 data=3C write=0
[50] Monitored: address=1A data=72 write=1
[50] Received: address=1A data=72 write=1
[70] Monitored: address=1F data=D4 write=0
[70] Received: address=1F data=D4 write=0
[90] Monitored: address=12 data=56 write=1
[90] Received: address=12 data=56 write=1
Monitor-to-mailbox communication completed.
$finish called at time : 100 ns
```

## 6. Key Takeaway

SV-133 introduces mailbox-based communication for observed transactions.

The main flow is:

```text
DUT Pins → Monitor → Mailbox → Receiver
```

The Monitor performs **pin-to-transaction conversion**, while the mailbox provides the communication channel for the resulting transaction.

This is the communication path that will later allow a **Monitor → Mailbox → Scoreboard** architecture.

