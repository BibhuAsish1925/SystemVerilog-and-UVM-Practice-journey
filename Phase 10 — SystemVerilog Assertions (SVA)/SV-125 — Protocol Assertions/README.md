
# 125 — SV-125 — Protocol Assertions

## 1. Small Introduction

Protocol assertions check whether signals follow the rules of a communication protocol.

Three common examples are:

- **Valid/Ready** — a transfer occurs when `valid && ready` are both high.
- **Handshake** — once a request is accepted, the corresponding response should occur according to the protocol.
- **FIFO properties** — checks conditions such as no read when empty and no write when full.

These checks can be expressed naturally using SVA.

## 2. Important Protocol Properties

### Valid/Ready

```systemverilog
assert property (@(posedge clk)
                  valid |-> ready);
````

This checks that whenever `valid` is asserted, `ready` is also high on the same sampled clock edge.

### Handshake

```systemverilog
assert property (@(posedge clk)
                  req |=> ack);
```

`|=>` means the acknowledgement must occur on the next clock cycle.

### FIFO Safety

Do not write when the FIFO is full:

```systemverilog
assert property (@(posedge clk)
                  fifo_full |-> !fifo_write);
```

Do not read when the FIFO is empty:

```systemverilog
assert property (@(posedge clk)
                  fifo_empty |-> !fifo_read);
```

## 3. Verification Relevance

Protocol assertions are useful because they continuously check interface behavior during simulation or formal verification.

```text
VALID / READY
    ↓
Transfer protocol

REQUEST / ACK
    ↓
Handshake protocol

FULL / EMPTY
    ↓
FIFO safety
```

They help detect illegal protocol behavior close to the point where it occurs.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

module sv_125_protocol_assertions_tb;

    logic clk;
    logic reset;

    logic valid;
    logic ready;

    logic req;
    logic ack;

    logic fifo_write;
    logic fifo_read;
    logic fifo_full;
    logic fifo_empty;

    // ============================================================
    // VALID / READY
    // ============================================================

    ap_valid_ready:
        assert property (@(posedge clk)
                          disable iff (reset)
                          valid |-> ready)
        else $error("[%0t] VALID/READY failed: ready=0 while valid=1",
                    $time);

    // ============================================================
    // HANDSHAKE
    // ============================================================

    ap_request_ack:
        assert property (@(posedge clk)
                          disable iff (reset)
                          req |=> ack)
        else $error("[%0t] HANDSHAKE failed: ack missing after request",
                    $time);

    // ============================================================
    // FIFO PROPERTIES
    // ============================================================

    ap_no_write_when_full:
        assert property (@(posedge clk)
                          disable iff (reset)
                          fifo_full |-> !fifo_write)
        else $error("[%0t] FIFO failed: write attempted while full",
                    $time);

    ap_no_read_when_empty:
        assert property (@(posedge clk)
                          disable iff (reset)
                          fifo_empty |-> !fifo_read)
        else $error("[%0t] FIFO failed: read attempted while empty",
                    $time);

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        valid = 1'b0;
        ready = 1'b0;

        req = 1'b0;
        ack = 1'b0;

        fifo_write = 1'b0;
        fifo_read  = 1'b0;
        fifo_full  = 1'b0;
        fifo_empty = 1'b1;

        // Reset

        @(negedge clk);
        reset = 1'b1;

        // VALID / READY PASS

        @(negedge clk);
        reset = 1'b0;

        valid = 1'b1;
        ready = 1'b1;

        @(negedge clk);
        valid = 1'b0;
        ready = 1'b0;

        // HANDSHAKE PASS

        @(negedge clk);
        req = 1'b1;
        ack = 1'b0;

        @(negedge clk);
        req = 1'b0;
        ack = 1'b1;

        @(negedge clk);
        ack = 1'b0;

        // FIFO PASS

        @(negedge clk);
        fifo_empty = 1'b0;
        fifo_read  = 1'b1;

        @(negedge clk);
        fifo_read = 1'b0;

        fifo_full  = 1'b1;
        fifo_write = 1'b0;

        @(negedge clk);

        // Intentional VALID/READY failure

        valid = 1'b1;
        ready = 1'b0;

        @(negedge clk);
        valid = 1'b0;

        // Intentional HANDSHAKE failure

        req = 1'b1;
        ack = 1'b0;

        @(negedge clk);
        req = 1'b0;

        // Intentional FIFO write-while-full failure

        fifo_full  = 1'b1;
        fifo_write = 1'b1;

        @(negedge clk);
        fifo_write = 1'b0;

        // Intentional FIFO read-while-empty failure

        fifo_full  = 1'b0;
        fifo_empty = 1'b1;
        fifo_read  = 1'b1;

        @(negedge clk);
        fifo_read = 1'b0;

        #5;
        $finish;

    end

    always #5 clk = ~clk;

endmodule
```

## 5. Expected Behavior

The first protocol examples should pass.

The intentional violations should generate assertion errors similar to:

```text
VALID/READY failed: ready=0 while valid=1
HANDSHAKE failed: ack missing after request
FIFO failed: write attempted while full
FIFO failed: read attempted while empty
```

The exact timestamps and simulator diagnostic formatting may vary.

## 6. Key Takeaway

```text
Valid/Ready
valid |-> ready

Handshake
req |=> ack

FIFO safety
fifo_full  |-> !fifo_write
fifo_empty |-> !fifo_read
```

Protocol assertions continuously check whether an interface follows its expected communication and safety rules.

