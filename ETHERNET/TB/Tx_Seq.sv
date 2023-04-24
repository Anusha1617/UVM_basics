class Tx_Seq extends uvm_sequence#(Tx_Seq_Item);
	`uvm_object_utils(Tx_Seq)

Config_class h_db;

// object constructor 
	function new(string name="");
		super.new(name);
	endfunction



        task body();
		h_db = Config_class::type_id::create("h_db");
		if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal("SEQUENCE","mem_config class instance fail");        
        req=Tx_Seq_Item::type_id::create("req in mem_seq");
                  repeat(h_db.TX_BD_NUM)
                  begin   
	                              start_item(req);
					//$display
        	                      finish_item(req);
                   end
        endtask
endclass
