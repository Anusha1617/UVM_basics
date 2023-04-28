class Test1 extends Base_Test;

	`uvm_component_utils(Test1)

// test case specific seq need to be instantiated
	Host_Seq1 h_Host_Seq;  // just change only the seq name
	Host_Seq2 h_Host_Seq2;
	Host_Seq3 h_Host_Seq3;

	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
  		h_Host_Seq=Host_Seq1::type_id::create("Host_Seq1");  // virtual
  		h_Host_Seq2=Host_Seq2::type_id::create("Host_Seq2");  // virtual
  		h_Host_Seq3=Host_Seq3::type_id::create("Host_Seq3");  // virtual
	endfunction

	virtual	function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
	endfunction

//Run Phase
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this,"raised objection Test1");

                print_testcase("TEST1");
                h_Host_Seq.start(h_Main_Environment.h_Host_Env.h_Host_Active_agent.h_Host_Seqr);
	    		task_mem_tx_start;
/*
                print_testcase("TEST2");
                h_Host_Seq2.start(h_Main_Environment.h_Host_Env.h_Host_Active_agent.h_Host_Seqr);
                task_mem_tx_start;
*/
                print_testcase("TEST3");
                h_Host_Seq3.start(h_Main_Environment.h_Host_Env.h_Host_Active_agent.h_Host_Seqr);
                task_mem_tx_start;

		phase.phase_done.set_drain_time(this, 1000);

		phase.drop_objection(this,"droped objection Test1");
	endtask

    virtual task task_mem_tx_start;
			fork
				h_Mem_Seq.start(h_Main_Environment.h_Mem_Env.h_aa.m_seqcr);
				h_Tx_Seq.start(h_Main_Environment.h_Tx_Env.h_Tx_A_agent.h_Tx_seqr);
			join
            #100;
    endtask

    function void print_testcase(string TEST_CASE="Testcase");

        $display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        $display(">>>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t >>>");$display(">>>\t\t\t\t\t\t\t%0s\t\t\t\t\t\t\t\t >>>",TEST_CASE);$display(">>>\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t >>>");
        $display(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    endfunction
