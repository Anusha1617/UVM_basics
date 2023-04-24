//================================================Test Class======================================================//

class Test extends uvm_test;

//Factory Registration		
	`uvm_component_utils(Test)	
	
//Class Handle Declaration
	Main_Environment h_Main_Environment;	
	
	virtual_sequence h_seq_v;  // virtual 	seq instance creation 
	
	
	
//Component Constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_Main_Environment=Main_Environment::type_id::create("h_Main_Environment",this);
  		h_seq_v	=virtual_sequence::type_id::create("h_seq_v");  // virtual 
	endfunction


	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

//Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this,"raised objection test");
			h_seq_v.start(h_Main_Environment.h_virtual_sequencer);   // virtual 
			phase.phase_done.set_drain_time(this, 10000);   
			
		phase.drop_objection(this,"droped objection test");
	endtask
	
endclass
