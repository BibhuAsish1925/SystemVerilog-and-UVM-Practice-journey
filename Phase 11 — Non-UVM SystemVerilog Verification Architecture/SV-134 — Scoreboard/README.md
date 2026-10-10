
# 134 — SV-134 — Scoreboard

## Introduction

A scoreboard compares expected transactions with actual transactions observed from the DUT.

The basic verification flow is:

Expected Transaction → Expected Mailbox
                              ↓
                         Scoreboard → PASS / FAIL
                              ↑
Actual Transaction → Actual Mailbox

The scoreboard receives one expected transaction and one actual transaction, compares their fields, and reports whether they match.

## Key Concepts

### Transaction

A transaction represents data exchanged with the DUT.

```systemverilog
class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

endclass
````

### Mailbox

A typed mailbox provides communication between concurrent verification components.

```systemverilog
mailbox #(transaction) expected_mbx;
mailbox #(transaction) actual_mbx;
```

### Scoreboard

The scoreboard receives transactions from both mailboxes and compares:

* address
* data
* write

If all fields match, the scoreboard reports `PASS`; otherwise it reports `FAIL`.

## Verification Relevance

A scoreboard is one of the main components of a verification environment.

Typical flow:

```text
Generator
    ↓
Driver
    ↓
DUT
    ↓
Monitor
    ↓
Actual Transaction
    ↓
Scoreboard
```

The expected transaction is normally produced by a reference model, predictor, or expected-value mechanism.

## Vivado Compatibility Note

For Vivado/XSim compatibility, transaction objects are created first and then passed to `mailbox.put()`.

Use:

```systemverilog
tx = new(...);
mailbox.put(tx);
```

instead of directly using:

```systemverilog
mailbox.put(new(...));
```

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00,
        input logic       write   = 1'b0
    );
        this.address = address;
        this.data    = data;
        this.write   = write;
    endfunction

    function void display(string name = "Transaction");
        $display("[%0t] %s: address=%h data=%h write=%b",
                 $time, name, address, data, write);
    endfunction

endclass


class scoreboard;

    mailbox #(transaction) expected_mbx;
    mailbox #(transaction) actual_mbx;

    function new(
        mailbox #(transaction) expected_mbx,
        mailbox #(transaction) actual_mbx
    );
        this.expected_mbx = expected_mbx;
        this.actual_mbx   = actual_mbx;
    endfunction

    task run(input int count);

        transaction expected;
        transaction actual;

        repeat (count) begin

            expected_mbx.get(expected);
            actual_mbx.get(actual);

            expected.display("Expected");
            actual.display("Actual");

            if ((expected.address == actual.address) &&
                (expected.data    == actual.data)    &&
                (expected.write   == actual.write))
                $display("[%0t] SCOREBOARD: PASS", $time);
            else
                $error("[%0t] SCOREBOARD: FAIL", $time);

        end

    endtask

endclass


module sv_134_scoreboard_tb;

    mailbox #(transaction) expected_mbx;
    mailbox #(transaction) actual_mbx;

    scoreboard sb;

    initial begin

        transaction tx;

        expected_mbx = new();
        actual_mbx   = new();

        sb = new(expected_mbx, actual_mbx);

        fork

            sb.run(5);

            begin

                tx = new(8'h10, 8'hA5, 1'b1);
                expected_mbx.put(tx);

                tx = new(8'h15, 8'h3C, 1'b0);
                expected_mbx.put(tx);

                tx = new(8'h1A, 8'h72, 1'b1);
                expected_mbx.put(tx);

                tx = new(8'h1F, 8'hD4, 1'b0);
                expected_mbx.put(tx);

                tx = new(8'h12, 8'h56, 1'b1);
                expected_mbx.put(tx);

            end

            begin

                tx = new(8'h10, 8'hA5, 1'b1);
                actual_mbx.put(tx);

                tx = new(8'h15, 8'h3C, 1'b0);
                actual_mbx.put(tx);

                tx = new(8'h1A, 8'h72, 1'b1);
                actual_mbx.put(tx);

                tx = new(8'h1F, 8'hD4, 1'b0);
                actual_mbx.put(tx);

                tx = new(8'h12, 8'h56, 1'b1);
                actual_mbx.put(tx);

            end

        join

        $display("Scoreboard comparison completed.");

        $finish;

    end

endmodule
```
## Expected Output

Because the expected and actual transactions are identical, all five comparisons should pass:

```text
[0] Expected: address=10 data=a5 write=1
[0] Actual: address=10 data=a5 write=1
[0] SCOREBOARD: PASS

[0] Expected: address=15 data=3c write=0
[0] Actual: address=15 data=3c write=0
[0] SCOREBOARD: PASS

[0] Expected: address=1a data=72 write=1
[0] Actual: address=1a data=72 write=1
[0] SCOREBOARD: PASS

[0] Expected: address=1f data=d4 write=0
[0] Actual: address=1f data=d4 write=0
[0] SCOREBOARD: PASS

[0] Expected: address=12 data=56 write=1
[0] Actual: address=12 data=56 write=1
[0] SCOREBOARD: PASS

Scoreboard comparison completed.
```

The exact formatting of the simulator's `$finish` message can vary.

###  Vivado Usage

1. Replace the current contents of `sv_134_scoreboard_tb.sv` with the corrected code.
2. Make sure the file extension is **`.sv`**, not `.v`.
3. Keep `sv_134_scoreboard_tb` as the simulation top module.
4. Run **Simulation → Run Behavioral Simulation**.
5. Check the Tcl Console/Simulation Log.
6. You should see **five `SCOREBOARD: PASS` messages** and no compilation errors.

The important compatibility change is:

```systemverilog
tx = new(8'h10, 8'hA5, 1'b1);
expected_mbx.put(tx);
```

instead of:

```systemverilog
expected_mbx.put(new(8'h10, 8'hA5, 1'b1));
```

