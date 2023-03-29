class  Input_Monitor extends uvm_monitor;

`uvm_component_utils(Input_Monitor)//1.factory registration

	uvm_analysis_port#(Transaction) h_im_to_sb_port;   // port used to send h_trans to the agent 

	virtual APB_intf h_vintf;   // virtual interface is ud=sed to get the signals from the interface

	Transaction h_trans;   // transaction handle to hold the interface given values
	
//------------------------VARIABLES---------------------------------//
	
bit[`DATA_WIDTH-1:0]memory[64'd4294967296]; 

static integer write_counter,read_counter;  // to check the data stability

static logic[`DATA_WIDTH-1:0]prev_data;   // used to store the previous data
static logic[`ADDR_WIDTH-1:0]prev_address;   // to store the prev_address


//-------------------------COMPONENT CONSTRUCTOR-----------------------------//
function new(string name="",uvm_component parent);
        super.new(name,parent);  // creating memory for parent class
endfunction

//----------------- BUILD PHASE------------------------------------------//
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_im_to_sb_port = new("h_im_sb_port",this);    // creating memory  we can create it by using create method
		h_trans = Transaction::type_id::create("h_trans");
	endfunction
//-------------------CONNECT PHASE -------------------------------//
function void connect_phase(uvm_phase phase);
		if(! uvm_config_db #(virtual APB_intf)::get(this,"","apb_intf_key",h_vintf))
			`uvm_fatal("config failure",$sformatf("=== Failing to establish config in input monitor"));
	endfunction

//-------------------------RUN PHASE -----------------------------------//
	task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		
		forever 
		@(h_vintf.cb_monitor) // for every posedge 
		begin  // taking the signals from the interface
			h_trans.reset_n = h_vintf.cb_monitor.reset_n;
			h_trans.pselx = h_vintf.cb_monitor.pselx;
			h_trans.penable = h_vintf.cb_monitor.penable;
			h_trans.pwrite = h_vintf.cb_monitor.pwrite;
			h_trans.pwdata = h_vintf.cb_monitor.pwdata;
			h_trans.paddress = h_vintf.cb_monitor.paddress;
												//`uvm_info("INPUTMONITOR",$sformatf("TESTING IN BEFORE CHECKER "),UVM_NONE)
            // calling the checker task

              //  h_trans.print();
				task_checker;

			h_im_to_sb_port.write(h_trans);  // calling write method in scoreboard and sending h_trans as argument h_trans will be stored in the scoreboard
            
		end
	endtask

//------------------CHECKER-------------//
task task_checker;
		task_reset;
endtask


task task_reset;
			if(!h_trans.reset_n) // reset_n==0 active low reset
					  begin  
					  									`uvm_info("INPUTMONITOR",$sformatf("TESTING IN RESET "),UVM_NONE)
					  	     foreach(memory[i])   // memory reset filling all locations with zeros
							  begin
							  			memory[i]=0;
							  end	
						   		h_trans.pslverr=0;
								h_trans.prdata=32'b0;
								h_trans.pready=0;
                                    				read_counter=0;
                                    				write_counter=0;
					   end
			else 
					  begin
					  			task_slave;

					  end
endtask 

task task_slave; 
		if(h_trans.pselx) // pselx=1 slave is selected
				  begin
									`uvm_info("INPUTMONITOR",$sformatf("TESTING IN SLAVE "),UVM_NONE)				  
				  			if(h_trans.pwrite)
									  begin
									  			task_write;
									  			$display("calling task write");
									  end
							else if(h_trans.pwrite==0)
									  begin
									  			task_read;
									  end
									  else begin end
				   end
		else   // slave is not selected pselx = 0
				  begin
				 			 // hold previous values as it is
							write_counter=0;
							read_counter=0;
						    h_trans.pslverr=0;
							h_trans.prdata=32'b0;
							h_trans.pready=0;
							prev_data='bz;
							prev_address='bz;
				   end
endtask

task task_write;  // sel=1  and reset=1  pwrite=1
				write_counter++;
				read_counter=0;
				prev_data=(write_counter==1)? h_trans.pwdata:prev_data; // previous data storage
				prev_address=(write_counter==1)? h_trans.paddress:prev_address; // previous address storage
				
               			 write_counter=(write_counter==3)?1:write_counter;
               			 
               			 $display("write_counter=%0d",write_counter);
                
				if(write_counter==(`WAIT_PULSES+2) && h_trans.penable && prev_data==h_trans.pwdata && prev_address==h_trans.paddress)  
						  begin
						  $display("\n\t\t\t\t--------------time=%0t---------DATA WRITING -- write_counter=%0d---------------------------------\n",$time,write_counter);
									  	memory[h_trans.paddress] = h_trans.pwdata;
										h_trans.pready=1;
										write_counter=-1;
                                $display("memory=%p",memory);

						  end 
				else if(write_counter==(`WAIT_PULSES+2) && h_trans.penable && (prev_data!=h_trans.pwdata || prev_address!=h_trans.paddress))  
						 begin 
											 h_trans.pslverr=1;
											 write_counter=0;
						 end
			  else 	
						 begin
						 			// hold previous values as it is
									h_trans.pslverr=0;
									h_trans.prdata=32'b0;
									h_trans.pready=0;
						  end
endtask

task task_read;
		read_counter++;
		write_counter=0;
		prev_address=(read_counter==1) ? h_trans.paddress : prev_address; // previous address storage
	//	$display($time,"read_counter=%0d in read block \n \t\t\t\t prev_address=%0d",read_counter,prev_address);
	//	$display($time,"write_counter=%0d in read block",write_counter);

                read_counter=(read_counter==3)?1:read_counter;
                
		if(read_counter==(`WAIT_PULSES+2) && h_trans.penable &&  prev_address==h_trans.paddress)
				  begin
						  $display("\t\t\t\t--------------time=%0t---------DATA READING   read_counter=%0d -----------------------------------",$time,read_counter);
				  				h_trans.prdata=memory[h_trans.paddress];		
								h_trans.pready=1;
                                $display("memory=%p",memory);
								read_counter=-1;
				   end
		else if(read_counter==(`WAIT_PULSES+2) && h_trans.penable && ( prev_address!=h_trans.paddress))  
					 begin 
										h_trans.pslverr=1;
						     			h_trans.prdata=32'bz;
		        			        	h_trans.pready=0;
										read_counter=0;
					 end
		else
				  begin
				  			// hold previous values as it is
									h_trans.pslverr=0;
									h_trans.prdata=32'b0;
									h_trans.pready=0;
				  end
endtask




endclass




