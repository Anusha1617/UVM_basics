// no need to include the Package

module top;

bit pclk;

//always `CLK_PERIOD/2  pclk++;
always #2  pclk++;
import uvm_pkg :: * ;   // importing the all the pkg components
import Pkg::*;  // importing the all apb package components

APB_intf h_intf(pclk);

`DUT_MODULE_NAME dut(h_intf.pclk,h_intf.reset_n,h_intf.paddress,h_intf.pwrite,h_intf.pselx,h_intf.penable,h_intf.pwdata,h_intf.pslverr,h_intf.pready,h_intf.prdata);

/*module apb_logi (input pclk, input reset_n, input [31:0]paddress, input pwrite, input pselx, input penable, input [31:0]pwdata, output reg pslverr,                 output reg pready, output reg [31:0]prdata);
*/
initial begin 
                uvm_config_db  #(virtual APB_intf) :: set (null,"*","apb_intf_key",h_intf);  // all members accessible
        run_test("test496");   // calling run_test method in test class give test class name as argument or 

end

endmodule
//-------------------------------------------------------------------------------------------------//
    config_db     SET functio
static function void set (  uvm_component   cntxt,   // starting point where data entry is accessible
                            string          inst_name,  // hierarchical path that limits accessibility of database entry
                            string          field_name, // label used for lookup database entry
                            T               value);    // value to be stored in database

static function bit get (   uvm_component  cntxt,
                            string         inst_name,
                            string         field_name,
                      inout T              value);
