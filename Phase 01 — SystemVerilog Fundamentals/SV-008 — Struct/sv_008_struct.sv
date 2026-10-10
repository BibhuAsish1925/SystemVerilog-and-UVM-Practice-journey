module sv_008_struct;

    // Unpacked struct
    typedef struct {
        string name;
        int    age;
    } person_t;

    // Packed struct
    typedef struct packed {
        logic [3:0] opcode;
        logic [7:0] data;
    } packet_t;

    person_t person;
    packet_t packet;

    initial begin
        // Unpacked struct members
        person.name = "Bibhu";
        person.age  = 21;

        $display("Unpacked Struct:");
        $display("name = %s", person.name);
        $display("age  = %0d", person.age);

        // Packed struct members
        packet.opcode = 4'hA;
        packet.data   = 8'h5A;

        $display("\nPacked Struct:");
        $display("opcode = %h", packet.opcode);
        $display("data   = %h", packet.data);
        $display("packet = %h", packet);

        // Packed struct can be treated as one bit vector
        $display("packet[11:8] = %h", packet[11:8]);
        $display("packet[7:0]  = %h", packet[7:0]);
    end

endmodule