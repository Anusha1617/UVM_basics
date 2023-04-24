class Mem_Env extends uvm_env;
	`uvm_component_utils(Mem_Env)
	
	
	//------------	Properties ------------//
	Mem_a_agent h_aa;
	Mem_p_agent h_pa;

	
	
	//---------------- Component Constructor ----------------------//
	function new(string name="Mem_Env",uvm_component parent = null);
		super.new(name,parent);
		 
	endfunction
	
	
	//----------------- Build - phase ---------------------//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_aa = Mem_a_agent::type_id::create("h_aa",this);
		h_pa = Mem_p_agent::type_id::create("h_pa",this);
		
	endfunction
	
				//h_Seq.start(h_Main_Environment.h_Mem_Env.h_aa.m_seqcr);
endclass
