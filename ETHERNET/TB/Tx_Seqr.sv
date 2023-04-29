
class Tx_seqr extends uvm_sequencer #(Tx_Seq_Item);


//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_seqr)

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

endclass
