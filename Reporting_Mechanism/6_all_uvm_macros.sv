//  Working with different Macros like `uvm_warning , `uvm_error , `uvm_fatal  , `uvm_info

`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction

  task run();
    `uvm_info("DRV", "Informational Message", UVM_NONE);
    /* It won't end the simulation for the `uvm_warning and `uvm_error
    But `uvm_fatal will call the $finish at that instant  
    different colors */
    `uvm_warning("DRV", "Potential Error");
    `uvm_error("DRV", "Real Error");
     #10;
    `uvm_fatal("DRV", "Simulation cannot continue");
  endtask
endclass
 
module tb;
  driver d;
  initial begin
    d = new("DRV", null);
    d.run();
  end
endmodule

-------------------------------------------------------------------------------------------
UVM_INFO top.sv(14) @ 0: DRV [DRV] Informational Message
# UVM_WARNING top.sv(18) @ 0: DRV [DRV] Potential Error
# UVM_ERROR top.sv(19) @ 0: DRV [DRV] Real Error
# UVM_FATAL top.sv(21) @ 10: DRV [DRV] Simulation cannot continue
# 
# --- UVM Report Summary ---
# 
# ** Report counts by severity
# UVM_INFO :    3
# UVM_WARNING :    1
# UVM_ERROR :    1
# UVM_FATAL :    1
# ** Report counts by id
# [DRV]     4
# [Questa UVM]     2
# ** Note: $finish    : C:/Users/basavaraju/Documents/win64/../verilog_src/uvm-1.1d/src/base/uvm_report_object.svh(292)
#    Time: 10 ns  Iteration: 0  Instance: /tb
---------------------------------------------------------------------------------------------
