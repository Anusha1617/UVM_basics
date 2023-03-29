class Sequence extends uvm_sequence ;   // transaction object as a parameter

//class Sequence extends uvm_sequence #(Transaction);

`uvm_object_utils(Sequence)


// creating handle for transaction
Transaction h_trans;   

//-------------CONSTRUCTOR-----------------//
	function new(string name="GENERATOR");
		super.new(name);
	endfunction

//--------------TASK BODY  ----------------//

task pre_body();       
		`uvm_info("SEQUENCE","PREBODY\n",UVM_NONE)
		$display("hierarchy in sequencer =%s",get_full_name());
endtask


task body();
		h_trans=Transaction::type_id::create("h_trans");  // creating new transaction object
		//h_trans=null;  memory is deallocated
		repeat(10)
		        begin

                
		                start_item(h_trans);     // strated item 
	                        assert(h_trans.randomize());  
	                        `uvm_info("GENERATOR","PRINTING H_TRANS IN GENERATOR ",UVM_NONE)
				//h_trans.print;
		                finish_item(h_trans);   // completed one transaction
		        end
endtask



task post_body();
	`uvm_info("SEQUENCE","POSTBODY\n",UVM_NONE)
endtask
/*
task brain();
h_trans=Transaction::type_id::create("h_trans");  // creating new transaction object
repeat(10)
        begin

                //h_trans=Transaction::type_id::create("h_trans");  // creating new transaction
                start_item(h_trans);     // strated item 
                        assert(h_trans.randomize());  
                        `uvm_info("SEQUENCER",$sformatf("\nh_trans=%p\n",h_trans),UVM_NONE)
                finish_item(h_trans);   // completed one transaction
        end
endtask
*/

endclass
