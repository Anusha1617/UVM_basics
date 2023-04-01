class Mem_Seq extends uvm_sequence#(Mem_Seq_Item);



//------FACTORY Registration----------------//
	`uvm_object_utils(Mem_Seq)


// object constructor 
function new(string name="");
		super.new(name);
endfunction


        task body();
        req=Mem_Seq_Item::type_id::create("req in mem_seq");

                         repeat(1000)
                            begin   
                                  start_item(req);
                                     finish_item(req);
                             end


        endtask


endclass
