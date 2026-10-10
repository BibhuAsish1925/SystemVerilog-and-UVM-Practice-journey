
# 138 — SV-138 — Coverage Integration

## 1. Concept

Coverage integration connects the **monitor** to a coverage collector.

The monitor observes DUT activity, converts the pin-level activity into transaction information, and passes each transaction to the coverage model.

### Verification Flow

DUT Signals → Monitor → Coverage Collector → Coverage Model

## 2. Important Concepts

### Coverage Collector

The `sv138_coverage` class contains:

- Coverpoints for address
- Coverpoints for data
- Coverpoint for read/write operation
- Cross coverage between address range and write operation

### Coverpoint

A coverpoint records which values or value ranges have been exercised.

Example:

```systemverilog
cp_write:
    coverpoint write {
        bins read  = {0};
        bins write = {1};
    }
````

### Sampling

The monitor sends each observed transaction to the coverage collector:

```systemverilog
cov.sample(tx);
```

The coverage collector copies the transaction fields and calls:

```systemverilog
cg_transaction.sample();
```

This separates **observation** from **coverage measurement**.

### Coverage Flow

```text
Monitor
   |
   | transaction
   v
Coverage Collector
   |
   | sample()
   v
Covergroup
   |
   +-- Address Coverage
   +-- Data Coverage
   +-- Read/Write Coverage
   +-- Cross Coverage
```

## 3. Verification Relevance

Coverage integration helps answer:

* Did the monitor observe the required address ranges?
* Were both read and write operations exercised?
* Were different data ranges exercised?
* Were important combinations of scenarios tested?

This provides measurable information about stimulus completeness.

## 4. Complete Runnable Code

```systemverilog
`timescale 1ns/1ps

interface sv138_dut_if;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;
    logic       valid;

endinterface


class sv138_transaction;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

endclass


class sv138_coverage;

    logic [7:0] address;
    logic [7:0] data;
    logic       write;

    covergroup cg_transaction;

        cp_address:
            coverpoint address {
                bins low_address  = {[8'h10:8'h14]};
                bins high_address = {[8'h15:8'h1F]};
            }

        cp_data:
            coverpoint data {
                bins low_data  = {[8'h20:8'h27]};
                bins high_data = {[8'h28:8'h2F]};
            }

        cp_write:
            coverpoint write {
                bins read  = {0};
                bins write = {1};
            }

        address_write:
            cross cp_address, cp_write;

    endgroup


    function new();

        cg_transaction = new();

    endfunction


    function void sample(sv138_transaction tx);

        address = tx.address;
        data    = tx.data;
        write   = tx.write;

        cg_transaction.sample();

    endfunction


    function void report();

        $display("Coverage = %0.2f%%",
                 cg_transaction.get_coverage());

    endfunction

endclass


class sv138_monitor;

    virtual sv138_dut_if vif;
    sv138_coverage cov;

    function new(
        virtual sv138_dut_if vif,
        sv138_coverage cov
    );

        this.vif = vif;
        this.cov = cov;

    endfunction


    task run(input int count);

        sv138_transaction tx;

        repeat (count) begin

            wait (vif.valid == 1'b1);

            tx = new();

            tx.address = vif.address;
            tx.data    = vif.data;
            tx.write   = vif.write;

            $display("[%0t] Monitor: address=%h data=%h write=%b",
                     $time,
                     tx.address,
                     tx.data,
                     tx.write);

            cov.sample(tx);

            wait (vif.valid == 1'b0);

        end

    endtask

endclass


module sv_138_coverage_integration_tb;

    sv138_dut_if vif();

    sv138_coverage cov;
    sv138_monitor  mon;

    initial begin

        vif.address = 8'h00;
        vif.data    = 8'h00;
        vif.write   = 1'b0;
        vif.valid   = 1'b0;

        cov = new();
        mon = new(vif, cov);

        fork

            mon.run(5);

            begin

                #10;
                vif.address = 8'h10;
                vif.data    = 8'h20;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h14;
                vif.data    = 8'h27;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h15;
                vif.data    = 8'h28;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h1F;
                vif.data    = 8'h2F;
                vif.write   = 1'b0;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

                #10;
                vif.address = 8'h12;
                vif.data    = 8'h2A;
                vif.write   = 1'b1;
                vif.valid   = 1'b1;

                #10;
                vif.valid = 1'b0;

            end

        join

        cov.report();

        $display("Coverage integration completed.");

        $finish;

    end

endmodule
```

## Expected Output

The exact coverage percentage is simulator-dependent, but the monitor should observe five transactions similar to:

```text
[10000] Monitor: address=10 data=20 write=1
[30000] Monitor: address=14 data=27 write=0
[50000] Monitor: address=15 data=28 write=1
[70000] Monitor: address=1f data=2f write=0
[90000] Monitor: address=12 data=2a write=1
Coverage = ...
Coverage integration completed.
```

The important point is that **every transaction observed by the monitor is passed to `cov.sample()`**.

---

## Vivado Usage

1. Create a SystemVerilog source file:

   ```text
   sv_138_coverage_integration.sv
   ```

2. Add it to the Vivado simulation sources.

3. Make:

   ```text
   sv_138_coverage_integration_tb
   ```

   the simulation top module.

4. Run:

   ```text
   launch_simulation
   ```

5. Run:

   ```text
   run 1000ns
   ```

6. Check the Tcl console for:

   * Monitor transactions.
   * Coverage percentage.
   * Completion message.

**Important:** keep the file as `.sv`, not `.v`, because this example uses SystemVerilog classes and covergroups.

