class Mem_seqcr extends uvm_sequencer #(Mem_seq_item);
  `uvm_component_utils(Mem_seqcr)
  
  function new(string name = "Mem_seqcr", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  
endclass
