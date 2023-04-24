class Host_Seq extends uvm_sequence #(Host_Seq_item);

	//===FACTORY REGISTRATION===//
	`uvm_object_utils(Host_Seq)
	Config_class h_config;

	int unsigned offset,offset_p_4,accumulated_length;
	
//	enum {h_lngth='d46,h_legth='d100,h_length='d200,med_length='d800,huge_length='d1500}payload_lengh;
//	enum {h_lngth='d46,h_legth='d100,h_length='d200,med_length='d800,huge_length='d1500}payload;
	enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;

    typedef enum {a=46,b=47,c=48,d=500,e=800,f=1000,g=1300,h=1500}ndt;
    ndt basava,payload_lengh;


bit [47:0]SA=48'h0000_0000_abcd;
bit [47:0]DA=48'h_0c00_0000_0000;
bit [50]LENGTH=48;
	//===CONSTRUCTOR====//
	function new(string name ="Host_Seq");
		super.new(name);
	endfunction


task pre_body();
	h_config=Config_class::type_id::create("h_config");
	uvm_config_db #(Config_class) :: get(null,"","config_class",h_config);
	req=Host_Seq_item::type_id::create("req");
endtask

	task body();
	 MAC_ADDR0_CONFIGURATION();
	 MAC_ADDR1_CONFIGURATION();	 
	 MIIADDRESS_CONFIGURATION();
	 TX_BD_NUM_CONFIGURATION(10);
	 TXBDs_CONFIGURATION();
	 INT_MASK_CONFIGURATION();	
	 INT_SOURCE_CONFIGURATION();
	 MODER_CONFIGURATION();		
	//	READ();
	 END_CONFIGURATION();
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
			$display("======================================================================seq in host   LEN=%0d",LEN);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i=={LEN,RD,IRQ,14'b0};});   // random data is going			
			offset++;
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
		`uvm_info("HOST SEQ ",$sformatf("\n\n\t\t\t\t\tTXBDNUM=%0d addr=%0d  LEN=%p \n\n",h_config.TX_BD_NUM,h_config,h_config.LEN),UVM_LOW)
		
        payload_lengh=payload_lengh.first();
		repeat(h_config.TX_BD_NUM)
		begin 	
		//	$display($time,"-------------------------------------------------------------------Reg_addr=%s ",Reg_addr);
			//$display($time,"-------------------------------------------------------------------payload_lengh=%d ",payload_lengh);
			TXBDs_offset(payload_lengh,1,1);		//------------------------------------------------//	
            payload_lengh=payload_lengh.next();
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
			assert (req.randomize() with {paddr_i==MODER; pwdata_i==32'd2;}/*{16'b0,PAD,HUGEN,3'b0,FULLD,2'b0,LOOPBCK,IFG,PRO,1'b0,BRO,NOPRE,TXEN,RXEN};}*/);
			//$display("MODER in SEQ = PAD=%0d \n HUGEN=%0d \n FULLD=%0d \n LOOPBCK=%0d \n IFG=%0d \n PRO=%0d \n BRO=%0d \n NOPRE=%0d \n TXEN=%0d \n RXEN=%0d \n",PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,TXEN,RXEN);
			finish_item(req);
	endtask
	
	
	task END_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==0;  paddr_i==0;   penable_i==0; pwdata_i==10;  }) 
			finish_item(req);
	endtask	
	
		
	task INT_O_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==1; paddr_i==INT_SOURCE;   pwdata_i==32'hf;  }) 
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
