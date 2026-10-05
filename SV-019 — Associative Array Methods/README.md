\# 019 — SV-019 — Associative Array Methods



\## Introduction



SystemVerilog provides built-in methods for inspecting, traversing, and modifying associative arrays.



These methods are especially useful because associative-array indexes can be sparse and are not necessarily consecutive.



\## Important Methods



| Method          | Purpose                                               |

| --------------- | ----------------------------------------------------- |

| `first()`       | Returns the first index                               |

| `last()`        | Returns the last index                                |

| `next(index)`   | Returns the next index after the specified index      |

| `prev(index)`   | Returns the previous index before the specified index |

| `exists(index)` | Returns `1` if the index exists, otherwise `0`        |

| `num()`         | Returns the number of stored elements                 |

| `delete(index)` | Deletes the element at the specified index            |



\## `first()` and `last()`



For an associative array:



```systemverilog id="a7r2mc"

data\[10] = 100;

data\[20] = 200;

data\[50] = 500;

data\[80] = 800;

```



```systemverilog id="m3v8kp"

data.first()  // returns 10

data.last()   // returns 80

```



These methods provide the boundary indexes without requiring knowledge of the indexes beforehand.



\## `next()` and `prev()`



`next(index)` finds the next existing index.



For example:



```systemverilog id="n5d9qx"

data.next(20)

```



returns `50`.



Similarly:



```systemverilog id="w8c4sz"

data.prev(50)

```



returns `20`.



These methods can be used to traverse an associative array in index order.



\## `exists()`



`exists(index)` checks whether a particular index is present:



```systemverilog id="p6k1vb"

data.exists(20)  // 1

data.exists(30)  // 0

```



This is useful before accessing an associative-array element when the index may not exist.



\## `num()`



`num()` returns the number of currently stored elements:



```systemverilog id="t2m7hf"

data.num()

```



If four entries are stored, `num()` returns `4`.



\## `delete()`



An individual entry can be removed using:



```systemverilog id="q9x3kd"

data.delete(50);

```



After deletion, index `50` no longer exists.



\## Verification Relevance



Associative-array methods are useful in verification for:



\* Traversing sparse transaction databases.

\* Checking whether transaction IDs exist.

\* Finding the first or last pending transaction.

\* Moving between transaction indexes.

\* Removing processed transactions.

\* Managing scoreboard and reference-model data.



\## Key Takeaways



\* `first()` and `last()` find the boundary indexes.

\* `next()` and `prev()` allow traversal through existing indexes.

\* `exists()` checks whether a specific index is present.

\* `num()` returns the number of stored entries.

\* `delete(index)` removes a specific associative-array entry.

\* `first()` + `next()` is a useful pattern for forward traversal of sparse associative arrays.

\* These methods are important for verification data structures such as scoreboards, transaction tracking, and reference models.



