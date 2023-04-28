
class Host_Seq1 extends uvm_sequence #(Host_Seq_item);
	//===FACTORY REGISTRATION===//
	`uvm_object_utils(Host_Seq1)
	Config_class h_config;

	int unsigned offset,accumulated_length;

// Number of TX_BD_NUMs
    bit [16]NO_OF_TX_BDs;

//INT_MASK bits fields    like al
    bit RXE_M=1,RXF_M=1,TXE_M=1,TXB_M=1;

//INT_SOURCE              CLEAR it by making it as 1
    bit RXE=1,RXB=1,TXE=1,TXB=1;

//MODER fields 
    bit  PAD=0,HUGEN=0,FULLD=0,LOOPBCK=0,IFG=0,PRO=0,BRO=0,NOPRE=0,TXEN=1,RXEN=0;	

    enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;



	//===CONSTRUCTOR====//
	function new(string name ="Host_Seq1");
		super.new(name);
	endfunction


task pre_body();
	h_config=Config_class::type_id::create("h_config");
	uvm_config_db #(Config_class) :: get(null,"","config_class",h_config);
	req=Host_Seq_item::type_id::create("req");
		NO_OF_TX_BDs=$urandom_range(1,128);  // randomizing the number of BD's
endtask

	task body();
//	 RESET();   // check n keep
	 MODER_CONFIGURATION(PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,0,RXEN);		// Making TXEN==0 at the starting of the configuration
	 MAC_ADDR0_CONFIGURATION();
	 MAC_ADDR1_CONFIGURATION();	 
	 MIIADDRESS_CONFIGURATION();
	 TX_BD_NUM_CONFIGURATION(NO_OF_TX_BDs); // randomizing NO_OF_TX_BDs number in pre body
	 TXBDs_CONFIGURATION();
	 INT_MASK_CONFIGURATION(RXE_M,RXF_M,TXE_M,TXB_M);	
	 INT_SOURCE_CONFIGURATION(RXE,RXB,TXE,TXB);
	 MODER_CONFIGURATION(PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,TXEN,RXEN);		
	//	READ();
	 END_CONFIGURATION();
	 accumulated_length=0;
	 offset=0;
	endtask
	
	    task RESET();
		start_item(req);
			assert (req.randomize() with {prstn_i==0; } )
		finish_item(req);	
	endtask
	
	
    task TX_BD_NUM_CONFIGURATION(bit[31:0] data=128);
		start_item(req);
			assert (req.randomize() with {pwdata_i==data; paddr_i==TX_BD_NUM;} )
		finish_item(req);	
	endtask
	
	task MAC_ADDR0_CONFIGURATION(byte two='h0,three='h0,four='hab,five='hcd);  // SA 23 45
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR0; pwdata_i=={two,three,four,five}; })
			finish_item(req);	
	endtask	
	
	task MAC_ADDR1_CONFIGURATION(byte zero='h0,one='h0);
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR1; pwdata_i=={16'b0,zero,one};})
			finish_item(req);
	endtask	
	
	task MIIADDRESS_CONFIGURATION(bit [4:0]FIAD=5'hc);	
			start_item(req);
			assert (req.randomize() with {paddr_i==MIIADDRESS;  pwdata_i=={27'b0,FIAD};  })
			finish_item(req);
	endtask	
	
	
	task TXBDs_offset( bit[15:0] LEN=100, bit RD=1,IRQ=0);
    int rem;
			start_item(req);
//			$display("======================================================================seq in host   LEN=%0d",LEN);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i[15:0]=={RD,IRQ,14'b0};});   // random data is going			
			offset++;
			`uvm_info (get_type_name (), $sformatf ("\n\t\t\t\t\t^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^paddr_i=%h  offset =%0d ",req.paddr_i,offset), UVM_NONE)
			finish_item(req);						
			TXBDs_offset_p_4(accumulated_length);	
            if(LEN%4==0)
                		
			accumulated_length=accumulated_length+(LEN)+4;
            else 
                begin
                rem=LEN%4;
			accumulated_length=accumulated_length+(LEN+(4-rem)+4);
            end
	endtask
	
	task TXBDs_offset_p_4( bit[31:0] TXPNT=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i==TXPNT;  });   // random data is going			
			offset++;
			finish_item(req);	
	endtask	
	
	
	task TXBDs_CONFIGURATION();	
		`uvm_info("HOST SEQ TX BD Configuration ",$sformatf("\n\n\t\t\t\t\tTXBDNUM=%0d \n\n",h_config.TX_BD_NUM),UVM_LOW)
		repeat(h_config.TX_BD_NUM)
		begin 	
			TXBDs_offset(,1,1);		//------------------------------------------------//	
		end			
	endtask	

	task INT_MASK_CONFIGURATION(bit RXE_M=1,RXF_M=1,TXE_M=1,TXB_M=1);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_MASK; pwdata_i=={28'b0,RXE_M,RXF_M,TXE_M,TXB_M}; })
			finish_item(req);
	endtask	
	
	task INT_SOURCE_CONFIGURATION(bit RXE=1,RXB=1,TXE=1,TXB=1);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_SOURCE; pwdata_i=={28'b0,RXE,RXB,TXE,TXB}; })
			finish_item(req);
	endtask	
	task MODER_CONFIGURATION(bit  PAD=1,HUGEN=0,FULLD=0,LOOPBCK=0,IFG=0,PRO=0,BRO=0,NOPRE=0,TXEN=1,RXEN=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==MODER; pwdata_i=={16'b0,PAD,HUGEN,3'b0,FULLD,2'b0,LOOPBCK,IFG,PRO,1'b0,BRO,NOPRE,TXEN,RXEN};});
			finish_item(req);
	endtask
	
	
	task END_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==0;  paddr_i==0;   penable_i==0; pwdata_i==0;  }) 
			finish_item(req);
	endtask	
	
		
    task READ();
			repeat(9) begin
			start_item(req);
		    	Reg_addr=Reg_addr.next();
		    	$display($time,"\t\t\t\t\t Reading Reg_addr=%s ",Reg_addr);
		    	assert (req.randomize() with {paddr_i==Reg_addr;   pwrite_i==0; pwdata_i==0;  }) 
			finish_item(req);
			end
	endtask	
	


endclass

