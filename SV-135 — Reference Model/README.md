
# 135 — SV-135 — Reference Model

## Introduction

A reference model predicts the expected behavior of the DUT for a given input transaction.

Instead of manually specifying expected results, the reference model calculates what the DUT should produce according to the intended design behavior.

Basic verification flow:

```text
Input Transaction
       │
       ├──────────────► DUT ─────────► Actual Result
       │
       └──────────────► Reference Model ─► Expected Result
                                              │
                                              ▼
                                         Scoreboard
````

For this example, the expected DUT behavior is:

```text
result = data + address
```

The reference model implements this expected behavior.

## Key Concepts

### Transaction

A transaction contains the input information supplied to the DUT.

```systemverilog
class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] result;

endclass
```

### Reference Model

The reference model calculates the expected DUT result.

```systemverilog
class reference_model;

    function logic [7:0] predict(transaction tx);

        predict = tx.data + tx.address;

    endfunction

endclass
```

The `predict()` method receives a transaction and returns the expected result.

### Verification Relevance

A reference model separates expected behavior from the testbench stimulus.

A typical non-UVM verification architecture is:

```text
Generator
    │
    ├──────────────► Driver ──► DUT ──► Monitor ──► Actual
    │
    └──────────────► Reference Model ─────────────► Expected
                                                       │
                                                       ▼
                                                  Scoreboard
```

The scoreboard can then compare the reference-model prediction with the transaction observed from the DUT.

## Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

class transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic [7:0] result;

    function new(
        input logic [7:0] address = 8'h00,
        input logic [7:0] data    = 8'h00
    );
        this.address = address;
        this.data    = data;
    endfunction

endclass


class reference_model;

    function logic [7:0] predict(transaction tx);

        predict = tx.data + tx.address;

    endfunction

endclass


module sv_135_reference_model_tb;

    transaction     tx;
    reference_model ref_model;

    logic [7:0] expected_result;

    initial begin

        ref_model = new();

        // Transaction 1
        tx = new(8'h10, 8'h20);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        // Transaction 2
        tx = new(8'h15, 8'h30);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        // Transaction 3
        tx = new(8'h1A, 8'h40);
        expected_result = ref_model.predict(tx);

        $display("[%0t] Input: address=%h data=%h Expected Result=%h",
                 $time,
                 tx.address,
                 tx.data,
                 expected_result);

        $display("Reference model prediction completed.");

        $finish;

    end

endmodule
```

## Expected Output

```text
[0] Input: address=10 data=20 Expected Result=30
[0] Input: address=15 data=30 Expected Result=45
[0] Input: address=1a data=40 Expected Result=5a
Reference model prediction completed.
```

## Vivado Usage

Add the file as a SystemVerilog simulation source and run `sv_135_reference_model_tb` as the simulation top.

The main reference-model operation is:

```systemverilog
expected_result = ref_model.predict(tx);
```

This calculates the expected DUT result from the transaction.

## Key Takeaway

A **reference model** predicts the correct DUT behavior independently of the DUT implementation.

It provides the **expected result** that can later be compared with the **actual result** by the scoreboard.

