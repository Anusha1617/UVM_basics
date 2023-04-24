

class Scoreboard extends uvm_scoreboard; 

    `uvm_component_utils(Scoreboard) //1.factory register  
    
    typedef bit [3:0] new_data_type  [$] ;
    new_data_type DUT_PAYLOAD;
    typedef bit[7:0] Payload [$];
    Payload TB_payload;//q of bytes get values from config db
    
   /* uvm_line_printer line;
    uvm_table_printer my_table;
    uvm_tree_printer tree; */
    
	uvm_tlm_analysis_fifo #(new_data_type) dut_fifo;

    Config_class h_config;

    function new(string name="SCOREBOARD", uvm_component parent );  // component constructor
            super.new(name,parent);  // creating memory for parent class
    endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		 dut_fifo=new("dut_fifo",this);
//		 line=new();
	//	 my_table=new();
	//	 tree=new();
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))
			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));
	endfunction
	
        int i,error;
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		 	forever	begin//{	
				error=0;
				dut_fifo.get(DUT_PAYLOAD);//getting from tx - monitor.
				TB_payload = h_config.TX_payloads[i].pl; //getting from config class which is generated in sequence.
                i++;				
				
				`uvm_info("SCORE DUT-PAYLOAD",$sformatf("DUT_PAYLOAD size = %0d ,\n DUT_PAYLOAD = %p",DUT_PAYLOAD.size(),DUT_PAYLOAD),UVM_MEDIUM)
				`uvm_info("SCORE TB-PAYLOAD",$sformatf("TB_payload size = %0d ,\n TB_payload = %p",TB_payload.size(),TB_payload),UVM_MEDIUM)
				
				if(DUT_PAYLOAD.size() == (2 * TB_payload.size() + 8) )	begin// 8 Is for fcs
					for(int j=0; j<TB_payload.size() ; j++)	begin
						
						if(TB_payload[j] == {DUT_PAYLOAD[1],DUT_PAYLOAD[0]} )
							`uvm_info("SCORE MATCH",$sformatf("Payload values match TB_payload[%0d] = %h equal to DUT_payload = %h",j,TB_payload[j],{DUT_PAYLOAD[1],DUT_PAYLOAD[0]}),UVM_HIGH)
						
						else	begin
							`uvm_error("SCORE MISMATCH",$sformatf("Payload values mismatch TB_payload[%0d] = %h not equal to DUT_payload = %h",j,TB_payload[j],{DUT_PAYLOAD[1],DUT_PAYLOAD[0]}))
							error=1;
							break;
						end
						
						repeat(2) DUT_PAYLOAD.pop_front();						
					end
					
					if(error)	`uvm_error("SCORE PAYLOAD FAIL","ERROR IN PAYLOAD")
					else	`uvm_info("SCORE PAYLOAD PASS","PAYLOADS ARE MATCHING",UVM_NONE)
										
				end
				
				else	
					`uvm_error("SCORE LEN-MIS",$sformatf("size mismatch between gen payload = %d and dut payload =%d",TB_payload.size,DUT_PAYLOAD.size))
				
				
			end
	endtask
	

endclass

	
	
	










































































/*class Scoreboard extends uvm_scoreboard; 

    `uvm_component_utils(Scoreboard) //1.factory register  

    uvm_line_printer line;
    uvm_table_printer my_table;
    uvm_tree_printer tree; 

	uvm_tlm_analysis_fifo #(new_data_type) dut_fifo;

    new_data_type DUT_trans;
    Config_class h_config;

    function new(string name="SCOREBOARD", uvm_component arent );  // component constructor
            super.new(name,parent);  // creating memory for parent class
    endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		 dut_fifo=new("dut_fifo",this);
		 line=new();
		 my_table=new();
		 tree=new();


		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))

			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));


	endfunction
	
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
     	forever
    	begin//{	
    	dut_fifo.get(DUT_trans);
    	forever
    	begin//{
    		if(DUT_trans.size) begin//{
    			if( DUT_trans.pop_front==h_config.mem[i])
    			begin//{
    				$display("--------------------------------PASS IN SCOREBOARD---------------------------- \n ");
    				write("-------------%0t-----------DUT DATA\t",$time);
    				DUT_trans.print(line);
    				$write("--------%0t------INPUT MONITOR DATA\t",$time);
    				i++;
    			end//}
    			else
    			begin//{
    				$display("--------------------------------FAIL IN SCOREBOARD---------------------------- \n ");
    								//DUT_trans.print(my_table);
    				$write("-------%0t-----------------DUT DATA\t",$time);
    								//DUT_trans.print(line);
    				$write("--------%0t------INPUT MONITOR DATA\t",$time);
    								//TB_trans.print(line);
    					i++;			
    			end//}
    			
    		end	//}	
    		end//}
    	end//}
    endtask	

endclass

	
	
	*/	
	
	










































































/*class Scoreboard extends uvm_scoreboard; 

    `uvm_component_utils(Scoreboard) //1.factory register  

    uvm_line_printer line;
    uvm_table_printer my_table;
    uvm_tree_printer tree; 

	uvm_tlm_analysis_fifo #(new_data_type) dut_fifo;

    new_data_type DUT_trans;
    Config_class h_config;

    function new(string name="SCOREBOARD", uvm_component arent );  // component constructor
            super.new(name,parent);  // creating memory for parent class
    endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		 dut_fifo=new("dut_fifo",this);
		 line=new();
		 my_table=new();
		 tree=new();


		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))

			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));


	endfunction
	
    task run_phase(uvm_phase phase);
    super.run_phase(phase);
     	forever
    	begin//{	
    	dut_fifo.get(DUT_trans);
    	forever
    	begin//{
    		if(DUT_trans.size) begin//{
    			if( DUT_trans.pop_front==h_config.mem[i])
    			begin//{
    				$display("--------------------------------PASS IN SCOREBOARD---------------------------- \n ");
    				write("-------------%0t-----------DUT DATA\t",$time);
    				DUT_trans.print(line);
    				$write("--------%0t------INPUT MONITOR DATA\t",$time);
    				i++;
    			end//}
    			else
    			begin//{
    				$display("--------------------------------FAIL IN SCOREBOARD---------------------------- \n ");
    								//DUT_trans.print(my_table);
    				$write("-------%0t-----------------DUT DATA\t",$time);
    								//DUT_trans.print(line);
    				$write("--------%0t------INPUT MONITOR DATA\t",$time);
    								//TB_trans.print(line);
    					i++;			
    			end//}
    			
    		end	//}	
    		end//}
    	end//}
    endtask	

endclass

	
	
	*/
