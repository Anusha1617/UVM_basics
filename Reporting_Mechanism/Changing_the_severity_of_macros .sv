//        Changing the severity of macros 
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
    `uvm_error("DRV", "Real Error");
     #10;
     // with ID
    `uvm_fatal("DRV", "Simulation cannot continue DRV1");
    #10;
    `uvm_fatal("DRV1", "Simulation Cannot Continue DRV1");
  endtask
endclass

module tb;
  driver d;
  
  initial begin
    d = new("DRV", null);
   // d.set_report_severity_override(UVM_FATAL, UVM_ERROR);   // total override
    d.set_report_severity_id_override(UVM_FATAL, "DRV", UVM_ERROR);   // severity change by ID 
    d.run();
  end
endmodule

--------------------------------------------------------------------------------------------
UVM_INFO top.sv(20) @ 0: DRV [DRV] Informational Message
# UVM_WARNING top.sv(21) @ 0: DRV [DRV] Potential Error
# UVM_ERROR top.sv(22) @ 0: DRV [DRV] Real Error
# UVM_ERROR top.sv(25) @ 10: DRV [DRV] Simulation cannot continue DRV1
# UVM_FATAL top.sv(27) @ 20: DRV [DRV1] Simulation Cannot Continue DRV1
# 
# --- UVM Report Summary ---
# 
# ** Report counts by severity
# UVM_INFO :    3
# UVM_WARNING :    1
# UVM_ERROR :    2
# UVM_FATAL :    1
# ** Report counts by id
# [DRV]     4
# [DRV1]     1
# [Questa UVM]     2
# ** Note: $finish    : C:/Users/basavaraju/Documents/win64/../verilog_src/uvm-1.1d/src/base/uvm_report_object.svh(292)
#    Time: 20 ns  Iteration: 0  Instance: /tb
----------------------------------------------------------------------------------------------
