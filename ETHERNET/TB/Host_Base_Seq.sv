//-------------------------------------------------------------------------------------//
//          BASE SEQUENCE 
//-------------------------------------------------------------------------------------//


// it will contain the tasks require to randomize in the new sequences
class Base_Seq extends uvm_sequence #(Host_Seq_item);

	`uvm_object_utils(Base_Seq)
	Config_class h_config;

	//variables required in address and length calculation
	int unsigned offset,accumulated_length;
    // LENGTH in BDs
    bit[16] start_num,end_num;
    bit equal;
	// Number of TX_BD_NUMs
    bit [15:0]NO_OF_TX_BDs;

// TX BD fields
    bit RD_array[],IRQ_array[];

typedef    enum {ONE=1,RANDOM=0,ZERO=2}ndt;

ndt all_RD,all_IRQ;

	//INT_MASK bits fields
    bit RXE_M,RXF_M,TXE_M,TXB_M;

	//INT_SOURCE fields
    bit RXE,RXB,TXE,TXB;

	//MODER fields
    bit  PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,TXEN,RXEN;

	// Registers addresses are taken in enum data type

	// enum will take only defined values if other value is assigned then error will be thrown
	// similar to PARAMETER

    enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;

	function new(string name ="Host_Seq1");
		super.new(name);
	endfunction

//----------PRE BODY --------------------//
	//  executed before the body task
task pre_body();

	h_config=Config_class::type_id::create("h_config");
	uvm_config_db #(Config_class) :: get(null,"","config_class",h_config);
	req=Host_Seq_item::type_id::create("req");
endtask


virtual task NO_OF_TX_BDs_Configuration(bit[16] start_num=1,end_num=10 ,bit equal=0, ndt all_RD=ONE);
            if(equal) begin//{
            	std::randomize(NO_OF_TX_BDs) with {   // scope randomization >>>> if you aren't randomizing an object, then this is the call you should be using.
	    		NO_OF_TX_BDs inside {start_num};
	                                                };
            end//}
            else begin//{
            	std::randomize(NO_OF_TX_BDs) with {   // scope randomization >>>> if you aren't randomizing an object, then this is the call you should be using.
			    NO_OF_TX_BDs inside {[start_num:end_num]};
                                                	};
    end//}

        RD_array=new[NO_OF_TX_BDs];
        IRQ_array=new[NO_OF_TX_BDs];        

                for(int i=0; i<NO_OF_TX_BDs; i++)
                begin//{
                        if(all_RD==ONE)
                            begin//{
//                                $display(" one RD=%p",RD_array);
                                    RD_array[i]=1;
                            end//}
                        else if(all_RD==RANDOM)
                             begin//{
 //                               $display(" RANDOM RD=%p",RD_array);
                                    RD_array[i]=$urandom_range(0,1);
                             end//}
                        else if(all_RD==ZERO)
                            begin//{
                                    RD_array[i]=0;
                            end//}
                end//}
                
                for(int i=0; i<NO_OF_TX_BDs; i++)
                begin//{
                        if(all_IRQ==ONE)
                            begin//{
                                    IRQ_array[i]=1;
                            end//}
                        else if(all_IRQ==RANDOM)
                             begin//{
                                    IRQ_array[i]=$urandom_range(0,1);                                    
                             end//}
                        else if(all_IRQ==ZERO)
                            begin//{
                                    RD_array[i]=0;
                                    IRQ_array[i]=0;
                            end//}
                end//}                
                
                

endtask


//tasks which are required for configuring the Registers
// kept virtual if overriding is required we can override in child classes
	virtual task RESET();
		start_item(req);
			assert (req.randomize() with {prstn_i==0; } )
		finish_item(req);
	endtask


    virtual task TX_BD_NUM_CONFIGURATION(bit[31:0] data=128);
		start_item(req);
			assert (req.randomize() with {pwdata_i==data; paddr_i==TX_BD_NUM;} )
		finish_item(req);
	endtask

	virtual task MAC_ADDR0_CONFIGURATION(byte two='h0,three='h0,four='hab,five='hcd);  // SA 23 45
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR0; pwdata_i=={two,three,four,five}; })
			finish_item(req);
	endtask

	virtual task MAC_ADDR1_CONFIGURATION(byte zero='h0,one='h0);
			start_item(req);
			assert (req.randomize() with {paddr_i==MAC_ADDR1; pwdata_i=={16'b0,zero,one};})
			finish_item(req);
	endtask

	virtual task MIIADDRESS_CONFIGURATION(bit [4:0]FIAD=5'hc);
			start_item(req);
			assert (req.randomize() with {paddr_i==MIIADDRESS;  pwdata_i=={27'b0,FIAD};  })
			finish_item(req);
	endtask


	virtual task TXBDs_offset(RD=1,IRQ=0);
    int unsigned rem,LEN;
			start_item(req);
//			$display("======================================================================seq in host   LEN=%0d",LEN);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i[15:0]=={RD,IRQ,14'b0};});   // random data is going
            LEN=req.pwdata_i[32:16];
			offset++;
			uvm_report_info (get_type_name (), $sformatf ("\n\t\t\t\t\t^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^paddr_i=%h  offset =%0d ",req.paddr_i,offset), UVM_FULL);
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

	virtual task TXBDs_offset_p_4( bit[31:0] TXPNT=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==(offset*4)+'h400; pwdata_i==TXPNT;  });   // random data is going
			offset++;
			finish_item(req);
	endtask


	virtual task TXBDs_CONFIGURATION();
    int i;
		uvm_report_info("HOST SEQ TX BD Configuration ",$sformatf("\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t***TXBDNUM=%0d*** \n\n",h_config.TX_BD_NUM),UVM_LOW);
		repeat(h_config.TX_BD_NUM)
		begin
			TXBDs_offset(RD_array[i],IRQ_array[i]);		//------------------------------------------------//
            i++;
		end
        i=0;
	endtask

	virtual task INT_MASK_CONFIGURATION(bit RXE_M=1,RXF_M=1,TXE_M=1,TXB_M=1);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_MASK; pwdata_i=={28'b0,RXE_M,RXF_M,TXE_M,TXB_M}; })
			finish_item(req);
	endtask

	virtual task INT_SOURCE_CONFIGURATION(bit RXE=1,RXB=1,TXE=1,TXB=1);
			start_item(req);
			assert (req.randomize() with {paddr_i==INT_SOURCE; pwdata_i=={28'b0,RXE,RXB,TXE,TXB}; })
			finish_item(req);
	endtask
	virtual task MODER_CONFIGURATION(bit  PAD=1,HUGEN=0,FULLD=0,LOOPBCK=0,IFG=0,PRO=0,BRO=0,NOPRE=0,TXEN=1,RXEN=0);
			start_item(req);
			assert (req.randomize() with {paddr_i==MODER; pwdata_i=={16'b0,PAD,HUGEN,3'b0,FULLD,2'b0,LOOPBCK,IFG,PRO,1'b0,BRO,NOPRE,TXEN,RXEN};});
			finish_item(req);
	endtask


	virtual task END_CONFIGURATION();
			start_item(req);
			assert (req.randomize() with {psel_i==0;  paddr_i==0;   penable_i==0; pwdata_i==0;  })
            $display("\t\t\t\t\t%0t",$time);
           $display("----------------------------------------------------------------------------------------------------------------------------\nLEN=%p ",h_config.LEN); 
           $display("IRQ=%p ",h_config.IRQ); 
           $display("RD=%p\n---------------------------------------------------------------------------------------------------------------------------- ",h_config.RD); 
			finish_item(req);
	endtask


    virtual task READ();

			//repeat(9) begin
			start_item(req);
		    	Reg_addr=Reg_addr.next();
		    	`uvm_info("SEQ IN HOST",$sformatf("\t\t\t\t\t Reading Reg_addr=%s ",Reg_addr),UVM_LOW)
		    	assert (req.randomize() with {paddr_i==INT_SOURCE;   pwrite_i==0; pwdata_i==0;  })
			finish_item(req);
		//	end
	endtask

	virtual task post_body();
		offset=0;
		accumulated_length=0;
	endtask

endclass

