	interface APB_Interface (input  pclk_i,MTxClk,prstn_i);

	//----------APB SLAVE -------//
	logic [31:0] paddr_i;
	logic [31:0]pwdata_i;
	logic psel_i;
	logic pwrite_i;
	logic penable_i;

	logic [31:0]prdata_o;
	logic pready_o;

	//------COMMON SIGNALS ------//

	logic int_o;

	//----- APB MASTER ----------//

	logic [31:0]m_paddr_o;
	logic [31:0]m_pwdata_o;
	logic m_psel_o;
	logic m_pwrite_o;
	logic m_penable_o;

	logic m_pready_i;
	logic [31:0]m_prdata_i;


	//------TX-------//
	logic[3:0] MTxD;
	logic MTxEn ;   
	logic MTxErr;


	//------COMMON SIGNALS ------//
	logic MCrS;



	//------------------------APB_HOST CLOCKING BLOCKS -------------------//    
		clocking Host_cb_driver@(posedge pclk_i);
		input #1 int_o,prdata_o,pready_o;
		output #0 prstn_i,paddr_i,pwdata_i,psel_i,pwrite_i,penable_i;
		endclocking

		clocking Host_cb_monitor@(posedge pclk_i);
		input #0 int_o,prdata_o,pready_o;
		input #0 prstn_i,paddr_i,pwdata_i,psel_i,pwrite_i,penable_i;
		endclocking

	//------------------------APB_MEMORY CLOCKING BLOCKS -------------------//    
		clocking Mem_cb_driver@(posedge pclk_i);
		input  #1 m_paddr_o,m_pwdata_o,m_psel_o,m_pwrite_o,m_penable_o,prstn_i,int_o;
		output  #0 m_pready_i,m_prdata_i;
		endclocking

		clocking Mem_cb_monitor@(posedge pclk_i);
		input  #0 m_paddr_o,m_pwdata_o,m_psel_o,m_pwrite_o,m_penable_o,prstn_i,int_o;
		input  #0 m_pready_i,m_prdata_i;
		endclocking

	//--------------------------TX_MAC CLOCKING BLOCKS ------------------------//

		clocking Tx_cb_driver@(posedge MTxClk );
		    input #1 MTxEn,MTxD,MTxErr,prstn_i,int_o;
		output #0 MCrS; 
	    endclocking

		clocking Tx_cb_monitor@(posedge MTxClk);
		    input #0 MTxEn,MTxD,prstn_i,MTxErr;
		input #0 MCrS,int_o; 
		endclocking

	endinterface


	/*

	//----------APB SLAVE -------//
	pclk_i
	prstn_i
	paddr_i
	pwdata_i
	psel_i
	pwrite_i
	penable_i

	prdata_o
	pready_o

	//------COMMON SIGNALS ------//

	int_o

	//----- APB MASTER ----------//

	m_paddr_o
	m_pwdata_o
	m_psel_o
	m_pwrite_o
	m_penable_o

	m_pready_i
	m_prdata_i


	//------TX-------//
	MTxClk
	MTxD
	MTxEn   
	MTxErr

	//------COMMON SIGNALS ------//
	MCrS

	//------RX-------//
	MRxClk
	MRxDV
	MRxD
	MRxErr






	*/
