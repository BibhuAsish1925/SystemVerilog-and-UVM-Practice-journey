\# 014 — SV-014 — Dynamic Arrays



\## Dynamic Arrays



A \*\*dynamic array\*\* is an array whose size can be determined and changed during simulation.



Unlike a fixed array:



```systemverilog

int data \[5];

```



a dynamic array is declared without a size:



```systemverilog

int data\[];

```



Memory is allocated later using `new\[]`.



Dynamic arrays are useful in verification when the required number of elements is not known at compile time.



\## `new\[]`



The `new\[]` operator allocates memory for a dynamic array.



```systemverilog

data = new\[5];

```



This creates five elements:



```text

data\[0]

data\[1]

data\[2]

data\[3]

data\[4]

```



The current number of elements can be checked using:



```systemverilog

data.size()

```



\## Initialization



After allocating the array, its elements can be assigned normally:



```systemverilog

foreach (data\[i])

&#x20;   data\[i] = (i + 1) \* 10;

```



This produces:



```text

10, 20, 30, 40, 50

```



\## Resize



A dynamic array can be resized using another `new\[]` operation:



```systemverilog

data = new\[8](data);

```



The first argument specifies the new size:



```text

new\[8]

```



The second argument is the existing array:



```text

(data)

```



When resizing this way, the existing elements are copied into the new array up to the available size.



For example:



```text

Before:

10 20 30 40 50



After resizing to 8:

10 20 30 40 50 0 0 0

```



The newly created elements receive their default value.



\## `size()`



The `size()` method returns the current number of elements.



```systemverilog

data.size()

```



For example:



```text

After new\[5]  → 5

After new\[8]  → 8

```



After deleting the array:



```text

data.size() → 0

```



\## `delete()`



The `delete()` method removes all elements from a dynamic array:



```systemverilog

data.delete();

```



After deletion, the dynamic array has zero elements.



This is useful when dynamically allocated testbench data is no longer required.



\## Dynamic Array Operations



| Operation       | Purpose                             |

| --------------- | ----------------------------------- |

| `int data\[];`   | Declare dynamic array               |

| `new\[N]`        | Allocate `N` elements               |

| `new\[N](data)`  | Resize and preserve existing values |

| `data.size()`   | Return current number of elements   |

| `data.delete()` | Delete all elements                 |



\## Why Dynamic Arrays Matter in Verification



Dynamic arrays are useful when testbench data is variable in size, for example:



\* Variable-length packets

\* Test vectors

\* Transaction data

\* Memory models

\* Runtime-generated stimulus

\* Collections whose size is determined during simulation



They provide more flexibility than fixed arrays while still using indexed array access.



\## Key Syntax



\### Declaration



```systemverilog

data\_type array\_name\[];

```



\### Allocation



```systemverilog

array\_name = new\[size];

```



\### Resize



```systemverilog

array\_name = new\[new\_size](array\_name);

```



\### Size



```systemverilog

array\_name.size()

```



\### Delete



```systemverilog

array\_name.delete();

```



The key difference from a fixed array is:



> \*\*A dynamic array has a runtime-defined size that can be changed using `new\[]`.\*\*



