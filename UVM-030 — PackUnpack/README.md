# 179 — UVM-030 — Pack/Unpack&#x20;

## 1. Introduction

UVM packing converts transaction fields into a bit stream. Unpacking restores the fields from that stream.

- `pack()` packs registered or custom-defined fields.
- `unpack()` restores the fields from the packed stream.
- `do_pack()` defines custom packing behavior.
- `do_unpack()` defines custom unpacking behavior.

## 2. Complete Runnable Code

```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_030_transaction extends uvm_sequence_item;
    `uvm_object_utils(uvm_030_transaction)

    bit [7:0] addr;
    bit [7:0] data;
    bit write;

    function new(string name = "uvm_030_transaction");
        super.new(name);
    endfunction

    virtual function void do_pack(uvm_packer packer);
        super.do_pack(packer);
        packer.pack_field_int(addr, 8);
        packer.pack_field_int(data, 8);
        packer.pack_field_int(write, 1);
    endfunction

    virtual function void do_unpack(uvm_packer packer);
        super.do_unpack(packer);
        addr  = packer.unpack_field_int(8);
        data  = packer.unpack_field_int(8);
        write = packer.unpack_field_int(1);
    endfunction
endclass

class uvm_030_test extends uvm_test;
    `uvm_component_utils(uvm_030_test)

    uvm_030_transaction tx1;
    uvm_030_transaction tx2;
    bit bits_stream[];

    function new(string name = "uvm_030_test",
                 uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        int bit_count;

        super.build_phase(phase);

        tx1 = uvm_030_transaction::type_id::create("tx1");
        tx2 = uvm_030_transaction::type_id::create("tx2");

        tx1.addr = 8'h12;
        tx1.data = 8'hA5;
        tx1.write = 1'b1;

        bit_count = tx1.pack(bits_stream);

        `uvm_info("PACK",
            $sformatf("Packed bit count = %0d", bit_count),
            UVM_LOW)

        tx2.unpack(bits_stream);

        `uvm_info("UNPACK",
            $sformatf("addr=0x%02h data=0x%02h write=%0b",
                      tx2.addr, tx2.data, tx2.write),
            UVM_LOW)

        if (tx1.compare(tx2))
            `uvm_info("RESULT", "PASS: transactions match", UVM_LOW)
        else
            `uvm_error("RESULT", "FAIL: transactions differ")
    endfunction
endclass

module uvm_030_pack_unpack_tb;
    initial
        run_test("uvm_030_test");
endmodule
```

## 3. Expected Output

```
UVM_INFO ... [PACK] Packed bit count = 17
UVM_INFO ... [UNPACK] addr=0x12 data=0xa5 write=1
UVM_INFO ... [RESULT] PASS: transactions match
```

## 4. Vivado Usage

1. Create `uvm_030_pack_unpack.sv` under Simulation Sources.
2. Set `uvm_030_pack_unpack_tb` as the simulation top.
3. Run Behavioral Simulation.
4. Enter `run 1000ns` in the Tcl Console.
5. Verify the 17-bit count, restored field values, and PASS message.

## 5. Key Takeaways

- Packing serializes transaction fields into a bit stream.
- Unpacking restores fields from a corresponding stream.
- `do_pack()` and `do_unpack()` must use matching field order and widths.
- Packing is useful when transactions must be represented as compact bit streams.
