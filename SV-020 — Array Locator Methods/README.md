\## Phase 02 – 020 – SV-020 – Array Locator Methods



\### Small introduction



SystemVerilog \*\*array locator methods\*\* search an array using a condition. They are useful when verification code needs to find matching data without manually writing a loop.



The four methods covered here are:



\* `find()` — returns all \*\*matching elements\*\*.

\* `find\_index()` — returns the \*\*indexes\*\* of all matching elements.

\* `find\_first()` — returns the \*\*first matching element\*\*.

\* `find\_last()` — returns the \*\*last matching element\*\*.



The `with` clause specifies the search condition.



\### Compact Running Code



\*\*Code type:\*\* SystemVerilog simulation/demo — no DUT.



```systemverilog id="u8k3mp"

module sv\_020\_array\_locator\_methods;



&#x20;   int data\[6] = '{10, 25, 30, 45, 50, 65};



&#x20;   int found\[$];

&#x20;   int indexes\[$];

&#x20;   int first\_value;

&#x20;   int last\_value;



&#x20;   initial begin

&#x20;       $display("Array:");

&#x20;       foreach (data\[i])

&#x20;           $display("data\[%0d] = %0d", i, data\[i]);



&#x20;       // Find all elements greater than or equal to 30

&#x20;       found = data.find(x) with (x >= 30);



&#x20;       $display("\\nfind():");

&#x20;       $display("Matching values = %p", found);



&#x20;       // Find indexes of matching elements

&#x20;       indexes = data.find\_index(x) with (x >= 30);



&#x20;       $display("\\nfind\_index():");

&#x20;       $display("Matching indexes = %p", indexes);



&#x20;       // Find first matching element

&#x20;       first\_value = data.find\_first(x) with (x >= 30);



&#x20;       $display("\\nfind\_first():");

&#x20;       $display("First matching value = %0d", first\_value);



&#x20;       // Find last matching element

&#x20;       last\_value = data.find\_last(x) with (x >= 30);



&#x20;       $display("\\nfind\_last():");

&#x20;       $display("Last matching value = %0d", last\_value);

&#x20;   end



endmodule

```



\### Expected Output



```text id="z0m7pn"

Array:

data\[0] = 10

data\[1] = 25

data\[2] = 30

data\[3] = 45

data\[4] = 50

data\[5] = 65



find():

Matching values = '{30, 45, 50, 65}



find\_index():

Matching indexes = '{2, 3, 4, 5}



find\_first():

First matching value = 30



find\_last():

Last matching value = 65

```



\### Vivado Usage



1\. Add the code as a \*\*Simulation Source\*\*.

2\. Save it as `sv\_020\_array\_locator\_methods.sv`.

3\. Set `sv\_020\_array\_locator\_methods` as the simulation top.

4\. Run \*\*Run Behavioral Simulation\*\*.

5\. Check the Tcl console for the matching values and indexes.



This is a \*\*simulation/demo module\*\*, so no DUT is required.



\### GitHub Markdown Block



\# 020 — SV-020 — Array Locator Methods



\## Introduction



SystemVerilog array locator methods search an array using a specified condition. They provide a concise alternative to manually iterating through an array with a loop.



The main methods covered here are:



| Method         | Purpose                                  |

| -------------- | ---------------------------------------- |

| `find()`       | Returns all matching elements            |

| `find\_index()` | Returns indexes of all matching elements |

| `find\_first()` | Returns the first matching element       |

| `find\_last()`  | Returns the last matching element        |



The search condition is specified using a `with` clause.



\## `find()`



`find()` returns a queue containing \*\*all elements\*\* that satisfy the condition.



```systemverilog id="a6m2qk"

found = data.find(x) with (x >= 30);

```



For:



```text

{10, 25, 30, 45, 50, 65}

```



the result is:



```text

{30, 45, 50, 65}

```



\## `find\_index()`



`find\_index()` returns a queue containing the \*\*indexes\*\* of all matching elements.



```systemverilog id="p8v4nd"

indexes = data.find\_index(x) with (x >= 30);

```



The matching indexes are:



```text

{2, 3, 4, 5}

```



\## `find\_first()`



`find\_first()` returns the \*\*first element\*\* that satisfies the condition.



```systemverilog id="r3k7wx"

first\_value = data.find\_first(x) with (x >= 30);

```



Result:



```text

30

```



\## `find\_last()`



`find\_last()` returns the \*\*last element\*\* that satisfies the condition.



```systemverilog id="m9c2hf"

last\_value = data.find\_last(x) with (x >= 30);

```



Result:



```text

65

```



\## The `with` Clause



The expression inside `with` defines the search condition:



```systemverilog id="q5t8az"

data.find(x) with (x >= 30);

```



Here, `x` represents each array element being examined.



Other conditions can also be used:



```systemverilog id="v1n6bs"

data.find(x) with (x == 50);

data.find(x) with (x < 30);

data.find(x) with ((x % 2) == 0);

```



\## Verification Relevance



Array locator methods are useful in verification for:



\* Searching transaction collections.

\* Finding expected values.

\* Locating matching data.

\* Checking whether specific conditions are satisfied.

\* Quickly identifying the first or last matching transaction.

\* Reducing manual search loops in testbench code.



\## Key Takeaways



\* `find()` returns a queue of \*\*matching values\*\*.

\* `find\_index()` returns a queue of \*\*matching indexes\*\*.

\* `find\_first()` returns the \*\*first matching value\*\*.

\* `find\_last()` returns the \*\*last matching value\*\*.

\* The `with` clause defines the search condition.

\* Array locator methods make verification code more concise when searching transactions, expected data, or other collections.



