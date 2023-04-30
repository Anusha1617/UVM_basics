//Working with set and get in verbosity level

`include "uvm_macros.svh"
import uvm_pkg::*;
module tb;
  initial begin
    $display("Default Verbosity level : %0d ", uvm_top.get_report_verbosity_level);  // get

    uvm_top.set_report_verbosity_level(UVM_HIGH);  // set
 //   uvm_top.set_report_verbosity_level(300);

    $display("after changng Verbosity level : %0d ", uvm_top.get_report_verbosity_level);
    `uvm_info("TB_TOP", "String", UVM_HIGH);

  end
endmodule

----------------------------------------------------
# Default Verbosity level : 200 
# after changng Verbosity level : 300 
# UVM_INFO top.sv(16) @ 0: reporter [TB_TOP] String
----------------------------------------------------
