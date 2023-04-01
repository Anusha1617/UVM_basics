class Tx_Seq_Item extends uvm_sequence_item;
`uvm_object_utils(Tx_Seq_Item)

bit MTxClk;
bit MTxD;
bit MTxEn;
bit MTxErr;
bit MCrS;

bit int_o;

// component constructor 
function new(string name="");
		super.new(name);
endfunction


endclass
