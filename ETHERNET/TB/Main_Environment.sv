//-----------------------------------------------------//
//             Main_Environment class
//-----------------------------------------------------//
class Main_Environment extends uvm_env;
    `uvm_component_utils(Main_Environment)

//-----------------------------------------------------//
//               Handles  for Leafs
//-----------------------------------------------------//

    Host_Env h_Host_Env;
    Mem_Env h_Mem_Env;
    Tx_Env h_Tx_Env;
    Scoreboard h_Tx_Scoreboard;
    Tx_Coverage h_Tx_Coverage;

//-----------------------------------------------------//
//               Constructor
//-----------------------------------------------------//
    function new(string name="",uvm_component parent);  //new constructor
    	super.new(name,parent);
    endfunction

//-----------------------------------------------------//
//                Build Phase
//-----------------------------------------------------//

    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	h_Tx_Scoreboard=Scoreboard::type_id::create("Tx_Scoreboard",this);
    	h_Tx_Coverage=Tx_Coverage::type_id::create("Tx_Coverage",this);
    	h_Tx_Env=Tx_Env::type_id::create("Tx_Env",this);
    	h_Mem_Env=Mem_Env::type_id::create("Mem_Env",this);
    	h_Host_Env=Host_Env::type_id::create("Host_Env",this);
    endfunction

//-----------------------------------------------------//
//                Connect Phase
//-----------------------------------------------------//

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	        h_Tx_Env.h_Tx_Op_Mon.h_tx_op_aa_port.connect(h_Tx_Scoreboard.dut_fifo.analysis_export);
  //coverage connection
	    h_Host_Env.h_Host_Active_agent.h_Host_Ip_Monitor.h_host_ip_to_aa.connect(h_Tx_Coverage.analysis_export);
	    
	    h_Mem_Env.h_aa.m_ipmon.m_i_port.connect(h_Tx_Coverage.analysis_imp_mem);
	    
	    h_Tx_Env.h_Tx_A_agent.h_Tx_op_mo.h_tx_cov_port.connect(h_Tx_Coverage.analysis_imp_tx);	        
	endfunction


endclass
