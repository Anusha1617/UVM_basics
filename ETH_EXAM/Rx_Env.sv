class Rx_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_Env)

Rx_A_agent h_Rx_A_agent;
//Rx_P_agent h_Rx_P_agent;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Rx_A_agent=Rx_A_agent::type_id::create("h_Rx_A_agent",this); 
	// h_Rx_P_agent=Rx_P_agent::type_id::create("h_Rx_P_agent",this); 
endfunction

endclass
