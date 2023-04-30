//    setting the verbosity level for ID at run time  

`include "uvm_macros.svh"
import uvm_pkg::*;
 
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string name , uvm_component parent);
    super.new(name, parent);
  endfunction
  
  task run();
    `uvm_info("DRV1", "Executed Driver1 Code", UVM_HIGH);
    `uvm_info("DRV2", "Executed Driver2 Code", UVM_HIGH);
  endtask
  
endclass
 
 
module tb;
 driver drv;
 initial 
 begin
   drv = new("DRV", null);
   drv.set_report_id_verbosity("DRV1",UVM_HIGH);
   drv.run();
    // run manually added 
    // we have run_test() for automation
  end
  
endmodule
-----------------------------------------------------------
# UVM_INFO top.sv(19) @ 0: DRV [DRV1] Executed Driver1 Code
------------------------------------------------------------
