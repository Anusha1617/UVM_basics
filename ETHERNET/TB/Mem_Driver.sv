class Mem_Driver extends uvm_driver #(Mem_seq_item);
	`uvm_component_utils(Mem_Driver)
	
	//--------------------	Properties ----------------//
	virtual Ethernet_APB_interface Mem_vif;// Interface Handle 
	//config class has to come
	Config_class h_db;
    int Packet_count=1;

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
	local int tx_payload,rx_payload,Payload_by_4_counter;
	
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
						`uvm_info("MEM DRV1233333","asked",UVM_NONE)	

//    		        		`uvm_info("DRIVER Packet",$sformatf("getting the payload %0d ",Packet_count++),UVM_LOW)	
    		                 tx_payload=0;//No. of read APB TRANSACTIONS payload
    		                 rx_payload=0;//No. of Write APB Transactions packet
    			
    	        	while(tx_payload < req.paylength && rx_payload < req.paylength)	begin 		
    	        	   		wait( (Mem_vif.Mem_cb_driver.m_penable_o==0 && Mem_vif.Mem_cb_driver.m_psel_o==1))  // waiting until e=0 s=1 setup state 
                      	        			Mem_vif.Mem_cb_driver.m_pready_i <= 0;                              // sending ready=0

    	        		if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)                                 	// sending the payload 32 bit wise in setup state
    	        		        Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[tx_payload+0],req.Payload[tx_payload+1],req.Payload[tx_payload+2],req.Payload[tx_payload+3]};
    	        		//on Next posedge 
    	        		
                        @(Mem_vif.Mem_cb_driver)  // checking in the next posedge
    	        		
                        wait( (Mem_vif.Mem_cb_driver.m_penable_o==1 && Mem_vif.Mem_cb_driver.m_psel_o==1))      // checking access phase
    	        		//Drive ready with payload
    	        		if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)	begin                       	// APB Read
    	        			Mem_vif.Mem_cb_driver.m_pready_i <= 1;   
                            $display($time,"\n\t\t\t\t\t\tPayload_by_4_counter=%0d\n",Payload_by_4_counter++);
    	        		//	`uvm_info("DUT READING",$sformatf("\n\t\t\t\t\t\t\t\t\tPayload count=%0d",Payload_by_4_counter),UVM_NONE)
    	        			Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[tx_payload+0],req.Payload[tx_payload+1],req.Payload[tx_payload+2],req.Payload[tx_payload+3]};
    	        			tx_payload=tx_payload+4;	
    	        			h_db.set_mem(Mem_vif.m_paddr_o,Mem_vif.m_prdata_i);                                 //saving in config class
    	        			@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
    	        		end//if end
    	        		
    	        		
    	        		else if(Mem_vif.Mem_cb_driver.m_pwrite_o==1 && req.mode==1)	begin                   	// APB Write
    	        			Mem_vif.Mem_cb_driver.m_pready_i <= 1;
//    	        			Mem_vif.Mem_cb_driver.m_prdata_i <= z;
    	        			rx_payload=rx_payload+4;	
    	        			@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
    	        		end//}else end
    	        		
    	        		else begin	
    	        			`uvm_info("DRIVER","Break due to mismatch between seq write and dut write",UVM_MEDIUM)	break;	
    	        		end;
    	        	
    	        			
    	        	end//while end
    		Payload_by_4_counter=0;
    		seq_item_port.item_done();	
    		
    		end//else end
    	end//forever end
    end//begin end
    
    endtask

	
	
endclass


/*	old driver..
		while(tx_payload < req.paylength && rx_payload < req.paylength)	begin 		
				//interrupt check or reset
							//	`uvm_info("DRIVER",$sformatf("getting tx_payload=",tx_payload,"rx_payload=",rx_payload),UVM_LOW)	
				//if(Mem_vif.Mem_cb_driver.int_o==1 || Mem_vif.Mem_cb_driver.prstn_i==0)	begin Mem_vif.Mem_cb_driver.m_pready_i <= 0; Mem_vif.Mem_cb_driver.m_prdata_i <= 0; res_disp; break;	end
				
					begin//1
					
					//Set up state check with interrupt is there or not
					wait( (Mem_vif.Mem_cb_driver.m_penable_o==0 && Mem_vif.Mem_cb_driver.m_psel_o==1))
					// || (Mem_vif.Mem_cb_driver.int_o==1 || Mem_vif.Mem_cb_driver.prstn_i==0))	
						Mem_vif.Mem_cb_driver.m_pready_i <= 0;
						//interrupt check or reset
						if(Mem_vif.Mem_cb_driver.int_o==1 || Mem_vif.Mem_cb_driver.prstn_i==0)	begin Mem_vif.Mem_cb_driver.m_pready_i <= 0; Mem_vif.Mem_cb_driver.m_prdata_i <= 0;	res_disp;  break;	end			
						
						//No interrupt
						else	begin//2
						//driving RDATA when set up state
							if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)	
								Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[tx_payload+0],req.Payload[tx_payload+1],req.Payload[tx_payload+2],req.Payload[tx_payload+3]};
							else;
							//on Next posedge 
							@(Mem_vif.Mem_cb_driver)
							
							//Access state check with interrupt is there or not
							wait( (Mem_vif.Mem_cb_driver.m_penable_o==1 && Mem_vif.Mem_cb_driver.m_psel_o==1) || (Mem_vif.Mem_cb_driver.int_o==1 || Mem_vif.Mem_cb_driver.prstn_i==0) )	
								
								//interrupt check or reset
								if(Mem_vif.Mem_cb_driver.int_o==1 || Mem_vif.Mem_cb_driver.prstn_i==0)	begin Mem_vif.Mem_cb_driver.m_pready_i <= 0; Mem_vif.Mem_cb_driver.m_prdata_i <= 0;	res_disp;  break;	end
							
								//Drive ready with payload
								else	begin//{3
								
									if(Mem_vif.Mem_cb_driver.m_pwrite_o==0 && req.mode==0)	begin	// APB Read
										Mem_vif.Mem_cb_driver.m_pready_i <= 1;
										Mem_vif.Mem_cb_driver.m_prdata_i <= {req.Payload[tx_payload+0],req.Payload[tx_payload+1],req.Payload[tx_payload+2],req.Payload[tx_payload+3]};
										$display("DRV    tx_payload=%0d",tx_payload);
										tx_payload=tx_payload+4;	
										
										h_db.set_mem(Mem_vif.Mem_cb_driver.m_paddr_o,Mem_vif.Mem_cb_driver.m_prdata_i);
										@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
									end//if end
									else if(Mem_vif.Mem_cb_driver.m_pwrite_o==1 && req.mode==1)	begin	// APB Write
										Mem_vif.Mem_cb_driver.m_pready_i <= 1;
										Mem_vif.Mem_cb_driver.m_prdata_i <= 0;
										rx_payload=rx_payload+4;	
										@(Mem_vif.Mem_cb_driver) Mem_vif.Mem_cb_driver.m_pready_i <= 0;
									end//}else end
									else begin	
										`uvm_info("DRIVER","Break due to mismatch between seq write and dut write",UVM_MEDIUM)	break;	
									end;
									
								end//3rd else end
						end//2nd else end
				end// 1nd else end
		end//while end*/
