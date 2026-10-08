
# 141 — SV-141 — Complete Protocol Verification

## 1. Concept

Complete Protocol Verification combines the major non-UVM verification components into a protocol-oriented environment.

This example uses a **simplified APB-style protocol**.

The complete flow is:

```text
Generator → Driver → DUT → Monitor → Scoreboard
````

The environment performs:

```text
WRITE address=10 data=A5
WRITE address=14 data=3C
READ  address=10
READ  address=14
```

The expected read results are:

```text
READ address=10 → A5
READ address=14 → 3C
```

## 2. APB-style Transfer

The driver models two basic phases:

### Setup Phase

```text
PSEL    = 1
PENABLE = 0
```

### Access Phase

```text
PSEL    = 1
PENABLE = 1
```

A valid transfer is detected when:

```systemverilog
psel && penable && pready
```

## 3. Components

### Generator

Creates write and read transactions.

It sends transactions to:

* Driver
* Expected transaction mailbox

### Driver

Converts transaction-level information into protocol signals:

* `psel`
* `penable`
* `pwrite`
* `paddr`
* `pwdata`

### DUT

Contains a small four-location memory.

Supported addresses:

```text
10
14
18
1C
```

Write operations store data.

Read operations return the stored data.

### Monitor

Observes actual protocol transfers.

It waits until the required number of **valid transfers** have been observed.

This is important because:

```text
Number of clock cycles ≠ Number of transactions
```

The monitor therefore uses:

```systemverilog
while (observed_count < count)
```

and increments the counter only after detecting a valid transfer.

### Scoreboard

The scoreboard compares:

* Operation type
* Address
* Write data
* Read data

A read passes when:

```text
Expected read data == Actual DUT read data
```

## 4. Verification Architecture

```text
                 +----------------+
                 |   Generator    |
                 +-------+--------+
                         |
                  Transactions
                         |
                         v
                 +-------+--------+
                 |     Driver     |
                 +-------+--------+
                         |
                    APB Signals
                         |
                         v
                 +-------+--------+
                 | APB-style DUT  |
                 +-------+--------+
                         |
                    APB Signals
                         |
                         v
                 +-------+--------+
                 |    Monitor     |
                 +-------+--------+
                         |
                  Actual Transactions
                         |
                         v
                 +-------+--------+
                 |   Scoreboard   |
                 +----------------+

Generator ─────────────→ Expected Transactions
```

## 5. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

interface sv141_apb_if;

    logic       clk;
    logic       reset;

    logic       psel;
    logic       penable;
    logic       pwrite;
    logic [7:0] paddr;
    logic [7:0] pwdata;

    logic [7:0] prdata;
    logic       pready;

endinterface


module sv_141_apb_dut (
    sv141_apb_if vif
);

    logic [7:0] mem [0:3];

    assign vif.pready = vif.psel && vif.penable;

    always_ff @(posedge vif.clk) begin

        if (vif.reset) begin

            mem[0]     <= 8'h00;
            mem[1]     <= 8'h00;
            mem[2]     <= 8'h00;
            mem[3]     <= 8'h00;
            vif.prdata <= 8'h00;

        end
        else if (vif.psel && vif.penable) begin

            if (vif.pwrite) begin

                case (vif.paddr)

                    8'h10: mem[0] <= vif.pwdata;
                    8'h14: mem[1] <= vif.pwdata;
                    8'h18: mem[2] <= vif.pwdata;
                    8'h1C: mem[3] <= vif.pwdata;

                    default: ;

                endcase

            end
            else begin

                case (vif.paddr)

                    8'h10: vif.prdata <= mem[0];
                    8'h14: vif.prdata <= mem[1];
                    8'h18: vif.prdata <= mem[2];
                    8'h1C: vif.prdata <= mem[3];

                    default: vif.prdata <= 8'h00;

                endcase

            end

        end

    end

endmodule


class sv141_transaction;

    logic       write;
    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] expected_data;

    function new(
        input logic       write         = 1'b0,
        input logic [7:0] address       = 8'h00,
        input logic [7:0] data          = 8'h00,
        input logic [7:0] expected_data = 8'h00
    );

        this.write         = write;
        this.address       = address;
        this.data          = data;
        this.expected_data = expected_data;

    endfunction

endclass


class sv141_generator;

    mailbox #(sv141_transaction) gen_mbx;
    mailbox #(sv141_transaction) expected_mbx;

    function new(
        mailbox #(sv141_transaction) gen_mbx,
        mailbox #(sv141_transaction) expected_mbx
    );

        this.gen_mbx      = gen_mbx;
        this.expected_mbx = expected_mbx;

    endfunction


    task run();

        sv141_transaction tx;

        tx = new(1'b1, 8'h10, 8'hA5, 8'h00);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        tx = new(1'b1, 8'h14, 8'h3C, 8'h00);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        tx = new(1'b0, 8'h10, 8'h00, 8'hA5);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

        tx = new(1'b0, 8'h14, 8'h00, 8'h3C);
        gen_mbx.put(tx);
        expected_mbx.put(tx);

    endtask

endclass


class sv141_driver;

    mailbox #(sv141_transaction) gen_mbx;
    virtual sv141_apb_if vif;

    function new(
        mailbox #(sv141_transaction) gen_mbx,
        virtual sv141_apb_if vif
    );

        this.gen_mbx = gen_mbx;
        this.vif     = vif;

    endfunction


    task run(input int count);

        sv141_transaction tx;

        repeat (count) begin

            gen_mbx.get(tx);

            @(negedge vif.clk);

            vif.psel    = 1'b1;
            vif.penable = 1'b0;
            vif.pwrite  = tx.write;
            vif.paddr   = tx.address;
            vif.pwdata  = tx.data;

            @(negedge vif.clk);

            vif.penable = 1'b1;

            @(posedge vif.clk);

            #1;

            $display("[%0t] Driver: %s address=%h data=%h",
                     $time,
                     tx.write ? "WRITE" : "READ ",
                     tx.address,
                     tx.data);

            @(negedge vif.clk);

            vif.psel    = 1'b0;
            vif.penable = 1'b0;

        end

    endtask

endclass


class sv141_monitor;

    virtual sv141_apb_if vif;
    mailbox #(sv141_transaction) actual_mbx;

    function new(
        virtual sv141_apb_if vif,
        mailbox #(sv141_transaction) actual_mbx
    );

        this.vif        = vif;
        this.actual_mbx = actual_mbx;

    endfunction


    task run(input int count);

        sv141_transaction tx;
        int observed_count;

        observed_count = 0;

        while (observed_count < count) begin

            @(posedge vif.clk);

            #1;

            if (vif.psel && vif.penable && vif.pready) begin

                tx = new();

                tx.write   = vif.pwrite;
                tx.address = vif.paddr;

                if (vif.pwrite)
                    tx.data = vif.pwdata;
                else
                    tx.data = vif.prdata;

                actual_mbx.put(tx);

                $display("[%0t] Monitor: %s address=%h data=%h",
                         $time,
                         tx.write ? "WRITE" : "READ ",
                         tx.address,
                         tx.data);

                observed_count++;

            end

        end

    endtask

endclass


class sv141_scoreboard;

    mailbox #(sv141_transaction) expected_mbx;
    mailbox #(sv141_transaction) actual_mbx;

    int pass_count;
    int fail_count;

    function new(
        mailbox #(sv141_transaction) expected_mbx,
        mailbox #(sv141_transaction) actual_mbx
    );

        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;

        pass_count = 0;
        fail_count = 0;

    endfunction


    task run(input int count);

        sv141_transaction expected;
        sv141_transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            if (expected.write != actual.write) begin

                $error("[%0t] SCOREBOARD FAIL: operation mismatch",
                       $time);

                fail_count++;

            end
            else if (expected.address != actual.address) begin

                $error("[%0t] SCOREBOARD FAIL: address mismatch",
                       $time);

                fail_count++;

            end
            else if (expected.write) begin

                if (expected.data == actual.data) begin

                    $display("[%0t] SCOREBOARD PASS: WRITE address=%h data=%h",
                             $time,
                             actual.address,
                             actual.data);

                    pass_count++;

                end
                else begin

                    $error("[%0t] SCOREBOARD FAIL: WRITE data mismatch",
                           $time);

                    fail_count++;

                end

            end
            else begin

                if (expected.expected_data == actual.data) begin

                    $display("[%0t] SCOREBOARD PASS: READ address=%h data=%h",
                             $time,
                             actual.address,
                             actual.data);

                    pass_count++;

                end
                else begin

                    $error("[%0t] SCOREBOARD FAIL: READ expected=%h actual=%h",
                           $time,
                           expected.expected_data,
                           actual.data);

                    fail_count++;

                end

            end

        end

    endtask


    function void report();

        $display("========================================");
        $display("PROTOCOL SCOREBOARD SUMMARY");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

    endfunction

endclass


module sv_141_complete_protocol_verification_tb;

    sv141_apb_if vif();

    mailbox #(sv141_transaction) gen_mbx;
    mailbox #(sv141_transaction) expected_mbx;
    mailbox #(sv141_transaction) actual_mbx;

    sv141_generator  gen;
    sv141_driver     drv;
    sv141_monitor    mon;
    sv141_scoreboard sb;

    sv_141_apb_dut dut (
        .vif(vif)
    );


    initial begin

        vif.clk    = 1'b0;
        vif.reset  = 1'b1;

        vif.psel    = 1'b0;
        vif.penable = 1'b0;
        vif.pwrite  = 1'b0;
        vif.paddr   = 8'h00;
        vif.pwdata  = 8'h00;

        gen_mbx      = new();
        expected_mbx = new();
        actual_mbx   = new();

        gen = new(gen_mbx, expected_mbx);
        drv = new(gen_mbx, vif);
        mon = new(vif, actual_mbx);
        sb  = new(expected_mbx, actual_mbx);

        repeat (2)
            @(negedge vif.clk);

        vif.reset = 1'b0;

        $display("Starting complete protocol verification...");

        fork

            gen.run();
            drv.run(4);
            mon.run(4);
            sb.run(4);

        join

        sb.report();

        $display("Complete protocol verification completed.");

        $finish;

    end


    always #5 vif.clk = ~vif.clk;

endmodule
```

## 6. Expected Result

The corrected environment should produce four successful comparisons:

```text
WRITE 10 → A5
WRITE 14 → 3C
READ  10 → A5
READ  14 → 3C
```

Final result:

```text
PROTOCOL SCOREBOARD SUMMARY
PASS = 4
FAIL = 0
```

## 7. Vivado Usage

Save as:

```text
sv_141_complete_protocol_verification.sv
```

Set simulation top:

```text
sv_141_complete_protocol_verification_tb
```

Run:

```text
close_sim
launch_simulation
run 1000ns
```

The complete architecture is:

```text
Generator
    ↓
Driver
    ↓
APB-style DUT
    ↓
Monitor
    ↓
Scoreboard
```

This architecture can later be adapted for UART, SPI, AXI, or other protocol verification environments.

