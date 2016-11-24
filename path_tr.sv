class path_tr extends uvm_driver #(packet_in);
    packet_in tr;
   
    `uvm_component_utils(path_tr)
    uvm_analysis_port #(packet_in) item_collected_port;
    
   function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
      forever begin
        seq_item_port.get_next_item(tr);
        begin_tr(tr, "path_tr");
          item_collected_port.write(tr);
        end_tr(tr);
        seq_item_port.item_done();
      end
    endtask
endclass: path_tr
