
class Host_Ip_Monitor extends uvm_monitor;
	//===FACTORY REGISTRATION===//
	`uvm_component_utils(Host_Ip_Monitor)

	//========HANDLE FOR VIRTUAL INTERFACE=======//	
	virtual Ethernet_APB_interface h_vintf;
	Config_class h_config;
	Host_Seq_item req;
	
	
	// analysis port for sending the transaction to the aa and then to the scrb
	uvm_analysis_port#(Host_Seq_item) h_host_ip_to_aa;

    
	//===CONSTRUCTOR===//
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction

	//======BUILD PHASE======//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_host_ip_to_aa = new("h_host_ip_to_aa",this);   // mem creation for port
		uvm_config_db #(virtual Ethernet_APB_interface)::get(this,"","virtual_apb_intf",h_vintf);
	
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))

			`uvm_fatal("driver_connectphase",$sformatf("Getting interface is failed"));
	endfunction


	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever @(h_vintf.host_cb_monitor)
		begin
			req = Host_Seq_item::type_id::create("req");

		        req.prstn_i   = h_vintf.host_cb_monitor.prstn_i;
			req.psel_i 	  = h_vintf.host_cb_monitor.psel_i;
			req.penable_i = h_vintf.host_cb_monitor.penable_i;
			req.pwrite_i  = h_vintf.host_cb_monitor.pwrite_i;
			req.paddr_i   = h_vintf.host_cb_monitor.paddr_i;
			req.pwdata_i  = h_vintf.host_cb_monitor.pwdata_i;
//				task_checker;

	 	        h_host_ip_to_aa.write(req); // writing into the port
			end
	endtask
endclass
