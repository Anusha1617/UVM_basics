
 	class mcs_axi4_write_driver extends uvm_driver #(mcs_axi4_write_seq_item) ;
 	`uvm_component_utils(mcs_axi4_write_driver)

	//interface declaration
	virtual axi_intf h_intf;

	//config class declaration
	config_class h_config;
	bit[$clog2(`NO_OF_IDS)-1:0]bid;


	//event declaration
	uvm_event e_wready;
	uvm_event e_response_drive;

	// Constructor
	function new(string name="",uvm_component parent);
		super.new(name,parent);
	endfunction


	//connect_phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(!uvm_config_db #(virtual axi_intf)::get(this,"","axi_hintf",h_intf))
			`uvm_fatal("DRIVER INTF","getting the interface signals in driver is failed")

		if(!uvm_config_db #(config_class)::get(this,"","config",h_config))
			`uvm_fatal("DRIVER CONFIG","getting the config class signals in driver is failed")
	endfunction



//run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		e_wready=uvm_event_pool::get_global("e_wready_ab");
		e_response_drive=uvm_event_pool::get_global("e_response_drive_ab");
	fork
 		forever @(h_intf.cb_driver)
		begin
		seq_item_port.get_next_item(req);
		    awready_drive();
		seq_item_port.item_done();
		end
        begin
            e_wready.wait_trigger();
            wready_drive;
        end


        begin
            e_response_drive.wait_trigger();
            response_drive();
        end
join
	endtask


//task for driving awready
	task awready_drive();
    repeat(100) begin
        if(h_intf.po_awvalid==1) 
		    begin
		    	h_intf.pi_awready<=1;
                // triigger the another task or event
                @(posedge h_intf.pi_aclk);   
		    	h_intf.pi_awready<=0;
                break;
		    end
        else 
            begin
                    @(h_intf.cb_driver); // clock pulse delay
            end
    end
	endtask

//task for driving wready
	task wready_drive();
    begin
    `uvm_info("drv_trg_wvalid","",0)
    h_config.print();
    repeat(h_config.q_awlen[0]+1) begin//{
    	    //`uvm_info("drv_2nd_trg_wvalid","",0)
	repeat(100)
    if(h_intf.po_wvalid)
		begin
    		h_intf.pi_wready<=1;
            	@(h_intf.cb_driver);
    		h_intf.pi_wready<=0;
            break;
		end
    else
        begin
            @(h_intf.cb_driver);
        end
        end
    end//}
    response_drive();
	endtask


//task for response drive
	task response_drive();
		//`uvm_info("drv_config_bid","",0)
		h_config.print();

		//bid=h_config.q_awid.pop_front();
		//`uvm_info("drv_bid_value",$sformatf(".bid=%d",bid),0)
		$display("h_config.q_awid[0]=%0d",h_config.q_awid[0]);
		h_intf.cb_driver.pi4_bid<=h_config.q_awid[0];

		h_intf.cb_driver.pi2_rresp<=h_config.resp;
		if(h_intf.po_wvalid && h_intf.pi_wready) begin//{
        repeat(100) begin//{
            		h_intf.pi_bvalid <=1;
                    if(h_intf.po_bready)
                        begin //{
                            @(h_intf.cb_driver);
            		        h_intf.pi_bvalid <=0;
            		        break;
                        end///}
                    else begin//{
                            @(h_intf.cb_driver);
                        end//}
        end//}
        end//}
		else
			h_intf.pi_bvalid <=0;
					h_config.q_awid.pop_front();
	endtask
 endclass
