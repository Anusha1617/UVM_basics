class Host_Sequencer extends uvm_sequencer #(Host_Seq_item);
	`uvm_component_utils(Host_Sequencer)

	function new(string name="Host_Sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction 
endclass
