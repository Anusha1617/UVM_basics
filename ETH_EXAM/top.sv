`include"Package.sv"

module top;

bit MTxClk;
import uvm_pkg::*;
import exam_pkg::*;


bit pclk_i;

always #400 pclk_i++;
always #40 MTxClk++;



Ethernet_Intf h_intf(pclk_i,MTxClk);

//dut insta

initial begin
		uvm_config_db #(virtual Ethernet_Intf ) :: set(null,"*","key",h_intf);  // set interface in configdb
			
		run_test("Test"); // calling run_test method

end

endmodule 
