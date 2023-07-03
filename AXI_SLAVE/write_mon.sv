//*****************************************************//
//*******************write_active_monitor*********************//
//******************************************************//

class mcs_axi4_project_write_active_monitor extends uvm_monitor;
`uvm_component_utils(mcs_axi4_project_write_active_monitor)         //factory registration
// Constructor
	function new(string name="",uvm_component parent);
	super.new(name,parent);
	endfunction


//declarations of interface,sequence_item and config_class
	axi_intf h_axi_intf;
	mcs_axi_project_write_seq_item h_write_seq_item;
    axi_config_class h_config_class;
    uvm_analysis_port #(mcs_axi_project_write_seq_item) h_cov_mon_port;


//---------------
	bit [`DATA_BUS_WIDTH-1:0] awfixed_queue[$];      //unbounded queue for storing stating adress in fixed burst type
	int wdata_count ;			                	// count for wdata
	int start_address,aligned_address,number_of_bytes;		//start_adress
    int addr_queue;                                 //storing the starting address 
    int trigger_count;
    int Lower_Byte_Lane,Upper_Byte_Lane;
     int wrap_boundary,no_of_bytes,burst_length,address_n;




//***************************************************//
//***************build_phase*************************//
//***************************************************//

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_write_seq_item=mcs_axi_project_write_seq_item::type_id::create("h_write_seq_item");
        h_cov_mon_port=new("h_cov_mon_port",this);
	endfunction

//***************************************************//
//***************connect_phase*************************//
//***************************************************//
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(!uvm_config_db #(virtual axi_intf)::get(null,this.get_full_name(),"virtual_axi_intf",h_axi_intf))
			`uvm_fatal("mcs_axi4_project_write_active_monitor",$sformatf("getting axi_intf is failed"));
	endfunction

//***************************************************//
//***************run_phase*************************//
//***************************************************//

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin @(h_axi_intf.cb_monitor)//1
		h_write_seq_item.ARESETn=h_axi_intf.pi_aresetn;
		h_write_seq_item.AWID=h_axi_intf.po4_awid;
		h_write_seq_item.AWADDR=h_axi_intf.po32_awaddr;
		h_write_seq_item.AWLEN=h_axi_intf.po8_awlen;
		h_write_seq_item.AWSIZE=h_axi_intf.po3_awsize;
		h_write_seq_item.AWBURST=h_axi_intf.po2_awburst;
		h_write_seq_item.AWVALID=h_axi_intf.po_awvalid;
		h_write_seq_item.AWREADY=h_axi_intf.pi_awready;
		h_write_seq_item.WDATA=h_axi_intf.po32_wdata;
		h_write_seq_item.WSTRB=h_axi_intf.po4_wstrb;
		h_write_seq_item.WLAST=h_axi_intf.po_wlast;
		h_write_seq_item.WVALID=h_axi_intf.po_wvalid;
		h_write_seq_item.WREADY=h_axi_intf.pi_wready;
		h_write_seq_item.BRESP=h_axi_intf.pi_bresp;
		h_write_seq_item.BID=h_axi_intf.pi4_bid;
		h_write_seq_item.BVALID=h_axi_intf.pi_bvalid;
		h_write_seq_item.BREADY=h_axi_intf.po_bready;
        h_cov_mon_port.write(h_write_seq_item);
        fork
               monitor_checks();
               // burst_type();
        join
                triggering();
                data_update;
		end //1
	endtask


//===================== task for monitor checks=================================//

//================when the reset is low check for the awvalid and wvalid as 0,  uvm info is displayed==================//

	task monitor_checks;
		if(h_write_seq_item.ARESETn==0)  //rst=0
		begin
			if(h_write_seq_item.AWVALID=0 && h_write_seq_item.WVALID==0 )
			`uvm_report_info("WRITE_MONITOR",$sformatf("reset_check_pass"),UVM_NONE);
		end

//==============if reset=1 check for the awvalid and awready as 1, go for the awid check==================//

		else begin // rst=1
			if(h_write_seq_item.AWVALID==1 && h_write_seq_item.AWREADY==1);
			begin

//=============if awid is <16 it go to check for the awaddr=====================//

				if(h_write_seq_item.AWID<16)
				begin
					h_config_db.q_awid.push_back(h_write_seq_item.AWID);
					h_config_db.q_awaddr.push_back(h_write_seq_item.AWADDR);
					h_config_db.q_awlen.push_back(h_write_seq_item.AWLEN);
					h_config_db.q_awsize.push_back(h_write_seq_item.AWSIZE);
					h_config_db.q_awburst.push_back(h_write_seq_item.AWBURST);
                    trigger_count++; // to count no of bursts
                    burst_type();
				end
				else begin //awid >15
					// when awid is greater than 16
                    `uvm_fatal("axi_write_monitor",$sformatf("awid is greater than 16"))
				end

			end
			else begin
                        uvm_report_info("valid and ready are not 1",500);
			end
		end
	endtask


//====================burst type selection==============================//
	task burst_type;
			case(h_write_seq_item.AWBURST)
				2'b00:fixed_task();
				2'b01:incr_task();
				2'b10:wrap_task();
			default : reserved_task();

			endcase
	endtask
//===================fixed burst type===============================//
//==========in order to store the address_n , it pushed into the queue
	task fixed_task;
        repeat(h_write_seq_item.AWLEN) begin
        //h_config_db.q_awaddr.push_back(h_write_seq_item.AWADDR);
            addr_queue.push_back(h_write_seq_item.AWADDR);
        end
    endtask
    /*
//repeat(h_write_seq_item.AWLEN) begin		
//awfixed_queue.push_back(h_write_seq_item.WDATA); 
//end
			wdata_count++;
			if(wdata_count==(h_config_db.q_awlen+1) )
			begin
				if( h_write_seq_item.WLAST)
				begin
					//bresp triggered
                    h_config_db.q_bresp.push_back(0); //  OKAY
				end
				else begin
					`uvm_error("wlast_is_not_asserted",$sformatf("write_monitor"));
					//bresp triggered
				end
			end
			else
			begin
				wdata_count++;
			end
		end
	endtask
    */
//====================incr burst type====================================//
	task incr_task;
		start_address=h_write_seq_item.AWADDR;
		begin
			case(h_write_seq_item.AWSIZE)
				3'd0: begin aligned_unaligned_address_cal(1); end // 1 byte transfer narrow
				3'd1: begin aligned_unaligned_address_cal(2); end  // 2 byte transfer narrow
				3'd2: begin aligned_unaligned_address_cal(4);end // 4 byte transfer  narrow if databuswidth=64bit
				3'd3: begin aligned_unaligned_address_cal(8);end	 // 8 byte transfer maximum for the 32 bit transfer
                default begin `uvm_error("invalid_awsize_write_mon","") end
	    	endcase
        end
	endtask
//============aligned_unaligned address calculations
	task aligned_unaligned_address_cal(int bytes);
    int n;
		aligned_address=$floor(start_address/bytes)*bytes;
        addr_queue.push_back(start_address);

        repeat(h_write_seq_item.AWLEN+1) begin
            addr_queue.push_back(aligned_address+(n-1)bytes);
            n++;
        end
            $display("addr_queue=%p \n in monitor",addr_queue);
	endtask
//wrap calculations-----------
    task wrap_task();
         no_of_bytes=2**h_write_seq_item.AWSIZE;
        burst_length=h_write_seq_item.AWLEN+1;
        wrap_boundary=$floor((start_address/(no_of_bytes*burst_length))* (no_of_bytes*burst_length));
        address_n=wrap_boundary+(no_of_bytes*burst_length);
        address_n=wrap_boundary;
    endtask

//strobe_calculations

task strobe_calc;
Data_Bus_Bytes=$clog2(`DATA_BUS_WIDTH)-1;
address_n=wrap_boundary+(no_of_bytes*burst_length);
no_of_bytes=2**h_write_seq_item.AWSIZE;
Lower_Byte_Lane = start_address - ( $floor ( start_address / Data_Bus_Bytes ))x Data_Bus_Bytes;
Upper_Byte_Lane = aligned_address + ( no_of_bytes - 1) -( $floor ( start_address / Data_Bus_Bytes )) x Data_Bus_Bytes ;
Lower_Byte_Lane = address_n - ( $floor ( address_n / Data_Bus_Bytes ))x Data_Bus_Bytes;
Upper_Byte_Lane = Lower_Byte_Lane + no_of_bytes - 1;

endtask

	task data_update;
        if(h)

	endtask






task triggering;
    if(trigger_count>0 && transfer_control_flag=0)
        begin
            transfer_control_flag=1;
            e_wready.trigger;
        end
    else begin end // not trigerring the driver
endtask


endclass
