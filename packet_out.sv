class packet_out extends uvm_sequence_item;
    string message;

    `uvm_object_utils_begin(packet_out)
        `uvm_field_string(message, UVM_DEFAULT|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="packet_in");
        super.new(name);
    endfunction: new
endclass: packet_out
