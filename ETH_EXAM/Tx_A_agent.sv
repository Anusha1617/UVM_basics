class Tx_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_A_agent)

Tx_driver h_Tx_driver;

Tx_seqr h_Tx_seqr;

Tx_op_mo h_Tx_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_driver=Tx_driver::type_id::create("h_Tx_driver",this); 
	 h_Tx_seqr=Tx_seqr::type_id::create("h_Tx_seqr",this);
	 h_Tx_op_mo=Tx_op_mo::type_id::create("h_Tx_op_mo",this);
endfunction


function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Tx_driver.seq_item_port.connect(h_Tx_seqr.seq_item_export);
endfunction




endclass
