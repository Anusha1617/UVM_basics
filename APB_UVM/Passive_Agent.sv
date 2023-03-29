class Passive_Agent extends uvm_agent;

`uvm_component_utils(Passive_Agent) //1.factory register  

uvm_analysis_export #(Transaction) h_trans_sagent_exp;

Output_Monitor h_op_monitor;

function new(string name="P_AGENT", uvm_component parent );   // component constructor
        super.new(name,parent);  // creating memory for parent class
endfunction

function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            h_op_monitor = Output_Monitor ::type_id::create("h_op_monitor",this);
            h_trans_sagent_exp=new("h_P_agent_export",this);  // creating new transaction
endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		h_op_monitor.h_trans_opmo_sb_port.connect(this.h_trans_sagent_exp);    // collecting transaction from output monitor tlm port
	endfunction


endclass
