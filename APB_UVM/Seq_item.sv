class Transaction extends uvm_sequence_item;
// transaction - container of all signals 
//	`uvm_object_utils(Transaction)

//-------------- OBJECT CONSTRUCTOR----------------------//
	function new(string name="");
		super.new(name);

	endfunction
//---------------SIGNALS---------------------------------//
     rand bit reset_n;
     rand bit [31:0]paddress;
     rand bit pwrite;
     rand bit pselx;
     rand bit penable;
     rand bit [31:0]pwdata;
     
     bit pslverr;       
     bit pready;
     bit [31:0]prdata;

//-------------- FIELD MACROS----------------------//

`uvm_object_utils_begin(Transaction)

`uvm_field_int(reset_n,UVM_ALL_ON)
`uvm_field_int(pselx,UVM_ALL_ON)
`uvm_field_int(penable,UVM_ALL_ON)
`uvm_field_int(pwrite,UVM_ALL_ON)
`uvm_field_int(paddress,UVM_ALL_ON)
`uvm_field_int(pwdata,UVM_ALL_ON)


`uvm_field_int(pready,UVM_ALL_ON)
`uvm_field_int(pslverr,UVM_ALL_ON)
`uvm_field_int(prdata,UVM_ALL_ON)


`uvm_object_utils_end



//---------------CONSTRAINTS-----------------------------//
	constraint random{
		soft reset_n == 1;
		soft paddress inside {0,8,12,4,32'hffff_ffff};
		soft pwdata inside {0,[1:32'h0000ffff],32'hffff_ffff};
		soft pselx == 1;
		soft penable == 0;
	}

endclass




