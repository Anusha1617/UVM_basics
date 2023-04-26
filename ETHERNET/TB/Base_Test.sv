//================================================Test Class======================================================//

class Test1 extends uvm_test;

//Factory Registration
	`uvm_component_utils(Test1)

//Class Handle Declaration
	Main_Environment h_Main_Environment;
	Config_class h_config;

	Host_Seq1 h_Host_Seq;
	Mem_Seq h_Mem_Seq;
	Tx_Seq h_Tx_Seq;
//Component Constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

//Build Phase
virtual	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))
		`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));

		h_Main_Environment=Main_Environment::type_id::create("Main_Environment",this);
  		h_Host_Seq=Host_Seq1::type_id::create("Host_Seq1");  // virtual
	  	h_Mem_Seq=Mem_Seq::type_id::create("Mem_Seq");  // virtual
                h_Tx_Seq=Tx_Seq::type_id::create("Tx_Seq");  // virtual
	endfunction


virtual	function void end_of_elaboration_phase(uvm_phase phase);
//super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

//Run Phase
virtual	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this,"raised objection test");
			h_Host_Seq.start(h_Main_Environment.h_Host_Env.h_Host_Active_agent.h_Host_Seqr);
			fork
				h_Mem_Seq.start(h_Main_Environment.h_Mem_Env.h_aa.m_seqcr);
				h_Tx_Seq.start(h_Main_Environment.h_Tx_Env.h_Tx_A_agent.h_Tx_seqr);
			join
#100
		phase.phase_done.set_drain_time(this, 1000);
		phase.drop_objection(this,"droped objection test");
	endtask

endclass
