/*
    1.Working with quit_count and UVM_ERROR
    2.change the  Associated acctions of Macros by using set_report_severity_action(UVM_INFO,UVM_NO_ACTION);
*/

`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction

  task run();
    `uvm_info("DRV", "Informational Message", UVM_NONE);
    `uvm_warning("DRV", "Potential Error");
    `uvm_error("DRV", "Real Error"); ///uvm_count default present
    `uvm_error("DRV", "Second Real Error");
    
     #10;  // 2. uncommennted here onwards 
    `uvm_fatal("DRV", "Simulation cannot continue DRV1"); /// uvm_exit
    #10;
    `uvm_fatal("DRV1", "Simulation Cannot Continue DRV1");
  // */
  endtask
endclass

module tb;
  driver d;
  initial begin
    d = new("DRV", null);
  //  d.set_report_max_quit_count(2);  // 1 
    d.set_report_severity_action(UVM_FATAL,UVM_NO_ACTION); //2
    d.run();
  end
endmodule
------------------------------------------------------------------------------------------
# UVM_WARNING top.sv(18) @ 0: DRV [DRV] Potential Error
# UVM_ERROR top.sv(19) @ 0: DRV [DRV] Real Error
# UVM_ERROR top.sv(20) @ 0: DRV [DRV] Second Real Error
# 
# --- UVM Report Summary ---
# 
# Quit count reached!
# Quit count :     2 of     2
# ** Report counts by severity
# UVM_INFO :    2
# UVM_WARNING :    1
# UVM_ERROR :    2
# UVM_FATAL :    0
# ** Report counts by id
# [DRV]     3
# [Questa UVM]     2
# ** Note: $finish    : C:/Users/basavaraju/Documents/win64/../verilog_src/uvm-1.1d/src/base/uvm_report_object.svh(292)
#    Time: 0 ns  Iteration: 0  Instance: /tb
---------------------------------------------------------------------------------------------
# --- UVM Report Summary ---
# 
# UVM_INFO top.sv(17) @ 0: DRV [DRV] Informational Message
# UVM_WARNING top.sv(18) @ 0: DRV [DRV] Potential Error
# UVM_ERROR top.sv(19) @ 0: DRV [DRV] Real Error
# UVM_ERROR top.sv(20) @ 0: DRV [DRV] Second Real Error
# [Questa UVM]     2
------------------------------------------------------------------------------------
