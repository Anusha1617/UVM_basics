class Host_Driver extends uvm_driver #(Host_Seq_item);
	`uvm_component_utils(Host_Driver)

	virtual Ethernet_APB_interface vintf;  // virtual  interface 
	enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;
    int z;

    Config_class h_config;
	function new(string name="",uvm_component parent);  // constructor
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);  
		super.build_phase(phase);
		if(!uvm_config_db #(virtual Ethernet_APB_interface)::get(this,"","virtual_apb_intf",vintf)) // getting the interface from top
			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))
			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));			
	endfunction

	task run_phase(uvm_phase phase);  
		super.run_phase(phase);
		fork
			//drive_int_source;
			drive;
		join
	endtask
	
	task drive;
	//-------------- IDLE state or RESET state ---------------------//
		@(vintf.host_cb_driver)
			vintf.host_cb_driver.penable_i<=0;
			vintf.host_cb_driver.psel_i<=0;
			vintf.host_cb_driver.pwrite_i<=0;
			vintf.host_cb_driver.pwdata_i<=0;
			vintf.host_cb_driver.paddr_i<=0;
			task_reset;
		forever begin @(vintf.host_cb_driver)
//		if(vintf.int_o)
		seq_item_port.get_next_item(req);	//randomisation takes place
			vintf.host_cb_driver.prstn_i<=1;
			vintf.host_cb_driver.psel_i<=req.psel_i;		//Setup stae s=1 e=0
			vintf.host_cb_driver.penable_i<=0;			
			vintf.host_cb_driver.pwrite_i<=req.pwrite_i;
			vintf.host_cb_driver.paddr_i<=req.paddr_i;
			vintf.host_cb_driver.pwdata_i<=req.pwdata_i;
			
			@(vintf.host_cb_driver);		//access state  s=1 e=1
			vintf.host_cb_driver.penable_i<=1;
			
            if(vintf.psel_i) 
			begin
				wait(vintf.pready_o);
					task_write;        
                   //  if(vintf.paddr_i>=400)
			@(vintf.host_cb_driver);		//acess state  s=1 e=1						
		  //	vintf.host_cb_driver.penable_i<=0;
			
			 end         
		seq_item_port.item_done();
	end
	endtask
	
    task drive_int_source;
    forever begin
    //@(vintf.host_cb_driver)
    		 wait(vintf.int_o==1)
    		seq_item_port.get_next_item(req);	//randomisation takes place
    @(vintf.host_cb_driver)
     		 
    			vintf.host_cb_driver.prstn_i<=1;
    			vintf.host_cb_driver.psel_i<=1;		//Setup stae s=1 e=0
    			vintf.host_cb_driver.penable_i<=0;			
    			vintf.host_cb_driver.pwrite_i<=1;
    			vintf.host_cb_driver.paddr_i<='h04;
    			vintf.host_cb_driver.pwdata_i<=req.pwdata_i;
    			
    			@(vintf.host_cb_driver);		//access state  s=1 e=1
    			vintf.host_cb_driver.penable_i<=1;
    			
    				wait(vintf.pready_o);
    				                            @(vintf.host_cb_driver);		//acess state  s=1 e=1						
    			vintf.host_cb_driver.psel_i<=0;		//Setup stae s=1 e=0
    			vintf.host_cb_driver.penable_i<=0;						
    		
    		seq_item_port.item_done();
    end
    			
    endtask	
	
	
	

    task task_reset;
    	if(!vintf.prstn_i) // reset_n==0 active low reset
    		  begin  
    	    		`uvm_info("Driving RESET","",UVM_NONE)
    	    		h_config.default_values;  // setting the default register values
    		   end
    endtask 



    task task_write;  // sel=1  and reset=1  pwrite_i=1
    if(vintf.psel_i && vintf.pwrite_i) begin
     case(vintf.paddr_i)
        MODER      : begin    h_config.MODER=vintf.pwdata_i; 
                              h_config.HUGEN=h_config.MODER[14];
                              h_config.PAD=h_config.MODER[15];
                            $display("configuring MODER  TXEN=%0d PAD=%0d HUGEN=%0d ",h_config.MODER[0],h_config.PAD,h_config.HUGEN);
                      end 
        INT_SOURCE : begin    h_config.INT_SOURCE=vintf.pwdata_i; $display("Configured INT_SOURCE"); end
        INT_MASK   : begin    h_config.INT_MASK=vintf.pwdata_i; $display("Configured INT_MASK");     end
        TX_BD_NUM  : begin    h_config.TX_BD_NUM=vintf.pwdata_i; $display("Configured TX_BD_NUM");   end
        MAC_ADDR0  : begin    h_config.MAC_ADDR0=vintf.pwdata_i;  $display("Configured MAC_ADDR0");  end
        MAC_ADDR1  : begin    h_config.MAC_ADDR1=vintf.pwdata_i;   $display("Configured MAC_ADDR1"); end
        MIIADDRESS : begin    h_config.MIIADDRESS=vintf.pwdata_i;  $display("Configured MIIADDRESS");end
        default    : begin    h_config.BD_memory[vintf.paddr_i]=vintf.pwdata_i;   
                               $display("configuring the TXBDS");
                                                                     task_update; 
                                                end
                                            endcase
    end
    endtask
    
    task task_update;
           if(vintf.paddr_i%8==0)
               begin
                    h_config.LEN.push_back(vintf.pwdata_i[31:16]);
                    h_config.RD.push_back(vintf.pwdata_i[15]);
                    h_config.IRQ.push_back(vintf.pwdata_i[14]);
                    $display("LEN=%p \n RD=%p \n IRQ=%p",h_config.LEN,h_config.RD,h_config.IRQ);
               end 
               else if(vintf.paddr_i%4==0)
                   begin
                   h_config.TXPNT.push_back(vintf.pwdata_i);
                   end
    endtask
endclass
