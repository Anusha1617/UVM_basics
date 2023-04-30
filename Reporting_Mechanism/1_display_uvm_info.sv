`include "uvm_macros.svh" ///`uvm_info
import uvm_pkg::*;
 // imports all  uvm base classes 
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
-------------------------------------------------------------
# UVM_INFO top.sv(17) @ 50: reporter [TB_TOP] Hello World
# Hello World with Display
-------------------------------------------------------------
