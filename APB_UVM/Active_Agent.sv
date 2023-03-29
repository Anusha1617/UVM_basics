class Active_Agent extends uvm_agent;

`uvm_component_utils(Active_Agent)   //1.factory register  

uvm_analysis_export #(Transaction) h_trans_agent_export;     // used in exporting transaction object  from agent to the scoreboard by using uvm analysis port

// declaring handles for leafs

Driver h_driver;    
Input_Monitor h_input_monitor;    
Sequencer h_sequencer;

//---------------------------COMPONENT CONSTRUCTOR -------------------------------------//
function new(string name="",uvm_component parent);
            super.new(name,parent);  // creating memory for parent class
endfunction

//----------------- BUILD PHASE-------------------//

function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            h_driver = Driver::type_id::create("h_driver",this);
            h_input_monitor = Input_Monitor ::type_id::create("h_input_monitor",this);
            h_sequencer = Sequencer ::type_id::create("h_sequencer",this);   
            
            h_trans_agent_export=new("h_trans_agent_export",this);    // cretaing memory for the h_trans_agent_export 

endfunction



//----------------- CONNECT PHASE-------------------//

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        h_driver.seq_item_port.connect(h_sequencer.seq_item_export);   // connecting driver and  sequencer   sequencer export to the driver  
        h_input_monitor.h_im_to_sb_port.connect(this.h_trans_agent_export);    // connecting inputmonitor and agent    input_monitor to agent  
endfunction
endclass





