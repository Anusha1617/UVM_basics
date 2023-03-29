class test496 extends uvm_test;   // inheriting the prop of uvm_test to Test class


`uvm_component_utils(test496) //1.factory register  




Environment h_environment;    // creating handle for the Environment class 

nested_sequence h_nested_sequence;


//---------------COMPONENT CONSTRUCTOR-----------------------//
	function new(string name = "test496", uvm_component parent);
		super.new(name,parent);
	endfunction

//----------------- BUILD PHASE-------------------//
        function void build_phase(uvm_phase phase);
                    super.build_phase(phase);
                  // no error when we remove above
                    h_environment = Environment::type_id::create("h_environment",this);  // creating memory fo the environment class,,,,,  this refers to parent
                    h_nested_sequence = nested_sequence::type_id::create("h_nested_sequence");  // creating memory fo the Generator class,,,,,  this refers to parent

        endfunction
        
//------------------END OF ELABORATION-----------------------// 
        
        function void end_of_elaboration_phase(uvm_phase phase);
                 //   uvm_top.print_topology();    // printing the topology
        endfunction

//---------------------RUN PHASE -------------------------//

task run_phase(uvm_phase phase);
 

//print;           
            phase.raise_objection(this,"raise");
                    h_nested_sequence.start(h_environment.h_active_agent.h_sequencer);
            phase.drop_objection(this,"DROPPED OBJECTION IN TEST");
         //  # ** Note: $finish    : /chicago/tools/Questa_2021.4_3/questasim/linux_x86_64/../verilog_src/uvm-1.1d/src/base/uvm_root.svh(430)

endtask
endclass


