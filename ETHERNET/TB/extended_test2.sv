//================================================Test Class======================================================//

class Test2 extends Test1;

//Factory Registration
	`uvm_component_utils(Test2)

//Class Handle Declaration

	Host_Seq2 h_Host_Seq;



//Component Constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

//Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
  		h_Host_Seq=Host_Seq2::type_id::create("Host_Seq2");  // virtual
	endfunction

virtual	function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
//		uvm_top.print_topology();
	endfunction

//Run Phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this,"raised objection test");
			h_Host_Seq.start(h_Main_Environment.h_Host_Env.h_Host_Active_agent.h_Host_Seqr);
			fork
				h_Mem_Seq.start(h_Main_Environment.h_Mem_Env.h_aa.m_seqcr);
				h_Tx_Seq.start(h_Main_Environment.h_Tx_Env.h_Tx_A_agent.h_Tx_seqr);
			join

		phase.phase_done.set_drain_time(this, 1000);

		phase.drop_objection(this,"droped objection test");
	endtask

endclass
