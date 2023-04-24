class Host_Seq2 extends uvm_sequence #(Host_Seq_item);

	//===FACTORY REGISTRATION===//
	`uvm_object_utils(Host_Seq2)
	Config_class h_config;

	int unsigned offset,offset_p_4,accumulated_length;
	
	enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;

	rand enum {h_length=100,dh_length=200,med_length=800}payload_length;
	//===CONSTRUCTOR====//
	function new(string name ="Host_Seq2");
		super.new(name);
	endfunction


task pre_body();
	h_config=Config_class::type_id::create("h_config");
	uvm_config_db #(Config_class) :: get(null,"","config_class",h_config);
	req=Host_Seq_item::type_id::create("req");
endtask

	task body();

	 INT_O_CONFIGURATION();
	 	 END_CONFIGURATION();
	endtask
	

	task INT_O_CONFIGURATION();
	int i=0;

	repeat(h_config.TX_BD_NUM) begin

			if(h_config.IRQ[i]) begin 			
				start_item(req);
								`uvm_info("HS2",$sformatf("h_config.TX_BD_NUM=%0d IRQ=%p",h_config.TX_BD_NUM,h_config.IRQ),UVM_NONE)
					assert (req.randomize() with {psel_i==1; paddr_i==INT_SOURCE;   pwdata_i==32'hf;  }) 
				finish_item(req);
				i++;
			end
			else 
			begin 
				i++;
			end
			end
	endtask	
	



	task END_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==0;  paddr_i==0;   penable_i==0; pwdata_i==10;  }) 
			finish_item(req);
	endtask		
		
task READ();
			repeat(9) begin
			start_item(req);
			Reg_addr=Reg_addr.next();
			$display($time,"Reg_addr=%s ",Reg_addr);
			assert (req.randomize() with {paddr_i==Reg_addr;   pwrite_i==0; pwdata_i==0;  }) 
			//$display("req.pwrite=%0d ",req.pwrite_i);			
			finish_item(req);
			end
	endtask	
	


endclass
