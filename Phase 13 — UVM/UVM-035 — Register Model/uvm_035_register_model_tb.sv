
`include "uvm_macros.svh"
import uvm_pkg::*;

// One 8-bit hardware register
class uvm_035_control_reg extends uvm_reg;
    `uvm_object_utils(uvm_035_control_reg)

    uvm_reg_field control;

    function new(string name = "uvm_035_control_reg");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        control = uvm_reg_field::type_id::create("control");
        control.configure(this, 8, 0, "RW", 0, 0, 1, 1, 0);
    endfunction
endclass

// Register block contains the register and its address map
class uvm_035_reg_block extends uvm_reg_block;
    `uvm_object_utils(uvm_035_reg_block)

    uvm_035_control_reg control_reg;
    uvm_reg_map default_map;

    function new(string name = "uvm_035_reg_block");
        super.new(name, UVM_NO_COVERAGE);
    endfunction

    virtual function void build();
        default_map = create_map(
            "default_map", 0, 1, UVM_LITTLE_ENDIAN
        );

        control_reg = uvm_035_control_reg::type_id::create(
            "control_reg"
        );
        control_reg.configure(this, null, "");
        control_reg.build();

        default_map.add_reg(control_reg, 'h00, "RW");
        lock_model();
    endfunction
endclass

// Test demonstrates register abstraction
class uvm_035_test extends uvm_test;
    `uvm_component_utils(uvm_035_test)

    uvm_035_reg_block reg_model;
    uvm_reg_data_t value;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        reg_model = uvm_035_reg_block::type_id::create("reg_model");
        reg_model.build();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        // Set the desired register value
        reg_model.control_reg.set(8'hA5);
        value = reg_model.control_reg.get();

        `uvm_info("RAL",
            $sformatf("Register desired value = 0x%02h", value),
            UVM_MEDIUM)

        // Predict the value to update the model's mirror
        reg_model.control_reg.predict(8'hA5);
        value = reg_model.control_reg.get_mirrored_value();

        `uvm_info("RAL",
            $sformatf("Register mirrored value = 0x%02h", value),
            UVM_MEDIUM)

        `uvm_info("RAL",
            "Register model demonstration completed", UVM_MEDIUM)

        phase.drop_objection(this);
    endtask
endclass

module uvm_035_register_model_tb;
    initial run_test("uvm_035_test");
endmodule
