//=================PASSIVE_AGENT========================//

class Host_Passive_agent extends uvm_agent;
	//===========FACTORY REGISTRATION==========//
	`uvm_component_utils(Host_Passive_agent)
	
	//============ HANDLES DECLARATION======//
	Host_Op_Monitor h_Host_Op_Monitor;

	//============CONSTRUCTOR=================//
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction 

	//===============BUILD PHASE===================//
    function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_Host_Op_Monitor = Host_Op_Monitor::type_id::create("Host_Op_Monitor",this);
	endfunction

	//================CONNECT PHASE=================//
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	
	endfunction
endclass
