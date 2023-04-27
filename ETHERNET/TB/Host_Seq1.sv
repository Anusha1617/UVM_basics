class Host_Seq1 extends  Base_Seq;
    // extends from the Base_Seq
    // it will get all the properties(data members and methods) of parent class
	`uvm_object_utils(Host_Seq1)

	function new(string name ="Host_Seq1");
		super.new(name);
	endfunction

//inside body task we will set the fields as per Test_Case and then  call the tasks to randomize other variables
// see the Base_Seq(parent) sequence to know the tasks prototype
	task body();
// starting offset
	offset=0;  //  means it will start from 'h400
// NO_OF_TX_BDs_Configuration
    start_num=10;
    end_num=20;

// INT MASK Fields
        RXE_M=1; RXF_M=1; TXE_M=1; TXB_M=1;
// INT SOURCE Fields
        RXE=1; RXB=1; TXE=1; TXB=1;
//MODER Fields
        PAD=0; HUGEN=0; FULLD=0;LOOPBCK=0;IFG=0;PRO=0;BRO=0;NOPRE=0;TXEN=1;RXEN=0;

///-------calling the tasks -------//
     RESET();   // check n keep
     NO_OF_TX_BDs_Configuration(start_num,end_num);
	 MODER_CONFIGURATION(PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,0,RXEN);		// Making TXEN==0 at the starting of the configuration
	 MAC_ADDR0_CONFIGURATION();
	 MAC_ADDR1_CONFIGURATION();
	 MIIADDRESS_CONFIGURATION();
	 TX_BD_NUM_CONFIGURATION(NO_OF_TX_BDs);
	 TXBDs_CONFIGURATION();
	 INT_MASK_CONFIGURATION(RXE_M,RXF_M,TXE_M,TXB_M);
	 INT_SOURCE_CONFIGURATION(RXE,RXB,TXE,TXB);
	 MODER_CONFIGURATION(PAD,HUGEN,FULLD,LOOPBCK,IFG,PRO,BRO,NOPRE,TXEN,RXEN);
	//	READ();
	 END_CONFIGURATION();

$display();

`uvm_info ($sformatf("%s ENDED",get_type_name),"",UVM_FULL)
    endtask

endclass

