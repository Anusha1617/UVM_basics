
class Mem_output_monitor extends uvm_monitor;
	`uvm_component_utils(Mem_output_monitor)
	
	//------------	Properties ------------//
	uvm_analysis_port #(Mem_seq_item) m_o_port;
	virtual Ethernet_APB_interface Mem_vif;
	Mem_seq_item t1;
	
	//---------------- Component Constructor ----------------------//
	function new(string name = "Mem_output_monitor", uvm_component parent = null );
		super.new(name,parent);
	endfunction
	
	//----------------- Build - phase ---------------------//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//--------------- Interface instantiation ------------//
		if(!uvm_config_db#(virtual Ethernet_APB_interface) :: get(this,"","virtual_apb_intf",Mem_vif))
			`uvm_fatal(get_type_name(), "CONFIG DB get FAIL @ Mem_output_monitor")
			
		//--------------- Config Class instantiation ---------//
		
		
		//--------------- ANalysis port instantiation -------------//
		
		
		t1=new();
			
	endfunction
	
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		forever@(Mem_vif.Mem_cb_monitor)	begin
			
			t1.m_paddr_o 	 = Mem_vif.Mem_cb_monitor.m_paddr_o ;
			t1.m_pwdata_o	 = Mem_vif.Mem_cb_monitor.m_pwdata_o ;
			t1.m_psel_o		 = Mem_vif.Mem_cb_monitor.m_psel_o ;
			t1.m_pwrite_o 	 = Mem_vif.Mem_cb_monitor.m_pwrite_o ;
			t1.m_penable_o 	 = Mem_vif.Mem_cb_monitor.m_penable_o ;
			t1.int_o		 = Mem_vif.Mem_cb_monitor.int_o ;
			t1.prstn_i		 = Mem_vif.Mem_cb_monitor.prstn_i ;
			t1.m_pready_i	 = Mem_vif.Mem_cb_monitor.m_pready_i ;
			t1.m_prdata_i	 = Mem_vif.Mem_cb_monitor.m_prdata_i ;
			
			//t1.print();
		
		end
		
	endtask
	
endclass
