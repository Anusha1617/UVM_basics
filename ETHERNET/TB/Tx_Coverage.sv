//-----------------------------------------------------//
//             Coverage class
//-----------------------------------------------------//
class Tx_Coverage extends uvm_subscriber #(Host_Seq_item);
	`uvm_component_utils(Tx_Coverage)
//-----------------------------------------------------//
//               Handles  for Leafs
//-----------------------------------------------------//
	Host_Seq_item h_trans;
//-----------------------------------------------------//
//               Coverage Group
//-----------------------------------------------------//
	//Covergroup for all the Input Variables from the Transaction with Coverpoints & Bins
	covergroup cg;

	//Reset
		RESET : coverpoint h_trans.prstn_i {bins rst0 = {0};
							bins rst1 = {1};}

		RESET_transition : coverpoint h_trans.prstn_i {bins rst10 = (1=>0);
								  bins rst01 = (0=>1);
								  }
	//----------------Slave Signals-----------------------//
	//Slave Select
		SELECT : coverpoint h_trans.psel_i iff(h_trans.prstn_i==1) {  bins sel0 = {0};
										bins sel1 = {1};}

		SELECT_transition : coverpoint h_trans.psel_i iff(h_trans.prstn_i==1) {bins sel10 = (1=>0);
											bins sel01 = (0=>1);}

	//Enable
		ENABLE : coverpoint h_trans.penable_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1) {bins en0 = {0};
												       bins en1 = {1};}

		ENABLE_transition : coverpoint h_trans.penable_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1) {bins en10 = (1=>0);
														bins en01 = (0=>1);}

	//Read-write enable
		cp_write : coverpoint h_trans.pwrite_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1) {bins write0 = {0};
												    bins write1 = {1};}

		cp_write_transition : coverpoint h_trans.pwrite_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1) { bins wr10 = (1=>0);
														bins rd01 = (0=>1);}

	//Address
		ADDRESS : coverpoint h_trans.paddr_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1 && h_trans.penable_i==1)
		{
			//bins add1 = {[0:$]};}
			bins MODER1 = {'h00} ;
			bins INT_SOURCE1 = {'h04};
			bins INT_MASK1 = {'h08};
			bins TX_BD_NUM = {'h20};
			bins MIIADDRESS1 = {'h30};
			bins MAC_ADDR01 = {'h40};
			bins MAC_ADDR11 = {'h44};
			bins TX_RX_BD2[ ] = {['h400:'h7ff]} with (item%4 == 0); // addr with multiple of 4
		}


	//Write Data
		DATA : coverpoint h_trans.pwdata_i iff(h_trans.prstn_i==1 && h_trans.psel_i==1 && h_trans.penable_i==1 && h_trans.pwrite_i==1)
		{
			bins data1 = {[0:50],[51:100]};
			bins data0 = {0};
			bins data128 = {128};
			bins data2 = {[101:150], [151:200]};
			bins data3 = {[201:250], [251:300]};
			bins data4 = {[301:400], [401:$]};
			bins dataf = {32'hffff};
			//bins wdata1 = {[0:$]};
		}


	//Cross bins
	/*
	CROSS_RST_SEL		: cross RESET, SELECT		iff(h_trans.prstn_i==1)
		{ignore_bins ig_sel_rst = (binsof(RESET.rst1) && binsof(SEL.sel0) || binsof(RESET.rst1) && binsof(SEL.sel1));}

	CROSS_RST_ENABLE	: cross RESET,ENABLE		iff(h_trans.prstn_i==1)
		{ignore_bins ig_sel_enable = (binsof(RESET.rst1) && binsof(ENABLE.en0) || binsof(RESET.rst1) && binsof(ENABLE.en1));}

	CROSS_RST_WRITE		: cross RESET, WRITE		iff(h_trans.prstn_i==1)
		{ignore_bins ig_write_rst = (binsof(RESET.rst1) && binsof(WRITE.write0) || binsof(RESET.rst1) && binsof(WRITE.write1));}

	CROSS_SEL_ENABLE 	: cross SELECT, ENABLE		iff(h_trans.psel_i==0)
		{ignore_bins ignr_sel0_en1 = (binsof(SELECT.sel0) && binsof(ENABLE.en1) || binsof(SELECT.sel0) && binsof(ENABLE.en0));}

	CROSS_SEL_WRITE 	: cross SELECT, WRITE		iff(h_trans.pwrite_i==0)
		{ignore_bins ig_sel_write = (binsof(WRITE.write0) && binsof(SEL.sel0) || binsof(WRITE.write1) && binsof(SEL.sel0));}
		*/
	/*CROSS_WRITE_ENABLE	: cross WRITE, ENABLE		iff(h_trans.pwrite_i==0)
		{ignore_bins ig_sel_enable=(binsof(WRITE.write0)&& binsof(ENABLE.enable0) ||  binsof(WRITE.write1) && binsof(ENABLE.enable0));}
	*/
	/*
TX_BD_NUM_config  : cross ADDRESS,DATA iff(h_trans.prstn_i==1 && h_trans.psel_i==1 )
{
		bins all_RX_BD = binsof (ADDRESS.TX_BD_NUM) && binsof (DATA.data0) ;
		bins all_TX_BD = binsof (ADDRESS.TX_BD_NUM) && binsof (DATA.data128);
		bins equal_TX_RX_BD = binsof (ADDRESS.TX_BD_NUM) && binsof (DATA.data64) ;
}
	*/
	endgroup


//-----------------------------------------------------//
//               Constructor
//-----------------------------------------------------//
    function new(string name = "", uvm_component parent);
		super.new(name, parent);
		cg=new();
	endfunction
//-----------------------------------------------------//
//                Build Phase
//-----------------------------------------------------//
	function void build_phase(uvm_phase phase);//-------------building
		super.build_phase(phase);
		h_trans = new("h_trans");
		//cg = new();  // error???
	endfunction
//-----------------------------------------------------//
//               write function
//-----------------------------------------------------//
	 function void write(T t);
	 h_trans=Host_Seq_item::type_id::create("covvvv");
		cg.sample();
		//$display($time,"COVERAGE ::::::: \n ");
	endfunction		//*/

endclass
