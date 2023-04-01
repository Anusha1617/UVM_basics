class Slave_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_Env)

Slave_A_agent h_Slave_A_agent;
//Slave_P_agent h_Slave_P_agent;

Slave_Seq h_Slave_Seq;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Slave_A_agent=Slave_A_agent::type_id::create("h_Slave_A_agent",this); 
	 h_Slave_Seq=Slave_Seq::type_id::create("h_Slave_Seq"); 


	// h_Slave_P_agent=Slave_P_agent::type_id::create("h_Slave_PA_agent",this); 
endfunction

endclass
