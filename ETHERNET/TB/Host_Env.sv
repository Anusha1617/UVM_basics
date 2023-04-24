//================HOST_Environment class=========//

class Host_Env extends uvm_env;          //extending the class
    `uvm_component_utils(Host_Env)           //Factory registration

//HANDLE DECLARATIONS FOR Active_agent

    Host_Active_agent h_Host_Active_agent;
    Host_Passive_agent h_Host_Passive_agent;
    Host_Seq h_Host_Seq;


    function new(string name="",uvm_component parent);  //new constructor
    	super.new(name,parent);
    endfunction


    function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
    	h_Host_Active_agent=Host_Active_agent::type_id::create("Host_Active_agent",this);
    	h_Host_Passive_agent=Host_Passive_agent::type_id::create("Host_Passive_agent",this);
    	h_Host_Seq=Host_Seq::type_id::create("h_Host_Seq");	 
    endfunction
endclass
