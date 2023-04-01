class Seq_item extends uvm_sequence_item;
`uvm_object_utils(Seq_item)

rand bit  prstn_i;
rand bit [31:0] paddr_i;
rand bit  [31:0]pwdata_i;
rand bit  [31:0]prdata_o;

rand bit  psel_i;
rand bit  pwrite_i;
rand bit  penable_i;


rand enum int{MODER=0,INT_SOURCE='h04,INT_MASK='h08,TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44} reg_addr;

//rand bit[31:0] BD_ADDR;


bit  pready_o;
bit  int_o;

constraint c1{   solve reg_addr before paddr_i;
    
    soft  psel_i==1;
    soft pwrite_i==1;
    soft penable_i==0;
//    BD_ADDR iniside {['h400:'h7ff] with item%4==0; } ;

//  paddr_i inside {reg_addr};
    
    }



// component constructor 
function new(string name="");
		super.new(name);
endfunction



function void post_randomize();
        //if(paddr_i==TX_BD_NUM)
          //  pwdata_i=128;
         case(paddr_i)
         TX_BD_NUM:begin pwdata_i=128; end

         MIIADDRESS:begin pwdata_i=32'b11111; end
         MAC_ADDR0:begin pwdata_i=96; end
         MAC_ADDR1:begin pwdata_i=69; end

         INT_MASK:begin pwdata_i=0; end
         INT_SOURCE:begin pwdata_i=0; end
         MODER:begin pwdata_i=128; end


         endcase

endfunction





endclass
