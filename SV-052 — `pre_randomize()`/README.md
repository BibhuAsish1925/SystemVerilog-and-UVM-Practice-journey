# 052 — SV-052 — `pre_randomize()`

`pre_randomize()` is a SystemVerilog **pre-randomization callback**. It is automatically called immediately before an object's `randomize()` operation.

The callback is defined inside the class:

```systemverilog id="pre-randomize-syntax"
function void pre_randomize();
    // Preparation before randomization
endfunction
```

When:

```systemverilog id="randomize-call"
trans.randomize();
```

is executed, the simulator automatically invokes `pre_randomize()` before solving the randomization problem.

### Execution Order

```text
randomize()
    ↓
pre_randomize()
    ↓
constraint solving / randomization
    ↓
random values generated
```

The callback can be used to perform preparation or setup that should happen before randomization.

### Why it matters in verification

Verification environments often need to prepare transaction state before generating random stimulus. `pre_randomize()` provides a standard callback point for such preparation.

### Complete Runnable Code

```systemverilog id="sv052_complete"
module sv_052_pre_randomize;

    class transaction;

        rand int data;

        // Pre-randomization callback
        function void pre_randomize();
            $display("pre_randomize() called");
        endfunction

        function void display();
            $display("Randomized data = %0d", data);
        endfunction

    endclass


    transaction trans;

    initial begin

        trans = new();

        // pre_randomize() is called automatically
        if (trans.randomize())
            trans.display();
        else
            $display("Randomization failed");

    end

endmodule
```

### Expected Output

The random value varies between simulations.

Example:

```text
pre_randomize() called
Randomized data = 184739201
```

**Key concepts:** `pre_randomize()`, pre-randomization callback, automatic callback execution, randomization preparation, transaction setup.