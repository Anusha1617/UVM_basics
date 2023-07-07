
class mcs_axi4_write_input_monitor extends uvm_component;
`uvm_component_utils(mcs_axi4_write_input_monitor)
	function new(string name= "" , uvm_component parent);
	super.new(name,parent);
	 endfunction


//event declaration
	uvm_event e_wready;
	uvm_event e_response_drive;

//declarations of interface,sequence_item and config_class
	virtual	axi_intf h_axi_intf;
	mcs_axi4_write_seq_item h_mcs_axi4_write_seq_item;
    	config_class h_config;
    	uvm_analysis_port #(mcs_axi4_write_seq_item) h_cov_mon_port;


	bit [`DATA_BUS_WIDTH-1:0] awfixed_queue[$];      //unbounded queue for storing stating adress in fixed burst type
	int wdata_count ;			                	// count for wdata
	bit[`ADDR_BUS_WIDTH-1:0] start_address,aligned_address;
	int number_of_bytes;		//start_adress
    	int addr_queue[$];                                 //storing the starting address 
    	int trigger_count;
   	int Lower_Byte_Lane,Upper_Byte_Lane;
  	int wrap_boundary,no_of_bytes,burst_length,address_n;
	int Data_Bus_Bytes;
	int transfer_control_flag;
	bit [$clog2(`DATA_BUS_WIDTH)-2 :0] temp_wstrb;
	bit monitor_driver_control_flag;            //to control the driver

        enum {OKAY=0,EXOKAY=1,SLVERR=2,DECERR=3}response_type;      //enum type 


//***************************************************//
//***************build_phase*************************//
//***************************************************//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e_wready=uvm_event_pool::get_global("e_wready_ab");
		e_response_drive=uvm_event_pool::get_global("e_response_drive_ab");
		h_mcs_axi4_write_seq_item=mcs_axi4_write_seq_item::type_id::create("h_mcs_axi4_write_seq_item");
        h_cov_mon_port=new("h_cov_mon_port",this);
	endfunction

//***************************************************//
//***************connect_phase*************************//
//***************************************************//
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(!uvm_config_db #(virtual axi_intf)::get(null,this.get_full_name(),"axi_hintf",h_axi_intf))
			`uvm_fatal("mcs_axi4_project_write_active_monitor",$sformatf("getting axi_intf is failed"));



		if(!uvm_config_db #(config_class)::get(this,"","config",h_config))
			`uvm_fatal("DRIVER CONFIG","getting the config class signals in driver is failed")
	endfunction





	

//***************************************************//
//***************run_phase*************************//
//***************************************************//

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
            begin
                sampling();
                monitor_checks();
                triggering();
                wdata_storing;
            end

	endtask


task sampling;
		@(h_axi_intf.cb_monitor)//1
        	h_mcs_axi4_write_seq_item.ARESETn=h_axi_intf.pi_aresetn;
		h_mcs_axi4_write_seq_item.AWID=h_axi_intf.po4_awid;
		h_mcs_axi4_write_seq_item.AWADDR=h_axi_intf.po32_awaddr;
		h_mcs_axi4_write_seq_item.AWLEN=h_axi_intf.po8_awlen;
		h_mcs_axi4_write_seq_item.AWSIZE=h_axi_intf.po3_awsize;
		h_mcs_axi4_write_seq_item.AWBURST=h_axi_intf.po2_awburst;
		h_mcs_axi4_write_seq_item.AWVALID=h_axi_intf.cb_monitor.po_awvalid;
		h_mcs_axi4_write_seq_item.AWREADY=h_axi_intf.cb_monitor.pi_awready;
		h_mcs_axi4_write_seq_item.WDATA=h_axi_intf.po32_wdata;
		h_mcs_axi4_write_seq_item.WSTRB=h_axi_intf.po4_wstrb;
		h_mcs_axi4_write_seq_item.WLAST=h_axi_intf.po_wlast;
		h_mcs_axi4_write_seq_item.WVALID=h_axi_intf.po_wvalid;
		h_mcs_axi4_write_seq_item.WREADY=h_axi_intf.pi_wready;
		h_mcs_axi4_write_seq_item.BRESP=h_axi_intf.pi_bresp;
		h_mcs_axi4_write_seq_item.BID=h_axi_intf.pi4_bid;
		h_mcs_axi4_write_seq_item.BVALID=h_axi_intf.pi_bvalid;
		h_mcs_axi4_write_seq_item.BREADY=h_axi_intf.po_bready;


endtask




//===================== task for monitor checks=================================//

//================when the reset is low check for the awvalid and wvalid as 0,  uvm info is displayed==================//

	task monitor_checks;
		if(h_mcs_axi4_write_seq_item.ARESETn==0)  //rst=0
		begin
			if(h_mcs_axi4_write_seq_item.AWVALID==0 && h_mcs_axi4_write_seq_item.WVALID==0 )
		//	`uvm_report_info("WRITE_MONITOR",$sformatf("reset_check_pass"),UVM_NONE);
//			$display("reset check pass");
			`uvm_info("reset_pass",$sformatf("valid=%0d ready=%0d",h_mcs_axi4_write_seq_item.AWVALID,h_mcs_axi4_write_seq_item.WVALID),0)
		end

//==============if reset=1 check for the awvalid and awready as 1, go for the awid check==================//

		else
			 begin // rst=1 {
			//	`uvm_info("valid_ready_w_mon",$psprintf("\n seq int \n valid=%0d ready=%0d",h_mcs_axi4_write_seq_item.AWVALID,h_axi_intf.pi_awready),0)
			//	`uvm_info("valid_ready_w_mon",$psprintf("\nBOTH SEQ ITEM \n valid=%0d ready=%0d",h_mcs_axi4_write_seq_item.AWVALID,h_mcs_axi4_write_seq_item.AWREADY),0)
				if(h_mcs_axi4_write_seq_item.AWVALID==1 && h_mcs_axi4_write_seq_item.AWREADY==1)
				begin //{

//=============if awid is <16 it go to check for the awaddr=====================//

					if(h_mcs_axi4_write_seq_item.AWID<16)
					begin
						h_config.q_awid.push_back(h_mcs_axi4_write_seq_item.AWID);
						h_config.q_awaddr.push_back(h_mcs_axi4_write_seq_item.AWADDR);
						h_config.q_awlen.push_back(h_mcs_axi4_write_seq_item.AWLEN);
						h_config.q_awsize.push_back(h_mcs_axi4_write_seq_item.AWSIZE);
						h_config.q_awburst.push_back(h_mcs_axi4_write_seq_item.AWBURST);
                        `uvm_info("v1_r1_mon",$sformatf("\n h_config_db.q_awid=%p \n",h_config.q_awid),UVM_LOW)
						$display(h_config.q_awid);
					end
					else
					 begin //awid >15
					// when awid is greater than 16
                    `uvm_fatal("axi_write_monitor",$sformatf("awid is greater than 16"))
				     end

				end   //}
			
				else
				 begin
                        //uvm_report_info("valid and ready are not 1",500);
					//	$dipslay("valid and ready are not 1");
				end
		end //}
	endtask


//====================burst type selection==============================//
	task burst_type;
		start_address=h_mcs_axi4_write_seq_item.AWADDR; // start address is stored in the variable and pushed into the addr_queue based on the task call
		$display("-----------------------------burst_type=%0d--------- ",h_mcs_axi4_write_seq_item.AWBURST);
        h_config.print();
			case(h_mcs_axi4_write_seq_item.AWBURST)
				2'b00:fixed_task();
				2'b01:incr_task();
				2'b10:wrap_task(4);
		//	default : reserved_task();

			endcase
	endtask
//===================fixed burst type===============================//
//==========in order to store the address_n , it pushed into the queue
	task fixed_task;
        repeat(h_mcs_axi4_write_seq_item.AWLEN+1) begin
	//	$display("-----------------------------burst_type---------");

        //h_config_db.q_awaddr.push_back(h_mcs_axi4_write_seq_item.AWADDR);
            addr_queue.push_back(start_address);
            
        end
    endtask

//====================incr burst type====================================//
	task incr_task;
		start_address=h_mcs_axi4_write_seq_item.AWADDR;
		begin
			case(h_mcs_axi4_write_seq_item.AWSIZE)
				3'd0: begin aligned_unaligned_address_cal(1); end // 1 byte transfer narrow
				3'd1: begin aligned_unaligned_address_cal(2); end  // 2 byte transfer narrow
				3'd2: begin aligned_unaligned_address_cal(4);end // 4 byte transfer  narrow if databuswidth=64bit
				3'd3: begin aligned_unaligned_address_cal(8);end	 // 8 byte transfer maximum for the 32 bit transfer
                default begin `uvm_error("invalid_awsize_write_mon","") end
	    	endcase
        end
	endtask
//============aligned_unaligned address calculations
	task aligned_unaligned_address_cal(int no_of_bytes);
    int n=2;
		aligned_address=$floor(start_address/no_of_bytes)*no_of_bytes;
        addr_queue.push_back(start_address);

        repeat(h_mcs_axi4_write_seq_item.AWLEN) begin
            addr_queue.push_back(aligned_address+(n-1)*no_of_bytes);
            n++;
        end
            $display("addr_queue=%p \n in monitor",addr_queue);
	endtask
task wrap_task( int no_of_bytes=4);
            int address_count=1;
            addr_queue[0]=start_address;
            no_of_bytes=2**h_mcs_axi4_write_seq_item.AWSIZE;
            burst_length=h_mcs_axi4_write_seq_item.AWLEN+1;
        if(start_address%h_mcs_axi4_write_seq_item.AWSIZE==0  && h_mcs_axi4_write_seq_item.AWLEN+1==(2||4||8||16)) begin   //limitation for wrap , starting address must be aligned and length must be 2,4,8,16.
            wrap_boundary=$floor((start_address/(no_of_bytes*burst_length))* (no_of_bytes*burst_length)); // when the address reaches the maximum address then max_addr replaced by wrap_boundary
            address_n=wrap_boundary+(no_of_bytes*burst_length); // maximum address
            while(address_count<=h_mcs_axi4_write_seq_item.AWLEN) begin
                addr_queue[address_count]=addr_queue[address_count-1]+ no_of_bytes;
                address_count++;
    			if (addr_queue[address_count]==address_n) begin
           			addr_queue[address_count]=wrap_boundary;
		    	end
			else begin
				// normal address
			end
        end
        end
    endtask
//w
//strobe_calculations




task strobe_calc;
Data_Bus_Bytes=$clog2(`DATA_BUS_WIDTH)-1;
address_n=wrap_boundary+(no_of_bytes*burst_length);
no_of_bytes=2**h_mcs_axi4_write_seq_item.AWSIZE;
Lower_Byte_Lane = start_address - ( $floor ( start_address / Data_Bus_Bytes ))* Data_Bus_Bytes;
Upper_Byte_Lane = aligned_address + ( no_of_bytes - 1) -( $floor ( start_address / Data_Bus_Bytes )) *Data_Bus_Bytes ;

Lower_Byte_Lane = address_n - ( $floor ( address_n / Data_Bus_Bytes ))* Data_Bus_Bytes;
Upper_Byte_Lane = Lower_Byte_Lane + no_of_bytes - 1;

endtask

// based on the burst type calculate the strobe every time and compare with the incoming wstrobe and addr_queue fetch the address  do the update in the memory based on the   awid
    task wdata_storing;
        if(h_mcs_axi4_write_seq_item.WVALID==1 && h_mcs_axi4_write_seq_item.WREADY==1)
            begin
            //if(temp_wstrb==h_mcs_axi4_write_seq_item.WSTRB)
                //begin
                            strobe_data;
                            wlast_asserted;
                 //end
              end
 endtask

 task strobe_data;
        case(h_mcs_axi4_write_seq_item.WSTRB)
           4'b0001: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[7:0];end
           4'b0010: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[15:8];end
           4'b0100: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[23:16];end
           4'b1000: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[31:24];end
           4'b0011: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[15:0];end
           4'b1100: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[23:0];end
           4'b0111: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[31:24];end
           4'b1111: begin h_config.write_mem[addr_queue.pop_front]=h_mcs_axi4_write_seq_item.WDATA[31:0];end
        endcase
 endtask


task wlast_asserted;
$display("wlast ----------------------------------------------------");
        if(addr_queue.size()==0)
            begin
                if(h_mcs_axi4_write_seq_item.WLAST)
                    begin
                        //okay response_triggered;
                        h_config.resp=0;
                       e_response_drive.trigger;
                    end
                 else begin
                        h_config.resp=2;
                       e_response_drive.trigger;
                        //slaverr triggered;
                     end
            end
            else begin
                  //  wdata_count++;
                   end
endtask










//strobe_calculations
/*	task strobe_calc1(int no_of_bytes);
	int Data_Bus_Bytes;
        wrap_boundary=$floor((start_address/(no_of_bytes*burst_length))* (no_of_bytes*burst_length)); // when the address reaches the maximum address then max_addr replaced by wrap_boundary
		Data_Bus_Bytes=$clog2(`DATA_BUS_WIDTH)-1;
			no_of_bytes=2**h_mcs_axi4_write_seq_item.AWSIZE;
		// for 1st address strobe calculations
		Lower_Byte_Lane = start_address - ( $floor ( start_address / Data_Bus_Bytes ))* Data_Bus_Bytes;
		Upper_Byte_Lane = aligned_address + ( no_of_bytes - 1) -( $floor ( start_address / Data_Bus_Bytes )) * Data_Bus_Bytes ;
		wstrb_cal(Upper_Byte_Lane,Lower_Byte_Lane);
		// data to consider	wdata[(8*Upper_Byte_Lane)+7:(8*Lower_Byte_Lane)]; 31:0 >> 1111 7:0 >> 0001   
		//temp_wstrb=;
	endtask

	task  wstrb_cal(int UBL,LBL);
//	if (UBL==3) begin
			// update strobe with the msb as 1
            case(UBL)
            3: begin wstrb_cal2(LBL); end
            endcase
	
//	end
	endtask //*/


    /*task wstrb_cal2(int LBL);
			case(LBL)
				0: begin
					temp_wstrb=4'b1111;
				end
				1:begin
					temp_wstrb=4'b1110;
				end
				2:begin
					temp_wstrb=4'b1100;
				end
				3:begin
					temp_wstrb=4'b1000;
				end

			endcase		
    endtask


	task  strobe_cal2();
		// for remaining addresses calculating the strobe values
		Lower_Byte_Lane = address_n - ( $floor ( address_n / Data_Bus_Bytes ))* Data_Bus_Bytes;
		Upper_Byte_Lane = Lower_Byte_Lane + no_of_bytes - 1;
		// data to consider	wdata[(8*Upper_Byte_Lane)+7:(8*Lower_Byte_Lane)];
		wstrb_cal(Upper_Byte_Lane,Lower_Byte_Lane);
	endtask */

task triggering;
//	`uvm_info("before_triggering_w_mon","",0)
`uvm_info("before_trg",$sformatf("h_config.q_awid.size=%0d",h_config.q_awid.size),0)
	if(h_config.q_awid.size() > 0 && transfer_control_flag == 0)  // when the queue is not empty and transfer_control_flag is not 1
        begin
		`uvm_info("after_triggering_w_mon","",0)
            transfer_control_flag=1;
			burst_type();  // calling this task inorder to calculate the addresses  for the upcoming transfers 
            e_wready.trigger;    // triggering the event in driver inorder to send he wready whenever the data is available on the write data channel
            //$display("---------------------------------wmon");

        end
    else begin end // not trigerring the driver

endtask









 endclass
