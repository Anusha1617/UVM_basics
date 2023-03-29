class Environment extends uvm_env; // inheriting the prop of uvm_env to Environment class

`uvm_component_utils(Environment)   //1.factory register  




// ------------creating handles for leafs----------------------//

Active_Agent h_active_agent;   //  creating handle for active agent
Passive_Agent h_passive_agent;   // creating handle for passive agent
Scoreboard h_scoreboard;      // creating handle for scoreboard
Coverage h_cg;

//-----------------  COMPONENT  CONSTRUCTOR ------------------//

	function new(string name = "test", uvm_component parent);
		super.new(name,parent);
	endfunction


//-------------------------BUILD PHASE ------------------------//
function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            h_active_agent = Active_Agent::type_id::create("h_agent",this);   // Agent memory creation ------------>>  uvm tree
            h_passive_agent = Passive_Agent::type_id::create("h_passive_agent",this);  // Passive agent memory creation
            h_scoreboard = Scoreboard::type_id::create("h_scoreboard",this);   // Scoreboard memory creation
            h_cg = Coverage::type_id::create("h_Coverage",this);   // Coverage memory creation
endfunction

//-------------------CONNECT PHASE -------------------------------//

virtual function void connect_phase(uvm_phase phase);   // for connecting the active agent to scoreboard  and passive agent to the scoreboard`
                super.connect_phase(phase);
                h_active_agent.h_trans_agent_export.connect(h_scoreboard.tb_fifo.analysis_export);  // connecting the analysis ports  from input monitor to the scoreboard 
// active agent  >> input monitor >> htrans_send   ====>>   scoreboard >> h_trans_recieve 
                h_passive_agent.h_trans_sagent_exp.connect(h_scoreboard.dut_fifo.analysis_export);
// passive agent  >> output monitor >> htrans_send   ====>>   scoreboard >> h_trans_recieve 

		h_active_agent.h_trans_agent_export.connect(h_cg.analysis_export);

endfunction
 
 
 
 
 
endclass
