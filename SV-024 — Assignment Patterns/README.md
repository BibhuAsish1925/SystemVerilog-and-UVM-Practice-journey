\# SV-024 — Assignment Patterns



Assignment patterns use `'{ }` to assign values to aggregate data types such as arrays and structures.



They provide a compact way to initialize multiple elements at once.



\## 1. Simple Assignment Pattern



```systemverilog

int data\[4];



data = '{10, 20, 30, 40};

```



The values are assigned sequentially to the array elements.



\## 2. Nested Assignment Patterns



For multidimensional arrays, assignment patterns can be nested:



```systemverilog

int matrix\[2]\[3];



matrix = '{'{1, 2, 3}, '{4, 5, 6}};

```



The outer pattern represents the first dimension, while each inner pattern represents one row.



\## 3. Struct Assignment Pattern



Assignment patterns can also assign values to structure members:



```systemverilog

typedef struct {

&#x20;   string name;

&#x20;   int age;

} person\_t;



person\_t person;



person = '{"Bibhu", 21};

```



The values are assigned according to the structure member order.



\## Verification Relevance



Assignment patterns are useful in verification for quickly creating:



\* Test data arrays

\* Multidimensional test vectors

\* Transaction fields

\* Structure-based configuration data

\* Initial values for stimulus





