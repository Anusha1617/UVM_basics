//-------------------ACTIVE_AGENT--------------------------//

class Host_Active_agent extends uvm_agent;
	//----------FACTORY REGISTRATION------//
	`uvm_component_utils(Host_Active_agent)
	//uvm_analysis_port#(Host_Seq_item) h_aa_scrb;
	
	//------- HANDLES DECLARATION--------// seqr driver ipmon
	Host_Sequencer h_Host_Seqr; 	
	Host_Driver h_Host_Driv;
	Host_Ip_Monitor h_Host_Ip_Monitor;

	//-------CONSTRUCTOR------------//
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//---------BUILD PHASE---------//
    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_Host_Seqr = Host_Sequencer::type_id::create("Host_Seqr",this);
		h_Host_Driv = Host_Driver::type_id::create("Host_Driv",this);
		h_Host_Ip_Monitor = Host_Ip_Monitor::type_id::create("Host_Ip_Monitor",this);
//		h_aa_scrb=new("",this);
	endfunction

	//--------CONNECT PHASE---------------//  connecting the driver and seqr
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		h_Host_Driv.seq_item_port.connect(h_Host_Seqr.seq_item_export);		
	endfunction
endclass
