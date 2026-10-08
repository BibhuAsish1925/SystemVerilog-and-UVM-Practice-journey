
# 127 — SV-127 — Transaction Randomization

## 1. Small Introduction

Transaction randomization allows a transaction object to generate different legal stimulus automatically.

Two important concepts are:

- **`rand` fields** — fields whose values can be randomized by `randomize()`.
- **Constraints** — rules that restrict the legal randomized values.

Instead of manually assigning every transaction:

```systemverilog
tx.data = 8'hA5;
````

we can use:

```systemverilog
assert(tx.randomize());
```

and let SystemVerilog generate a value satisfying the constraints.

## 2. Important Syntax

### `rand` Field

```systemverilog
rand logic [7:0] data;
```

The field becomes eligible for randomization.

### Constraint

```systemverilog
constraint data_range {
    data inside {[8'h20:8'hEF]};
}
```

The constraint restricts the legal randomized values.

### Randomization

```systemverilog
assert(tx.randomize());
```

This attempts to assign legal random values to the `rand` fields.

Checking the return value is important because `randomize()` can fail if the constraints cannot be satisfied.

## 3. Verification Relevance

Randomized transactions allow a verification environment to generate many different legal stimulus combinations without manually specifying every value.

```text
Transaction
     |
     +-- rand address
     +-- rand data
     +-- rand write
             |
             ↓
       randomize()
             |
             ↓
       constrained
       transaction
```

This becomes especially important when building generators and constrained-random verification environments.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

// ============================================================
// Transaction class
// ============================================================

class transaction;

    // Randomizable transaction fields
    rand logic [7:0] address;
    rand logic [7:0] data;
    rand logic       write;

    // Address and data constraints
    constraint address_range {
        address inside {[8'h10:8'h1F]};
    }

    constraint data_range {
        data inside {[8'h20:8'hEF]};
    }

    // Write operation must be 0 or 1
    constraint write_value {
        write inside {0, 1};
    }

    // Display transaction
    function void display();
        $display("[%0t] address=%h data=%h write=%b",
                 $time, address, data, write);
    endfunction

endclass


// ============================================================
// Testbench
// ============================================================

module sv_127_transaction_randomization_tb;

    transaction tx;

    initial begin

        tx = new();

        repeat (5) begin

            if (!tx.randomize())
                $fatal(1, "Transaction randomization failed");

            tx.display();

        end

        $finish;

    end

endmodule
```

## 5. Expected Behavior

The exact randomized values vary between simulations.

A possible output is:

```text
[0] address=1a data=73 write=1
[0] address=11 data=c4 write=0
[0] address=1f data=52 write=1
[0] address=16 data=ae write=0
[0] address=1b data=38 write=1
$finish called at time : 0 ns
```

Every generated transaction must satisfy:

```text
address : 10–1F
data    : 20–EF
write   : 0 or 1
```

The exact randomized values are not fixed.

## 6. Key Takeaway

```text
rand field
    ↓
randomize()
    ↓
constraints applied
    ↓
legal randomized transaction
```

`rand` identifies fields that can be randomized, while constraints define the legal values those fields may take.
