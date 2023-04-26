//================================================Test Class======================================================//

class Base_Test extends uvm_test;

	`uvm_component_utils(Base_Test)

	Main_Environment h_Main_Environment;
	Config_class h_config;

	Mem_Seq h_Mem_Seq;
	Tx_Seq h_Tx_Seq;

	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))
		`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));

		h_Main_Environment=Main_Environment::type_id::create("Main_Environment",this);
	  	h_Mem_Seq=Mem_Seq::type_id::create("Mem_Seq");  // virtual
        h_Tx_Seq=Tx_Seq::type_id::create("Tx_Seq");  // virtual
	endfunction


	virtual	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask


endclass
