class Mem_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_A_agent)

Mem_driver h_Mem_driver;

Mem_seqr h_Mem_seqr;

Mem_ip_mo h_Mem_ip_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Mem_driver=Mem_driver::type_id::create("h_Mem_driver",this); 
	 h_Mem_seqr=Mem_seqr::type_id::create("h_Mem_seqr",this);
	 h_Mem_ip_mo=Mem_ip_mo::type_id::create("h_Mem_ip_mo",this);
endfunction

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Mem_driver.seq_item_port.connect(h_Mem_seqr.seq_item_export);
endfunction





endclass
