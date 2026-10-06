# 053 — SV-053 — `post_randomize()`

`post_randomize()` is a SystemVerilog **post-randomization callback**. It is automatically called after an object's `randomize()` operation successfully generates the random values.

The callback is defined inside the class:

```systemverilog
function void post_randomize();
    // Actions after randomization
endfunction
```

### Execution Order

The basic randomization callback flow is:

```text
randomize()
    ↓
pre_randomize()
    ↓
constraint solving / randomization
    ↓
random values generated
    ↓
post_randomize()
```

`post_randomize()` therefore has access to the newly generated random values.

### Common Use

It can be used to:

* Calculate derived values
* Update dependent non-random properties
* Perform post-randomization processing
* Display or log generated transaction information

For example:

```systemverilog
function void post_randomize();
    double_data = data * 2;
endfunction
```

Here, `double_data` is calculated after `data` has been randomized.


**Key concepts:** `post_randomize()`, post-randomization callback, derived values, automatic callback execution, randomized transaction processing.
