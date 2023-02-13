`include "uvm_macros.svh"

import uvm_pkg::*;

typedef enum{RED, GREEN, BLUE} color_type;  // globally we are declaring so that we can use anywhere
// -------temp classs ----------------------//
class temp_class extends uvm_object;

  rand bit [7:0] tmp_addr;    
  rand bit [7:0] tmp_data;
  
  function new(string name = "temp_class");
    super.new(name);
  endfunction
  

  // field registration
  `uvm_object_utils_begin(temp_class)
  `uvm_field_int(tmp_addr, UVM_ALL_ON)  // BIT
  `uvm_field_int(tmp_data, UVM_ALL_ON) // BIT
  `uvm_object_utils_end

endclass

//-----------------------my_object----------------------//

class my_object extends uvm_object;

  rand int        value;
  string     names;
  rand color_type colors;    
  rand byte       data[4];
  rand bit [7:0]  addr;
  rand temp_class tmp;
  
  `uvm_object_utils_begin(my_object)
  `uvm_field_int(value, UVM_ALL_ON)           // INT DATATYPE
  `uvm_field_string(names, UVM_ALL_ON)          // STRING DATATYPE
  `uvm_field_enum(color_type, colors, UVM_ALL_ON)    // ENUM 
  `uvm_field_sarray_int(data, UVM_ALL_ON)        // STATIC ARRAY
  `uvm_field_int(addr, UVM_ALL_ON)           // BIT 
  `uvm_field_object(tmp, UVM_ALL_ON)            // OBJECT
  `uvm_object_utils_end
  
  function new(string name = "my_object");
    super.new(name);
    tmp = new();   // creating ,memory for the tmp object
    this.names = "UVM";    // configuring the name 
  endfunction
endclass

//-----------------my_test-------------------//

class my_test extends uvm_test;

  `uvm_component_utils(my_test)

  my_object obj;  			 // object
  bit packed_data_bits[];    	// DA 
  byte unsigned packed_data_bytes[]; //DA
  int unsigned packed_data_ints[];   //DA
  
  my_object unpack_obj;   // OBJ
  
  function new(string name = "my_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

        obj = my_object::type_id::create("obj", this);   
        assert(obj.randomize());   
    //    obj.print();   // printing object using print method

    // or
    `uvm_info(get_full_name(), $sformatf("obj = \n%s", obj.sprint()), UVM_LOW);
  endfunction
endclass

module tb;
  initial begin
    run_test("my_test");
  end
endmodule



/*
------------------------------------------------USING SPRINT ----------------------------------------------------

#                               
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(277) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(278) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO @ 0: reporter [RNTST] Running test my_test...
# UVM_INFO o_print.sv(77) @ 0: uvm_test_top [uvm_test_top] obj = 
# --------------------------------------------
# Name          Type          Size  Value     
# --------------------------------------------
# obj           my_object     -     @473      
#   value       integral      32    'hf43c3dd8
#   names       string        3     UVM       
#   colors      color_type    32    GREEN     
#   data        sa(integral)  4     -         
#     [0]       integral      8     'h2f      
#     [1]       integral      8     'h40      
#     [2]       integral      8     'h2       
#     [3]       integral      8     'h7       
#   addr        integral      8     'h16      
#   tmp         temp_class    -     @474      
#     tmp_addr  integral      8     'h38      
#     tmp_data  integral      8     'h50      
# --------------------------------------------
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
# [uvm_test_top]     1
# ** Note: $finish    : /chicago/tools/Questa_2021.4_3/questasim/linux_x86_64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh(430)



------------------------------------------------USING PRINT ----------------------------------------------------

# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(277) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(278) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO @ 0: reporter [RNTST] Running test my_test...
# --------------------------------------------
# Name          Type          Size  Value     
# --------------------------------------------
# obj           my_object     -     @473      
#   value       integral      32    'hf43c3dd8
#   names       string        3     UVM       
#   colors      color_type    32    GREEN     
#   data        sa(integral)  4     -         
#     [0]       integral      8     'h2f      
#     [1]       integral      8     'h40      
#     [2]       integral      8     'h2       
#     [3]       integral      8     'h7       
#   addr        integral      8     'h16      
#   tmp         temp_class    -     @474      
#     tmp_addr  integral      8     'h38      
#     tmp_data  integral      8     'h50      
# --------------------------------------------
# 
# --- UVM Report Summary ---
# 
# ** Report counts by severity
# UVM_INFO :    3
# UVM_WARNING :    0
# UVM_ERROR :    0
# UVM_FATAL :    0
# ** Report counts by id
# [Questa UVM]     2
# [RNTST]     1
# ** Note: $finish    : /chicago/tools/Questa_2021.4_3/questasim/linux_x86_64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh(430)
#    Time: 0 ns  Iteration: 215  Instance: /tb
# Saving coverage database on exit...
# End time: 12:04:15 on Feb 13,2023, Elapsed time: 0:00:03
# Errors: 0, Warnings: 2

*/
