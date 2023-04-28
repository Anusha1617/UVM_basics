class Mem_Driver extends uvm_driver #(Mem_seq_item);
	`uvm_component_utils(Mem_Driver)

	//--------------------	Properties ----------------//
	virtual Ethernet_APB_interface Mem_vif;// Interface Handle 
	//config class has to come
	Config_class h_db;
    int Packet_count=1;
    bit [32]TXBD;
	//---------------- Component Constructor ----------------------//
	function new(string name = "Mem_Driver", uvm_component parent = null );
		super.new(name,parent);
	endfunction


	//----------------- Build - phase ---------------------//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		//--------------- Interface instantiation ------------//
		if(!uvm_config_db#(virtual Ethernet_APB_interface) :: get(this,"","virtual_apb_intf",Mem_vif))
			`uvm_fatal(get_type_name(), "CONFIG DB get FAIL @ MEM_DRIVER")
		if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal(get_name(),"mem_config class instance fail")
	    req=Mem_seq_item::type_id::create("req");
	endfunction
	//local variables
	local int i,j,Payload_by_4_counter;

	//---------------- Run - phase -----------------------//
    task run_phase(uvm_phase phase);
    begin
    	//@(Mem_vif.Mem_cb_driver)
    			Mem_vif.Mem_cb_driver.m_pready_i <= 0;
    			Mem_vif.Mem_cb_driver.m_prdata_i <= 0;

    	forever @(Mem_vif.Mem_cb_driver) begin

    		if(Mem_vif.Mem_cb_driver.prstn_i==0)
                	begin	Mem_vif.Mem_cb_driver.m_pready_i <= 0;
                        	Mem_vif.Mem_cb_driver.m_prdata_i <= 0;
                    end
    		else	begin

    		        seq_item_port.get_next_item(req);

    		                 i=0;//No. of read APB TRANSACTIONS payload
    		                 j=0;//No. of Write APB Transactions packet
                             TXBD++;
						`uvm_info("MEM started sending Payload ",$sformatf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~TXBD %0d~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",TXBD),UVM_HIGH)	

    	        	while(i < req.paylength && j < req.paylength)	begin//{
    	        	   		wait( (Mem_vif.Mem_cb_driver.m_penable_o==0 && Mem_vif.Mem_cb_driver.m_psel_o==1))  // waiting until e=0 s=1 setup state
                      	        			Mem_vif.Mem_cb_driver.m_pready_i <= 0;                              // sending ready=0

    	        		if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)                                 	// sending the payload 32 bit wise in setup state
    	        		        Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[i+0],req.Payload[i+1],req.Payload[i+2],req.Payload[i+3]};
    	        		//on Next posedge 

                        @(Mem_vif.Mem_cb_driver)  // checking in the next posedge

                        wait( (Mem_vif.Mem_cb_driver.m_penable_o==1 && Mem_vif.Mem_cb_driver.m_psel_o==1))      // checking access phase
    	        		//Drive ready with payload
    	        		if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)	begin                       	// APB Read
    	        			Mem_vif.Mem_cb_driver.m_pready_i <= 1; 
    	        			Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[i+0],req.Payload[i+1],req.Payload[i+2],req.Payload[i+3]};
    	        			i=i+4;
    	        			h_db.set_mem(Mem_vif.m_paddr_o,Mem_vif.m_prdata_i);                                 //saving in config class
    	        			@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
    	        		end//if end


    	        		else if(Mem_vif.Mem_cb_driver.m_pwrite_o==1 && req.mode==1)	begin                   	// APB Write
    	        			Mem_vif.Mem_cb_driver.m_pready_i <= 1;
//    	        			Mem_vif.Mem_cb_driver.m_prdata_i <= z;
    	        			j=j+4;
    	        			@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
    	        		end//}else end

    	        		else begin
    	        			`uvm_info("DRIVER","Break due to mismatch between seq write and dut write",UVM_MEDIUM)	break;
    	        		end;


    	        	end//}while end
    		Payload_by_4_counter=0;
    		seq_item_port.item_done();
						`uvm_info("MEM stopped sending Payload","",UVM_HIGH)

    		end//else end
    	end//forever end
    end//begin end
    TXBD=0;
    endtask

	
	
endclass

