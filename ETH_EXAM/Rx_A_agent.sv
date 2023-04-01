class Rx_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_A_agent)

Rx_driver h_Rx_driver;

Rx_seqr h_Rx_seqr;

Rx_ip_mo h_Rx_ip_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Rx_driver=Rx_driver::type_id::create("h_Rx_driver",this); 
	 h_Rx_seqr=Rx_seqr::type_id::create("h_Rx_seqr",this);
	 h_Rx_ip_mo=Rx_ip_mo::type_id::create("h_Rx_ip_mo",this);
endfunction







endclass
