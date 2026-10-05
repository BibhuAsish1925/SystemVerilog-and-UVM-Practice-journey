# SV-027 — Function/Task Arguments

SystemVerilog provides different argument modes for functions and tasks. The main modes are `input`, `output`, `inout`, and `ref`.

## 1. `input`

`input` passes a value into the function or task.

```systemverilog
task automatic show_input(input int value);
    $display("value = %0d", value);
endtask
```

The procedure can read the value but does not use it to modify the caller's variable.

## 2. `output`

`output` is used to return a value from a function or task.

```systemverilog
task automatic calculate_sum(
    input int a,
    input int b,
    output int result
);
    result = a + b;
endtask
```

The caller receives the value assigned to `result`.

## 3. `inout`

`inout` allows the procedure to read and modify the argument.

```systemverilog
task automatic increment_inout(inout int value);
    value = value + 1;
endtask
```

After the task completes, the caller sees the modified value.

## 4. `ref`

`ref` passes a reference to the original variable.

```systemverilog
task automatic increment_ref(ref int value);
    value = value + 10;
endtask
```

The task directly operates on the caller's variable.

## Verification Relevance

Argument modes are important when creating reusable verification components and procedures.

They are commonly used to:

* Pass stimulus into tasks
* Return calculated or checked results
* Modify testbench data
* Operate directly on transaction objects or variables
* Build reusable verification utilities


