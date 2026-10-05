# 008 — SV-008 — Struct

## Struct

A `struct` groups multiple related variables into one data object. Instead of keeping several independent variables, related information can be represented as members of a single structure.

SystemVerilog supports both **unpacked structs** and **packed structs**.

### 1. Unpacked Struct

An unpacked struct stores its members as separate objects. The members can have different data types and sizes.

```systemverilog
typedef struct {
    string name;
    int    age;
} person_t;
```

Access members using the dot operator:

```systemverilog
person.name = "Bibhu";
person.age  = 21;
```

### 2. Packed Struct

A packed struct combines all members into one contiguous packed bit representation.

```systemverilog
typedef struct packed {
    logic [3:0] opcode;
    logic [7:0] data;
} packet_t;
```

Here:

* `opcode` = 4 bits
* `data` = 8 bits
* Total packed width = 12 bits

Therefore, the complete struct can be displayed or accessed like a vector:

```systemverilog
packet = 12'hA5A;
packet[11:8]
packet[7:0]
```

### Why Structs Matter in Verification

Structs are useful for grouping related information such as:

* Transaction fields
* Packet information
* Configuration values
* Control/status information
* Protocol data

Packed structs are especially useful when the grouped fields need to represent a hardware bit-level format.

## Key Syntax

```systemverilog
typedef struct {
    type member1;
    type member2;
} struct_name;
```

Unpacked struct:

```systemverilog
typedef struct {
    string name;
    int age;
} person_t;
```

Packed struct:

```systemverilog
typedef struct packed {
    logic [3:0] opcode;
    logic [7:0] data;
} packet_t;
```

Member access:

```systemverilog
person.name
person.age

packet.opcode
packet.data
```

The main difference is that a **packed struct has one contiguous packed bit representation**, while an **unpacked struct does not form one packed vector**.

Structs become particularly useful later in SystemVerilog verification when building transaction and packet-like data objects.
