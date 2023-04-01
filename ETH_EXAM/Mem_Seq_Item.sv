class Mem_Seq_Item extends uvm_sequence_item;
`uvm_object_utils(Mem_Seq_Item)


bit[32] m_paddr_o;
bit [32]m_pwdata_o;
bit m_psel_o;
bit m_pwrite_o;
bit m_penable_o;
bit [32]m_prdata_i;
bit m_pready_i;


bit[7:0] memory[256000];




// component constructor 
function new(string name="");
		super.new(name);
endfunction


endclass
