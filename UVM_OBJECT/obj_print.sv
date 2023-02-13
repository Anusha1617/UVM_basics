
`include "uvm_macros.svh"

import uvm_pkg::*;

typedef enum{RED, GREEN, BLUE} color_type;

//---------------------------------MY_OBJECT------------------------------------//
class my_object extends uvm_object;

  rand int        o_var;
       string     o_name;
  rand color_type colors;
  rand byte       data[4];
  rand bit [7:0]  addr;
  
  `uvm_object_utils(my_object)   // USING THE OBJECT UTILS NOT USING THE FIELD MACROS  
  
  function new(string name = "my_object");
    super.new(name);
  endfunction
endclass
//---------------------------------------MY_TEST------------------------------//
class my_test extends uvm_test;
  `uvm_component_utils(my_test)   
  my_object obj;
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    obj = my_object::type_id::create("obj", this);
    assert(obj.randomize());
    obj.print();

  endfunction
   
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule
/*
---------------------NO CLASS PROPERTIES WILL BE PRINTED ----------------------------------//
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(277) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(278) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO @ 0: reporter [RNTST] Running test my_test...
# ----------------------------
# Name  Type       Size  Value
# ----------------------------
# obj   my_object  -     @473 
# ----------------------------
# UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
# ----------------------------------
# Name          Type     Size  Value
# ----------------------------------
# uvm_test_top  my_test  -     @466 
# ----------------------------------
# 
# 
# --- UVM Report Summary ---
# 
# ** Report counts by severity
# UVM_INFO :    4
# UVM_WARNING :    0
# UVM_ERROR :    0
# UVM_FATAL :    0
# ** Report counts by id
# [Questa UVM]     2
# [RNTST]     1
# [UVMTOP]     1
# ** Note: $finish    : /chicago/tools/Questa_2021.4_3/questasim/linux_x86_64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh(430)
#    Time: 0 ns  Iteration: 215  Instance: /tb
# Saving coverage database on exit...
# End time: 13:35:49 on Feb 13,2023, Elapsed time: 0:00:02
# Errors: 0, Warnings: 2

*/
