//MACRO `uvm_info with variables
`include "uvm_macros.svh"
import uvm_pkg::*;
module tb;
int data = 56;
  initial begin
    //-----------`uvm_info(ID,MSG,VERBOSITY)--------------------------//
    `uvm_info("TB_TOP", $sformatf("UVM_NONE verbosity Value of data : %0d",data),UVM_NONE);   //$sformatf
    `uvm_info("TB_TOP", $psprintf("199 verbosity Value of data : %0d",data),199);             //$psprintf
    `uvm_info("TB_TOP", $sformatf("250 verbosity Value of data : %0d",data),250);

    //  string + variable can be send to console by using $sformatf system function 
  end
endmodule

-------------------------------------------------------------------------
typedef enum {
   UVM_NONE    = 0,
   UVM_LOW     = 100,
   UVM_MEDIUM  = 200,
   UVM_HIGH    = 300,
   UVM_FULL    = 400,
   UVM_DEBUG   = 500
} uvm_verbosity;
-------------------------------------------------------------------------
#UVM_INFO top.sv(10) @ 0: reporter [TB_TOP] UVM_NONE verbosity Value of data : 56
# UVM_INFO top.sv(11) @ 0: reporter [TB_TOP] 199 verbosity Value of data : 56
-------------------------------------------------------------------------
