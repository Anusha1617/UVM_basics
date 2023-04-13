class Host_Seq extends uvm_sequence #(Host_Seq_item);

	//===FACTORY REGISTRATION===//
	`uvm_object_utils(Host_Seq)
	Config_class h_config;

	int unsigned offset,offset_p_4,accumulated_length;
	
	enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;


	rand enum {lt_mini_length=0,mini_length=4,threshold_length=46,h_length=100,dh_length=200,med_length=800,max_length=1500,lt_huge_length=2001,huge_length=2006,gt_huge_length=2023}payload_length;


	//===CONSTRUCTOR====//
	function new(string name ="Host_Seq");
		super.new(name);
	endfunction

	task body();
	req=Host_Seq_item::type_id::create("req");
	h_config=Config_class::type_id::create("h_config");
	uvm_config_db #(Config_class) :: get(null,"","config_class",h_config);
	 MAC_ADDR0_CONFIGURATION('hff,'hff,'hff,'hff);
	 MAC_ADDR1_CONFIGURATION();	 
	 MIIADDRESS_CONFIGURATION();
	 TX_BD_NUM_CONFIGURATION(64);
	 TXBDs_CONFIGURATION();
	 INT_MASK_CONFIGURATION();	
	 INT_SOURCE_CONFIGURATION();
	 MODER_CONFIGURATION(,,,,,,,,1,0);		
	 END_CONFIGURATION();
	 			
//	task MODER_CONFIGURATION(bit  PAD=1,HUGEN=0,FULLD=0,LOOPBCK=0,IFG=0,PRO=0,BRO=0,NOPRE=0,TXEN=1,RXEN=0);
	endtask
	
	task TX_BD_NUM_CONFIGURATION(bit[31:0] data=128);
		start_item(req);
			assert (req.randomize() with {pwdata_i==data; paddr_i==TX_BD_NUM;} )
		finish_item(req);	
	endtask
	
	task MAC_ADDR0_CONFIGURATION(byte two='hff,three='hff,four='hff,five='hff);  // SA 23 45
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR0; pwdata_i=={two,three,four,five}; })
			finish_item(req);	
	endtask	
	
	task MAC_ADDR1_CONFIGURATION(byte zero='hff,one='hff);
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR1; pwdata_i=={16'b0,zero,one};})
			finish_item(req);
	endtask	
	
	task MIIADDRESS_CONFIGURATION(bit [4:0]FIAD=5'b111_11);	
			start_item(req);
			assert (req.randomize() with {paddr_i==MIIADDRESS;  pwdata_i=={27'b0,FIAD};  })
			finish_item(req);
	endtask	
	
	
	task TXBDs_offset( bit[15:0] LEN=100, bit RD=0,IRQ=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i=={LEN,RD,IRQ,14'b0};});   // random data is going			
			accumulated_length=accumulated_length+LEN;
			offset++;
			finish_item(req);						
	endtask
	
	task TXBDs_offset_p_4( bit[32] TXPNT=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i==TXPNT;  });   // random data is going			
			offset++;
			finish_item(req);	
	endtask	
	
	
	task TXBDs_CONFIGURATION();	
		`uvm_info("HOST SEQ ",$sformatf("\n\n\t\t\t\t\tTXBDNUM=%0d addr=%0d\n\n",h_config.TX_BD_NUM,h_config),UVM_LOW)
		
		repeat(h_config.TX_BD_NUM)
		begin 	

			payload_length=payload_length.next();
			TXBDs_offset(payload_length,1,1);
			TXBDs_offset_p_4(accumulated_length);			
			
		end			
	endtask	

	task INT_MASK_CONFIGURATION(bit RXE_M=1,RXF_M=1,TXE_M=1,TXB_M=1);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_MASK; pwdata_i=={28'b0,RXE_M,RXF_M,TXE_M,TXB_M}; })
			finish_item(req);
	endtask	
	
	task INT_SOURCE_CONFIGURATION(bit RXE=0,RXB=0,TXE=0,TXB=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_SOURCE; pwdata_i=={28'b0,RXE,RXB,TXE,TXB}; })
			finish_item(req);
	endtask	
	task MODER_CONFIGURATION(bit  PAD=1,HUGEN=0,FULLD=0,LOOPBCK=0,IFG=0,PRO=0,BRO=0,NOPRE=0,TXEN=1,RXEN=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==MODER;}) 
			finish_item(req);
	endtask
	
	
	task END_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==0;  paddr_i==0;      }) 
			finish_item(req);
	endtask	
	
		

endclass
