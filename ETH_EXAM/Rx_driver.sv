class Rx_driver extends uvm_driver#(Seq_item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction







endclass
