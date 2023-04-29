//-------------------------------------------------------------------------------------//
/*		TXEN=1 RXEN=0	
		PAD=0   HUGEN=0 // LEN give in constraint
	1. LEN [4:46]
  	2. LEN [0:3]
    3. LEN [46:1500]
    4. LEN>1500
    5. LEN>2000
	*/
  //-------------------------------------------------------------------------------------//

class Host_Seq1 extends  Base_Seq;
    // extends from the Base_Seq
    // it will get all the properties(data members and methods) of parent class
	`uvm_object_utils(Host_Seq1)

	function new(string name ="Host_Seq1");
		super.new(name);
	endfunction

//inside body task we will set the fields as per Test_Case and then  call the tasks to randomize other variables
// see the Base_Seq(parent) sequence to know the tasks prototype
	task body;
	
     RESET(); // only for sequence 1

// TXBD NUM range
   	 starting_number=1;   
   	 ending_number=128;  
	  //  dont_randomize=1;   // it doesnot randomize the TXBDNUM takes [TXBDNUM = starting_number] 
  	 	dont_randomize=0;   // it will randomize the TXBDNUM in the given range
		
	  all_RD=ONE;   // all_rd=ONE,RANDOM,ZERO
  	  all_IRQ=ONE;  // all_IRQ=ONE,RANDOM,ZERO
  	  
	 NO_OF_TX_BDs_Configuration(starting_number,ending_number,dont_randomize,all_RD,all_IRQ);
	
	 MAC_ADDR0_CONFIGURATION();
	 MAC_ADDR1_CONFIGURATION();
	 MIIADDRESS_CONFIGURATION();
	
	 TX_BD_NUM_CONFIGURATION(NO_OF_TX_BDs);    
	 TXBDs_CONFIGURATION();  		
	 
// INT MASK Fields
        RXE_M=1; RXF_M=1; TXE_M=1; TXB_M=1; 
        
	 INT_MASK_CONFIGURATION(RXE_M,RXF_M,TXE_M,TXB_M);
	 
// INT SOURCE Fields
        RXE=1; RXB=1; TXE=1; TXB=1;
	 
	 INT_SOURCE_CONFIGURATION(RXE,RXB,TXE,TXB);
	 
//MODER Fields
        PAD=0; HUGEN=1; FULLD=0;LOOPBCK=0;IFG=0;PRO=0;BRO=0;NOPRE=0;TXEN=1;RXEN=0;	 
	 
	 MODER_CONFIGURATION(PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,TXEN,RXEN);
	 
	 END_CONFIGURATION();

	`uvm_info ($sformatf("%s ENDED",get_type_name),"",UVM_FULL)
    endtask

endclass
