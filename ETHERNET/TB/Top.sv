`include"mcs_dv05_ethernet_project_assertions.sv"

`include"../../mcs_dv05_ethernet_project_RTL/eth_txcounters.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_txethmac.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_txstatem.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_wishbone.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_miim.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_outputcontrol.v" 
`include"../../mcs_dv05_ethernet_project_RTL/eth_random.v"        
`include"../../mcs_dv05_ethernet_project_RTL/eth_receivecontrol.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_registers.v"     
`include"../../mcs_dv05_ethernet_project_RTL/eth_shiftreg.v"       
`include"../../mcs_dv05_ethernet_project_RTL/eth_spram_256x32.v"   
`include"../../mcs_dv05_ethernet_project_RTL/eth_top.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_transmitcontrol.v"
`include"../../mcs_dv05_ethernet_project_RTL/apb_BDs_bridge.v" 
`include"../../mcs_dv05_ethernet_project_RTL/eth_clockgen.v"   
`include"../../mcs_dv05_ethernet_project_RTL/eth_crc.v"        
`include"../../mcs_dv05_ethernet_project_RTL/eth_fifo.v"       
`include"../../mcs_dv05_ethernet_project_RTL/eth_maccontrol.v" 
`include"../../mcs_dv05_ethernet_project_RTL/ethmac_defines.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_macstatus.v"  

`include"../../mcs_dv05_ethernet_project_RTL/timescale.v"
`include"../../mcs_dv05_ethernet_project_RTL/eth_register.v"      
`include"../../mcs_dv05_ethernet_project_RTL/eth_rxaddrcheck.v"   
`include"../../mcs_dv05_ethernet_project_RTL/eth_rxcounters.v"     
`include"../../mcs_dv05_ethernet_project_RTL/eth_rxethmac.v"       
`include"../../mcs_dv05_ethernet_project_RTL/eth_rxstatem.v"       



`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_interface/mcs_dv05_ethernet_project_APB_interface.sv"
module top;

bit pclk_i;
bit MTxClk,prstn_i,MRxClk;
	
	always #1 pclk_i++;   	//APB Clock f=25MHz  	
	always #10 MTxClk++;   //Tx_MAC Clock	f=2.5MHz	
	always #10 MRxClk++;   //Rx_MAC Clock  f=2.5MHz

	import pkg::*;      //package
	import uvm_pkg::*;  // importing uvm_base classes  
			

	Ethernet_APB_interface h_apb_intf(pclk_i,MTxClk);
	
// config_class handles declaration	
	Config_class h_config;	
//Module Instantiation of DUT 

eth_top dut (
        h_apb_intf.pclk_i,
        h_apb_intf.prstn_i,
        h_apb_intf.pwdata_i,
        h_apb_intf.prdata_o,

        h_apb_intf.paddr_i,
        h_apb_intf.psel_i,
        h_apb_intf.pwrite_i,
        h_apb_intf.penable_i,
        h_apb_intf.pready_o,

        h_apb_intf.m_paddr_o,
        h_apb_intf.m_psel_o,
        h_apb_intf.m_pwrite_o,

        h_apb_intf.m_pwdata_o,
        h_apb_intf.m_prdata_i,
        h_apb_intf.m_penable_o,
        h_apb_intf.m_pready_i,

        h_apb_intf.int_o,
        h_apb_intf.MTxClk,
        h_apb_intf.MTxD,
        h_apb_intf.MTxEn,
        h_apb_intf.MTxErr,

        h_apb_intf.MRxClk,
        h_apb_intf.MRxD,
        h_apb_intf.MRxDV,
        h_apb_intf.MRxErr,
        h_apb_intf.MCrS
        );

//Binding Assertion Module
// Eth_Assertions(
//bind eth_top Eth_Assertions ass_label(.*);
/*
bind eth_top Eth_Assertions ass_label(pclk_i, prstn_i, pwdata_i, prdata_o,
                            paddr_i, psel_i, pwrite_i, penable_i, pready_o, 
                            m_paddr_o, m_psel_o, m_pwrite_o, m_pwdata_o, m_prdata_i, m_penable_o, m_pready_i, 
                            int_o, 
                            MTxClk, MTxD, MTxEn, MTxErr, 
                            MRxClk, MRxD, MRxDV, MRxErr, MCrS);
                            */
 initial begin
		uvm_config_db #(virtual Ethernet_APB_interface) :: set(null,"uvm_test_top.*","virtual_apb_intf",h_apb_intf); // config_db set 
		h_config = Config_class :: type_id :: create("h_config");
		uvm_config_db #(Config_class) :: set(null,"*","config_class",h_config);
		//$display("addr in top config = %0d",h_config);
		run_test();		//Calling all the Run phases

	end

	initial begin
	//h_apb_intf.MCrS<=0;
	//h_apb_intf.prstn_i<=0;
	//#40
	//h_apb_intf.prstn_i<=1;
	
	//#1462000 $finish;
	end

endmodule
/*
module eth_top
(
  // APB common
  pclk_i, prstn_i, pwdata_i, prdata_o, 4
  // APB slave
  paddr_i, psel_i, pwrite_i, penable_i, pready_o,  5
  // APB master
  m_paddr_o, m_psel_o, m_pwrite_o, m_pwdata_o, m_prdata_i, m_penable_o, m_pready_i, 7 
  int_o, 1
  //TX
  mtx_clk_pad_i, mtxd_pad_o, mtxen_pad_o, mtxerr_pad_o, 4

  //RX
  mrx_clk_pad_i, mrxd_pad_i, mrxdv_pad_i, mrxerr_pad_i, mcrs_pad_i  5

);
*/

//assert(uvm_config_db #(virtual Ethernet_MAC_interface ) :: get(this,this.get_full_name(),"virtual_mac_intf",h_Ethernet_Intf));  // set interface in
