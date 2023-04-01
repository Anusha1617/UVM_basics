class Mem_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_Env)

Mem_A_agent h_Mem_A_agent;
Mem_P_agent h_Mem_P_agent;

Mem_Seq h_Mem_Seq;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Mem_A_agent=Mem_A_agent::type_id::create("h_Mem_A_agent",this); 
	 h_Mem_P_agent=Mem_P_agent::type_id::create("h_Mem_P_agent",this); 
	 h_Mem_Seq=Mem_Seq::type_id::create("h_Mem_Seq"); 
endfunction

endclass
