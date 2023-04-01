class Tx_driver extends uvm_driver;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction

task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever @(h_Ethernet_Intf.Tx_cb_driver)
        begin
                h_Ethernet_Intf.Tx_cb_driver.MCrS<=0;
                seq_item_port.get_next_item(req);
                if(h_Ethernet_Intf.Tx_cb_driver.int_o)
                    h_Ethernet_Intf.MCrS<=0;
                  else if(h_Ethernet_Intf.MTxEn==1)
                        h_Ethernet_Intf.Tx_cb_driver.MCrS<=1;
                seq_item_port.item_done();
        end

endtask





endclass
