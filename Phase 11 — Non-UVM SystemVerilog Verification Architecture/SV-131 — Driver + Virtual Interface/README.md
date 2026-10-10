# 131 — SV-131 — Driver + Virtual Interface

## 1. Small Introduction

A **virtual interface** provides a connection between a class-based verification component and signals declared in a SystemVerilog interface.

A class cannot directly access DUT/interface signals. Instead, the class receives a virtual interface handle that refers to an actual interface instance.

The connectivity flow is:

**Generator → Mailbox → Driver → Virtual Interface → DUT Signals**

In this example, the Driver receives the virtual interface through its constructor and uses it to drive the interface signals.

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

The Driver declares a virtual interface handle:

```systemverilog
virtual dut_if vif;
```

This handle allows the Driver class to access the signals belonging to the actual interface instance.

### Interface Instance

The testbench module creates the real interface instance:

```systemverilog
dut_if vif();
```

### Passing the Interface to the Driver

The interface instance is passed to the Driver constructor:

```systemverilog
drv = new(gen_mbx, vif);
```

The Driver stores it:

```systemverilog
function new(
    mailbox #(transaction) gen_mbx,
    virtual dut_if vif
);
    this.gen_mbx = gen_mbx;
    this.vif     = vif;
endfunction
```

### Driving DUT Signals

The Driver receives a transaction and converts its fields into interface signals:

```systemverilog
vif.address = tx.address;
vif.data    = tx.data;
vif.write   = tx.write;
vif.valid   = 1'b1;
```

Therefore, the virtual interface acts as the connectivity mechanism between the class-based Driver and the signal-level testbench.

## 3. Verification Relevance

Virtual interfaces are important because verification components such as Drivers and Monitors are usually implemented as classes, while DUT signals exist in modules or interfaces.

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
    | virtual interface
    v
dut_if
    |
    | signal-level activity
    v
DUT
```

This separation allows the Driver to remain a class-based component while still controlling DUT-facing signals.

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

            $display("[%0t] Driver -> DUT: address=%h data=%h write=%b valid=%b",
                     $time,
                     vif.address,
                     vif.data,
                     vif.write,
                     vif.valid);

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


module sv_131_driver_virtual_interface_tb;

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

        $display("Virtual interface connectivity completed.");

        $finish;

    end

endmodule
```

## 5. Expected Output

The transaction values are randomized, so the exact values can change between simulations.

Example:

```text
[0] Driver -> DUT: address=1A data=73 write=1 valid=1
[10] Driver -> DUT: address=11 data=C4 write=0 valid=1
[20] Driver -> DUT: address=1F data=52 write=1 valid=1
[30] Driver -> DUT: address=16 data=AE write=0 valid=1
[40] Driver -> DUT: address=1B data=38 write=1 valid=1
Virtual interface connectivity completed.
$finish called at time : 50 ns
```

## 6. Key Takeaway

SV-131 introduces the **virtual interface** as the connection between class-based verification components and DUT-facing signals.

The main flow is:

```text
Generator → Mailbox → Driver → Virtual Interface → DUT Signals
```

The Driver receives transactions through the mailbox and uses its virtual interface handle to drive the actual interface signals.

This mechanism is fundamental to class-based SystemVerilog verification and will also be used extensively in UVM.

