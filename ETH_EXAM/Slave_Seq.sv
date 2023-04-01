class Slave_Seq extends uvm_sequence#(Seq_item);



//------FACTORY Registration----------------//
	`uvm_object_utils(Slave_Seq)


enum int{MODER=0,INT_SOURCE='h04,INT_MASK='h08,TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44} reg_addr;
// object constructor 
function new(string name="");
		super.new(name);
endfunction


        task body();
        req=Seq_item::type_id::create("req in seq");

                         repeat(10)
                            begin   
        start_item(req);
                                   assert(req.randomize() with { paddr_i==reg_addr.next;}  );   //   TX_BD_NUM configuration
         finish_item(req);
                             end


        endtask

/*task_
        start_item(req);
                         repeat(1)
                            begin   
                                   assert(req.randomize() with { paddr_i==TX_BD_NUM; pwdata_i==128;}  );   //   TX_BD_NUM configuration
                             end
         finish_item(req);
*/

endclass
