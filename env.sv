`include "comparator.sv"
 
class env extends uvm_env;
    sequencer sqr;
    path_tr path;
    comparator #(packet_out) comp;

    uvm_tlm_analysis_fifo #(packet_in) to_refmod;
    uvm_tlm_analysis_fifo #(packet_in) to_refmod_low;
    uvm_tlm_analysis_fifo #(packet_in) to_refmod_oct;

    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);       
        to_refmod = new("to_refmod", this);
        to_refmod_low = new("to_refmod_low", this);
        to_refmod_oct = new("to_refmod_oct", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = sequencer::type_id::create("sqr", this);
        path = path_tr::type_id::create("path", this);
        comp = comparator #(packet_out)::type_id::create("comp", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        path.seq_item_port.connect(sqr.seq_item_export);
        path.item_collected_port.connect(to_refmod.analysis_export);
        uvmc_tlm1 #(packet_in)::connect(to_refmod.get_export, "refmod_i.in");

        path.item_collected_port.connect(to_refmod_low.analysis_export);
        uvmc_tlm1 #(packet_in)::connect(to_refmod_low.get_export, "refmod_low_i.in");
        
        path.item_collected_port.connect(to_refmod_oct.analysis_export);
        uvmc_tlm1 #(packet_in)::connect(to_refmod_oct.get_export, "refmod_oct_i.in");
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
  
endclass
