class Tx_Seq_Item extends uvm_sequence_item;


bit MTxClk;
bit[3:0] MTxD;
bit MTxEn;
bit MTxErr;
bit MCrS;

bit int_o;

	`uvm_object_utils_begin(Tx_Seq_Item)
		`uvm_field_int(MTxD,UVM_ALL_ON)
		`uvm_field_int(MTxEn,UVM_ALL_ON)
		`uvm_field_int(MTxErr,UVM_ALL_ON)
		`uvm_field_int(MCrS,UVM_ALL_ON)								
	`uvm_object_utils_end

// component constructor 
	function new(string name="");
		super.new(name);
	endfunction


endclass
