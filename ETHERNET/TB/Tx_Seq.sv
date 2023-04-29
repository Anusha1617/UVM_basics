class Tx_Seq extends uvm_sequence#(Tx_Seq_Item);
	`uvm_object_utils(Tx_Seq)

Config_class h_db;

int i;

// object constructor
	function new(string name="");
		super.new(name);
	endfunction



        task body();
		h_db = Config_class::type_id::create("h_db");
		if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal("SEQUENCE","mem_config class instance fail");
        req=Tx_Seq_Item::type_id::create("req in mem_seq");

`uvm_info ("SEQ IN TX ", $sformatf (" h_db.TXBSDNUM=%0d",h_db.TX_BD_NUM), UVM_HIGH)
                  repeat(h_db.TX_BD_NUM)
                  begin//{
                  if(h_db.RD[i]) begin//{
	                              start_item(req);
                        //    `uvm_warning(" INIS   TXBD RD=0 Came in TX MAC Seq",$sformatf("TX_BD_NUM=%0d i=%0d h_db.RD=%p",h_db.TX_BD_NUM,i,h_db.RD))  
        	                      finish_item(req);
                                  i++;
                   end//}
                   else
                       begin//{
                            i=0;
                            `uvm_warning("TXBD RD=0 Came in TX MAC Seq",$sformatf("TX_BD_NUM=%0d i=%0d h_db.RD=%p",h_db.TX_BD_NUM,i,h_db.RD)) break; 
			                
                       end//}

                   end//}
                       i=0;
`uvm_info ("TX SEQ ENDED", $sformatf ("TX SEQ ENDED "), UVM_HIGH)
        endtask
endclass
