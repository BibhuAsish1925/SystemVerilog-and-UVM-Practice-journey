# 028 — SV-028 — Lifetime

**Lifetime** determines how long a variable's storage exists and how its value behaves across procedure calls.

SystemVerilog supports **static** and **automatic** lifetimes.

## 1. Static Lifetime

A variable with static lifetime has one storage location that persists throughout the simulation.

```systemverilog id="q3m7xa"
function int static_count();
    static int count = 0;
    count++;
    return count;
endfunction
```

Each call uses the same `count` variable:

```text
Call 1 → 1
Call 2 → 2
Call 3 → 3
```

The value is preserved between calls.

## 2. Automatic Lifetime

An automatic procedure creates a new storage instance for each activation.

```systemverilog id="c8k4vp"
function automatic int automatic_count();
    int count = 0;
    count++;
    return count;
endfunction
```

Each call gets a new `count`, initialized to `0`:

```text
Call 1 → 1
Call 2 → 1
Call 3 → 1
```

Automatic lifetime is particularly useful when multiple procedure calls need independent local variables.

## Static vs Automatic

| Lifetime | Storage | Value between calls |
|---|---|---|
| Static | One shared instance | Preserved |
| Automatic | New instance per activation | Not preserved |

Tasks and functions can use automatic lifetime, which is especially useful for reusable verification procedures and concurrent operations.

## Verification Relevance

Lifetime becomes important when writing:

- Reusable tasks and functions
- Concurrent testbench operations
- Recursive procedures
- Independent procedure calls
- Verification utility code

Using automatic lifetime helps prevent different procedure activations from unintentionally sharing local variables.

## Complete Runnable Code

```systemverilog id="f2q8mz"
module sv_028_lifetime;

    // Static lifetime: one variable is shared by all calls
    function int static_count();
        static int count = 0;
        count++;
        return count;
    endfunction

    // Automatic lifetime: new variable for every call
    function automatic int automatic_count();
        int count = 0;
        count++;
        return count;
    endfunction

    initial begin
        $display("Static lifetime:");
        $display("Call 1 = %0d", static_count());
        $display("Call 2 = %0d", static_count());
        $display("Call 3 = %0d", static_count());

        $display("\nAutomatic lifetime:");
        $display("Call 1 = %0d", automatic_count());
        $display("Call 2 = %0d", automatic_count());
        $display("Call 3 = %0d", automatic_count());
    end

endmodule
```