//-------------------------------------------------------------------------------------//
// Drop frame(Transmission with len<MINFL,No pad)   IRQ=0
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
	
     RESET(); 
// 1.NO_OF_TX_BDs_Configuration ,
   	 start_num=2;
   	 end_num=128;
	    equal=1;
  	  all_RD=ONE;   // rd configuration
  	  all_IRQ=ONE;
  	  
	 NO_OF_TX_BDs_Configuration(start_num,end_num,equal,all_RD);
	
	 MAC_ADDR0_CONFIGURATION();
	 MAC_ADDR1_CONFIGURATION();
	 MIIADDRESS_CONFIGURATION();
	
	 TX_BD_NUM_CONFIGURATION(NO_OF_TX_BDs);    
	 TXBDs_CONFIGURATION();  		// length is randomized in the seq item use makefile
	 
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
