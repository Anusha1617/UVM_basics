class Mem_ip_mo extends uvm_monitor;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_ip_mo)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
