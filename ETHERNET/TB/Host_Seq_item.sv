class Host_Seq_item extends uvm_sequence_item;

	//===FACTORY REGISTRATION====//
	//`uvm_object_utils(Host_Seq_item)

	//===DECLARATION OF SIGNALS===//	
	rand bit penable_i,pwrite_i,psel_i;
	rand bit [31:0] paddr_i,pwdata_i;  
	bit pready_o,int_o,prstn_i;
	bit [31:0] prdata_o;



`uvm_object_utils_begin(Host_Seq_item)

`uvm_field_int(prstn_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(psel_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(penable_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(pwrite_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(paddr_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(pwdata_i,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(prdata_o,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(pready_o,UVM_ALL_ON|UVM_UNSIGNED)
`uvm_field_int(int_o,UVM_ALL_ON|UVM_UNSIGNED)

`uvm_object_utils_end
	
	//===CONSTRUCTOR=====//    
	function new(string name ="Host_Seq_item");
		super.new(name);
	endfunction       

	enum {TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44,INT_MASK='h08,INT_SOURCE='h04,MODER='h00}Reg_addr;


	constraint reg_c{
		solve  paddr_i before pwdata_i;
		if(paddr_i==MIIADDRESS)
				pwdata_i[31:5]==0;  // reserved bits 
		if(paddr_i==MAC_ADDR1)
				pwdata_i[31:16]==0;  // reserved bits 		
		if(paddr_i==TX_BD_NUM)
				pwdata_i[31:16]==0;  // reserved bits 
		soft pwrite_i==1;				
		soft penable_i==0;						
		soft psel_i==1;	
		//else if(paddr_i%4==0)
			if(psel_i==1)
                penable_i==0;	
							
        
		}

	function void post_randomize();
//		case (paddr_i)
//		TX_BD_NUM : begin pwdata_i=pwdata_i%127; end  
		//MIIADDRESS
//		endcase
		
	endfunction	
	
endclass
