class comparator #(type T = packet_in) extends uvm_scoreboard;
   typedef comparator #(T) this_type;
   `uvm_component_utils(this_type)
    
    uvm_tlm_fifo #(T) from_refmod;
    uvm_tlm_fifo#(T) from_refmod_low;    
    uvm_tlm_fifo#(T) from_refmod_oct;
    
     T tr1, tr2, tr3;
     int match, mismatch;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      from_refmod = new("from_refmod", null, 1); 
      from_refmod_low = new("from_refmod_low", null, 1);
      from_refmod_oct = new("from_refmod_oct", null, 1);
      tr1 = new("tr1");
      tr2 = new("tr2");
      tr3 = new("tr3");
    endfunction
 
    function void connect_phase(uvm_phase phase);
        uvmc_tlm1 #(T)::connect(from_refmod.put_export, "refmod_i.out");
        uvmc_tlm1#(T)::connect(from_refmod_low.put_export, "refmod_low_i.out");
        uvmc_tlm1#(T)::connect(from_refmod_oct.put_export, "refmod_oct_i.out");
    endfunction: connect_phase
   
    task run_phase(uvm_phase phase);
      forever begin
        from_refmod.get(tr1);
        from_refmod_low.get(tr2);
        from_refmod_oct.get(tr3);
        compare();
      end
    endtask: run_phase

    virtual function void compare();
      if(tr1.message == tr2.message && tr1.message == tr3.message) begin
        $display("Comparator MATCH with 2 refmods (refmod == refmod_low == refmod_oct)");
        match++;
      end
      else if(tr1.message == tr2.message) begin
        $display("Comparator MATCH with refmod_low (refmod == refmod_low)");
        match++;
      end
      else if(tr1.message == tr3.message) begin
        $display("Comparator MATCH with refmod_oct (refmod == refmod_oct)");
        match++;
      end
      else begin
        $display("Comparator MISMATCH");
        mismatch++;
      end
    endfunction: compare
   
endclass: comparator
