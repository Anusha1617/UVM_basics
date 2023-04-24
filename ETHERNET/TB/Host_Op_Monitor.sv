class Host_Op_Monitor extends uvm_monitor;
	//===FACTORY REGISTRATION===//
	`uvm_component_utils(Host_Op_Monitor)

	//========HANDLE FOR VIRTUAL INTERFACE=======//	
	virtual Ethernet_APB_interface vintf;

	Host_Seq_item req;

	//===CONSTRUCTOR===//
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	//======BUILD PHASE======//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual Ethernet_APB_interface)::get(this,"","virtual_apb_intf",vintf))
			`uvm_fatal("driver_connectphase",$sformatf("Getting interface is failed"));
			req=Host_Seq_item::type_id::create("req in host monitor");
	endfunction


	//========task runphase=======//
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
			req.psel_i=vintf.host_cb_monitor.psel_i;		//Setup state
			req.prstn_i=vintf.host_cb_monitor.prstn_i;
			req.penable_i=vintf.host_cb_monitor.penable_i;
			req.pwrite_i=vintf.host_cb_monitor.pwrite_i;
			req.paddr_i=vintf.host_cb_monitor.paddr_i;
			req.pwdata_i=vintf.host_cb_monitor.pwdata_i;
	endtask

endclass
