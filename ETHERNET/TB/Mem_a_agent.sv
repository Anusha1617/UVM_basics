

class Mem_a_agent extends uvm_agent;
	`uvm_component_utils(Mem_a_agent)
	
	//properties
	uvm_analysis_export #(Mem_seq_item) m_i_export;
	Mem_Driver m_driver;
	Mem_seqcr m_seqcr;
	Mem_input_monitor m_ipmon;
	
	function new(string name="Mem_a_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//m_i_export = new("m_i_export",this);
		m_driver = Mem_Driver::type_id::create("m_driver",this);
		m_seqcr = Mem_seqcr::type_id::create("m_seqcr",this);
		m_ipmon = Mem_input_monitor::type_id::create("m_ipmon",this);
		
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		m_driver.seq_item_port.connect(m_seqcr.seq_item_export);
		
		//m_ipmon.m_i_port.connnect(this.m_i_export);
//					h_Seq.start(h_Main_Environment.h_Mem_Env.h_aa.m_seqcr);
	endfunction
	
endclass
