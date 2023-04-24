
interface Ethernet_APB_interface(input pclk_i,MTxClk);


//-------------SignalDeclaration----------------------//	
	//APB Slave Signals
	logic prstn_i,psel_i, pwrite_i, penable_i, pready_o;		//In Slave - Slave Select, RW_Select, Enable, Ready
	logic [31:0] paddr_i, pwdata_i, prdata_o;		//In Slave - Address, Write Data, Read Data
	
	
		enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;
	
	
	//APB_Master Signals	
	logic m_psel_o, m_pwrite_o, m_penable_o, m_pready_i;	//In Master - Slave Select, RW_Select, Enable, Ready
	logic [31:0] m_paddr_o, m_pwdata_o, m_prdata_i;		//In Master - Address, Write Data, Read Data

	
	//Common Signal
	logic int_o;						//Interrupt Out
	
	//------TX-------//
	logic[3:0] MTxD;
	logic MTxEn ;   
	logic MTxErr;


	//------COMMON SIGNALS ------//
	logic MCrS;


//------RX-------//
logic MRxClk;
logic MRxDV;
logic [3:0] MRxD;
logic MRxErr;



//--------------------------TX_MAC CLOCKING BLOCKS ------------------------//

	clocking Tx_cb_driver@(posedge MTxClk );
	    input  MTxEn,MTxD,MTxErr,int_o;
	    output  MCrS,prstn_i; 
	endclocking

	clocking Tx_cb_monitor@(posedge MTxClk);
	    input #0 MTxEn,MTxD,MTxErr;
	    input #0 MCrS,int_o,prstn_i; 
	endclocking
	
	
//-------------------Clocking Block for APB Slave(host)------------------------------//

	clocking host_cb_driver @ (posedge pclk_i);
		output  prstn_i, paddr_i, pwdata_i, psel_i, pwrite_i, penable_i;
		input  prdata_o, pready_o,int_o;		//int_o - if required
	endclocking

	clocking host_cb_monitor @ (posedge pclk_i);
		input #0 prstn_i, paddr_i, pwdata_i, psel_i, pwrite_i, penable_i, prdata_o, pready_o, int_o;
	endclocking
	
	
//-----------------------Clocking Block for APB Master(mem)-------------------------//

	clocking Mem_cb_driver @ (posedge pclk_i);
		input  prstn_i, m_paddr_o, m_pwdata_o, m_psel_o, m_pwrite_o, m_penable_o, int_o;
		output  m_prdata_i, m_pready_i;
	endclocking

	clocking Mem_cb_monitor @ (posedge pclk_i);
		input #0 prstn_i, m_paddr_o, m_pwdata_o, m_psel_o, m_pwrite_o, m_penable_o, m_prdata_i, m_pready_i, int_o;
	endclocking
	
	
	//Clocking Block for Driver
	clocking Mac_cb_driver @ (posedge MRxClk);
		output #1 MRxDV, MRxD, MRxErr, MCrS;		
	endclocking

//Clocking block for Monitor
	clocking Mac_cb_monitor @ (posedge MRxClk);
		input #1 MRxDV, MRxD, MRxErr, MCrS;
	endclocking
	/*
	always@(posedge pclk_i )
	begin 
		ite_i, penable_i, pready_o;		//In Slave - Slave Select, RW_Select, Enable, Ready
	logic [31:0] paddr_i, pwdata_i, prdata_o;		//In Slave - Address, Write Data, Read Data
	
	//APB_Master Signals	
	logic m_psel_o, m_pwrite_o, m_penable_o, m_pready_i;	//In Master - Slave Select, RW_Select, Enable, Ready
	logic [31:0] m_paddr_o, m_pwdata_o, m_prdata_i;	
	
	end
	*/
	always@(negedge pclk_i)
	begin
		if(paddr_i<'h400)
		$cast(Reg_addr,paddr_i);
	 end
	
	/*always@(posedge MTxClk)
	begin 
		$display($time,"MTXD=%0d\n",MTxD);
	
	end*/
	
	
	
endinterface
