//`include "Mem_interface.sv"
//`include "Mem_seq_item.sv"
//enum {BAD,GOOD} FRAME;

class Mem_input_monitor extends uvm_monitor;
	`uvm_component_utils(Mem_input_monitor)
	
	//------------	Properties ------------//
	uvm_analysis_port #(Mem_seq_item) m_i_port;
	virtual Ethernet_APB_interface Mem_vif;
	Mem_seq_item req;
	Config_class h_db;
	
	//variables
	bit[7:0] Payload [$];
	bit pkt_in_progress;
	int Rx_length,r_p;	//r_p : RX - packet no
	
	//---------------- Component Constructor ----------------------//
	function new(string name = "Mem_input_monitor", uvm_component parent = null );
		super.new(name,parent);
		
	endfunction
	
	//----------------- Build - phase ---------------------//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		//--------------- Interface instantiation ------------//
		if(!uvm_config_db#(virtual Ethernet_APB_interface) :: get(this,"","virtual_apb_intf",Mem_vif))
			`uvm_fatal(get_type_name(), "CONFIG DB get FAIL @ Mem_input_monitor")
			
		//--------------- Config Class instantiation ---------//
		h_db = Config_class::type_id::create("h_db");
		if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal("INPUT MONITOR","mem_config class instance fail")
		
		//--------------- ANalysis port instantiation -------------//
		m_i_port=new("m_i_port",this);
		
		req=Mem_seq_item::type_id::create("req");
		
	endfunction
	
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		
		forever@(Mem_vif.Mem_cb_monitor)	begin
			
			req.m_paddr_o 	 = Mem_vif.Mem_cb_monitor.m_paddr_o ;
			req.m_pwdata_o	 = Mem_vif.Mem_cb_monitor.m_pwdata_o ;
			req.m_psel_o	 = Mem_vif.Mem_cb_monitor.m_psel_o ;
			req.m_pwrite_o 	 = Mem_vif.Mem_cb_monitor.m_pwrite_o ;
			req.m_penable_o  = Mem_vif.Mem_cb_monitor.m_penable_o ;
			req.int_o	 = Mem_vif.Mem_cb_monitor.int_o ;
			req.prstn_i	 = Mem_vif.Mem_cb_monitor.prstn_i ;
			req.m_pready_i	 = Mem_vif.Mem_cb_monitor.m_pready_i ;
			req.m_prdata_i	 = Mem_vif.Mem_cb_monitor.m_prdata_i ;
			
			//req.print();set_mem;
			
			if(!Mem_vif.Mem_cb_monitor.prstn_i)	begin
				Payload ={};
				pkt_in_progress=0;
				Rx_length=0;r_p=0;
			end
			else	rx_packatization;
		end
		
	endtask
	
	
	task rx_packatization;
		//for storing values in memory during writing i.e. rx mode
			if(Mem_vif.Mem_cb_monitor.m_psel_o && Mem_vif.Mem_cb_monitor.m_penable_o && Mem_vif.Mem_cb_monitor.m_pwrite_o && Mem_vif.Mem_cb_monitor.m_pready_i)	
			begin	
				
				h_db.set_mem(Mem_vif.Mem_cb_monitor.m_paddr_o,Mem_vif.Mem_cb_monitor.m_pwdata_o);
			end
			else;
			
			
			//RX mode packetization
			if(Mem_vif.MRxDV && pkt_in_progress==0)	begin
				pkt_in_progress=1;
			
				wait(req.m_pwrite_o && req.m_psel_o && req.m_penable_o)	begin
					Payload.push_front(req.m_pwdata_o[31:24]);		Payload.push_front(req.m_pwdata_o[23:16]);		
					Payload.push_front(req.m_pwdata_o[15:8]);		Payload.push_front(req.m_pwdata_o[7:0]);			
				end
			end
			else if(Mem_vif.MRxDV && pkt_in_progress==1)	begin
				if(req.m_pwrite_o && req.m_psel_o && req.m_penable_o)	begin
					Payload.push_front(req.m_pwdata_o[31:24]);		Payload.push_front(req.m_pwdata_o[23:16]);		
					Payload.push_front(req.m_pwdata_o[15:8]);		Payload.push_front(req.m_pwdata_o[7:0]);
				end
			end
			
			else if(!Mem_vif.MRxDV && pkt_in_progress==1)//last
				if(req.m_pwrite_o && req.m_psel_o && req.m_penable_o)	begin
					Payload.push_front(req.m_pwdata_o[31:24]);			
					Payload.push_front(req.m_pwdata_o[23:16]);		
					Payload.push_front(req.m_pwdata_o[15:8]);		
					Payload.push_front(req.m_pwdata_o[7:0]);
					pkt_in_progress=0;
					
					Rx_length=h_db.LEN[r_p]+6+6+2+2;
					
					if(Rx_length == Payload.size())	req.frame = '{GOOD};
					else 	req.frame = '{0};		
					
					
					req.Payload = Payload;//copying local q to transaction q
					
					m_i_port.write(req);//sending to scoreboard
						
					//removing element for next transaction			
					Payload={};
					req.Payload = {};
					
					r_p++;			
				end	
			else ;
	endtask
		
endclass








	
//Config_class
/*clocking Mem_cb_monitor@(posedge pclk_i);
        input  #0 m_paddr_o,m_pwdata_o,m_psel_o,m_pwrite_o,m_penable_o,int_o,prstn_i;
        input  #0 m_pready_i,m_prdata_i;
	endclocking*/





































