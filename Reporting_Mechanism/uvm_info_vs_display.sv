//-----------MACRO `uvm_info---------------------------//


`include "uvm_macros.svh" ///`uvm_info
import uvm_pkg::*;   // imports all  uvm base classes 
 
module tb; 
  initial begin
    #50;
    //-----------`uvm_info(ID,MSG,VERBOSITY)--------------------------//
    `uvm_info("TB_TOP","Hello World", UVM_LOW);
    
    // tells about 
    /*
    1. File name
    2. Line number 
    3. Time 
    4. module or class name
    5. Message 
    */ 
    
     $display("Hello World with Display");
  end
  
  
  
endmodule



 
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(277) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(278) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO 3.sv(17) @ 50: reporter [TB_TOP] Hello World
# Hello World with Display
# exit
# Saving coverage database on exit...
# End time: 09:43:45 on Feb 07,2023, Elapsed time: 0:00:04
# Errors: 0, Warnings: 2
#+uvm_set_action=uvm_top,_ALL_,UVM_FATAL,UVM_NO_ACTION 
