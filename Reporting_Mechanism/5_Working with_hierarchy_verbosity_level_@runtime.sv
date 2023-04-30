//Working with hierarchy verbosity level

`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("DRV", "Executed Driver Code", UVM_HIGH);
  endtask
  
endclass
 
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("MON", "Executed Monitor Code", UVM_HIGH);
  endtask
  
endclass
 
 
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction

  task run();
    drv = new("DRV", this);
    mon = new("MON", this);
   // drv.set_report_verbosity_level_hier(UVM_HIGH);
  endtask
  
endclass

module tb;
 env e;
 initial begin
   e  = new("ENV", null);
   // set hierarchy verbosity level 
   e.run(); 
   e.mon.set_report_verbosity_level_hier(UVM_HIGH);
   e.drv.run();
   e.mon.run();
  end
endmodule

---------------------------------------------------------------
# UVM_INFO top.sv(33) @ 0: ENV.MON [MON] Executed Monitor Code
---------------------------------------------------------------
