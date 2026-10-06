# 037 — SV-037 — Encapsulation

**Encapsulation** is the mechanism used to control access to class members.

SystemVerilog provides three important visibility levels:

* `public`
* `protected`
* `local`

## 1. Public

A public member can be accessed from outside the class.

```systemverilog id="n7c2qx"
int public_data;
```

Public is also the default visibility for class members.

Example:

```systemverilog id="q3m8kf"
trans.public_data = 100;
```

## 2. Protected

A protected member can be accessed inside the class and from classes derived from it.

```systemverilog id="v6h1zp"
protected int protected_data;
```

A child class can access it:

```systemverilog id="a2r9ws"
class extended_transaction extends transaction;

    function void display_protected();
        $display("%0d", protected_data);
    endfunction

endclass
```

However, protected data is not directly accessible through the object from outside the class hierarchy.

## 3. Local

A local member can only be accessed within the class where it is declared.

```systemverilog id="m5x8qd"
local int local_data;
```

Neither external code nor a derived class can directly access it.

The declaring class can still expose its value through a method.


### Access Summary

| Visibility  | Same Class | Child Class | Outside Class |
| ----------- | ---------: | ----------: | ------------: |
| `public`    |          ✓ |           ✓ |             ✓ |
| `protected` |          ✓ |           ✓ |             ✗ |
| `local`     |          ✓ |           ✗ |             ✗ |

Encapsulation becomes useful in verification when class internals should be protected while controlled methods provide access to the required functionality.
