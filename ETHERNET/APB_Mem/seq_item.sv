
class Mem_seq_item extends uvm_sequence_item;
	

	//--------- Payload Information ---------//
	rand bit[7:0] Payload [$];
	rand int paylength;
	
	//------	Field registration ---------//
	`uvm_object_utils_begin(Mem_seq_item)
	
	`uvm_field_queue_int(Payload,UVM_ALL_ON);
	`uvm_field_int(paylength,UVM_ALL_ON);
	
	`uvm_object_utils_end
	
	//----------- Object constructor --------//
	  function new(string name = "Mem_seq_item");
		super.new(name);
	  endfunction
  
  	//----------  Constraints ----------------//
  	constraint Payload_constraint {
  									paylength inside {[4:1518]};		//Min to Max payload length
  									Payload.size() inside {paylength};	//Setting length to payload
  									solve paylength before Payload;		//solve length before queue randomize
  									}

endclass
