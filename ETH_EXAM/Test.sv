class Test extends uvm_test;

//------FACTORY Registration----------------//
	`uvm_component_utils(Test)

Main_Env h_Main_Env;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
 h_Main_Env=Main_Env::type_id::create("h_Main_Env",this);
// uvm_test_top.enable_print_topology();
 print;
endfunction



function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
        phase.raise_objection(this,"raised objection");    
        fork
            h_Main_Env.h_Slave_Env.h_Slave_Seq.start(h_Main_Env.h_Slave_Env.h_Slave_A_agent.h_Slave_seqr);
            h_Main_Env.h_Mem_Env.h_Mem_Seq.start(h_Main_Env.h_Mem_Env.h_Mem_A_agent.h_Mem_seqr);
            h_Main_Env.h_Tx_Env.h_Tx_Seq.start(h_Main_Env.h_Tx_Env.h_Tx_A_agent.h_Tx_seqr);
         join
        phase.drop_objection(this,"dropped_objection");

endtask






endclass
