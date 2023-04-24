class Mem_p_agent extends uvm_agent;
	`uvm_component_utils(Mem_p_agent)
	
	//properties
	uvm_analysis_export #(Mem_seq_item) m_o_export;
	Mem_output_monitor m_opmon;
	
	function new(string name="Mem_p_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//m_o_export = new("m_o_export",this);
		m_opmon = Mem_output_monitor::type_id::create("m_opmon",this);
		
	endfunction
	
	
endclass
