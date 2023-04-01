class Slave_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_A_agent)

Slave_driver h_Slave_driver;

Slave_seqr h_Slave_seqr;

Slave_op_mo h_Slave_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	 h_Slave_driver=Slave_driver::type_id::create("h_Slave_driver",this); 
	 h_Slave_seqr=Slave_seqr::type_id::create("h_Slave_seqr",this);
	 h_Slave_op_mo=Slave_op_mo::type_id::create("h_Slave_op_mo",this);
endfunction


function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Slave_driver.seq_item_port.connect(h_Slave_seqr.seq_item_export);
endfunction

endclass
