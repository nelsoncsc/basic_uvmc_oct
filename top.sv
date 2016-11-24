import uvm_pkg::*;
import uvmc_pkg::*;

`include "uvm_macros.svh"
`include "packet_in.sv"
`include "packet_out.sv"
`include "sequence_in.sv"
`include "sequencer.sv"
`include "path_tr.sv"
`include "env.sv"
`include "test.sv"

//Top
module top;
  
  initial begin
    `ifdef INCA
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    run_test("test");
  end
endmodule
