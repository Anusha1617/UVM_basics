class Tx_P_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_P_agent)


Tx_op_mo h_Tx_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_op_mo=Tx_op_mo::type_id::create("h_Tx_op_mo",this);
endfunction







endclass
