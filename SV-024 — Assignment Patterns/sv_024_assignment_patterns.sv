module sv_024_assignment_patterns;

    typedef struct {
        string name;
        int age;
    } person_t;

    int data[4];
    int matrix[2][3];
    person_t person;

    initial begin

        // Simple array assignment pattern
        data = '{10, 20, 30, 40};

        $display("Simple Assignment Pattern:");
        $display("data = %p", data);

        // Nested assignment pattern for 2D array
        matrix = '{'{1, 2, 3}, '{4, 5, 6}};

        $display("\nNested Assignment Pattern:");
        $display("matrix = %p", matrix);

        // Assignment pattern for a structure
        person = '{"Bibhu", 21};

        $display("\nStruct Assignment Pattern:");
        $display("name = %s", person.name);
        $display("age  = %0d", person.age);

    end

endmodule