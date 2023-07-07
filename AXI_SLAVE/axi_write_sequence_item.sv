
 class mcs_axi4_write_seq_item extends uvm_sequence_item;
 `uvm_object_utils(mcs_axi4_write_seq_item);
function new(string name= "");
super.new(name);
endfunction

//DATA_BUS_WIDTH is parameter    
        // WRITE ADDRESS CHANNEL
	bit ARESETn;
        bit[$clog2(`NO_OF_IDS)-1:0] AWID;      // unique ids 
        bit[`ADDR_BUS_WIDTH-1:0] AWADDR;  
        bit[`LENGTH-1:0]AWLEN;      // no of lengths
        bit[2:0]AWSIZE;   //  no of bytes in each trasfer  1 tO 128
        bit[1:0]AWBURST;  // type of burst
        bit AWVALID,AWREADY; // hand shaking signals
        // WRITE DATA CHANNEL    
        bit[`DATA_BUS_WIDTH-1:0] WDATA;  // returns data from memory
        bit [$clog2(`DATA_BUS_WIDTH)-2 :0]WSTRB;   // $clog2 gives the $clog2(32) returns 5
	bit WLAST;            
        bit WVALID,WREADY;   // hand shaking signals
        // WRITE RESPONSE CHANNEL
        bit[1:0]BRESP;  
	bit [$clog2(`NO_OF_IDS)-1:0] BID;
	bit BVALID;
	bit BREADY;	




 	 endclass
