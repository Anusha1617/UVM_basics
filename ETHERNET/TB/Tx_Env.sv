


class Tx_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_Env)

Tx_A_agent h_Tx_A_agent;
//Tx_P_agent h_Tx_P_agent;

Tx_Seq  h_Tx_Seq ;

Tx_Op_Mon h_Tx_Op_Mon;
// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_A_agent=Tx_A_agent::type_id::create("h_Tx_A_agent",this); 
	// h_Tx_P_agent=Tx_P_agent::type_id::create("h_Tx_P_agent",this); ;
	 h_Tx_Op_Mon=Tx_Op_Mon::type_id::create("Tx_Op_Mon",this); 
	 h_Tx_Seq=Tx_Seq::type_id::create("h_Tx_Seq");


endfunction

endclass


