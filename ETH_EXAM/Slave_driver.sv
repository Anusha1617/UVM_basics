class Slave_driver extends uvm_driver#(Seq_item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	        req=Seq_item::type_id::create("req in driver");
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction



task  run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever @(h_Ethernet_Intf.Slave_cb_driver)
        begin
                seq_item_port.get_next_item(req);
                      /*  h_Ethernet_Intf.prstn_i<=req.prstn_i;
                        h_Ethernet_Intf.paddr_i<=req.paddr_i;
                        h_Ethernet_Intf.pwdata_i<=req.pwdata_i;
                        h_Ethernet_Intf.psel_i<=req.psel_i;
                        h_Ethernet_Intf.pwrite_i<=req.pwrite_i;
                        h_Ethernet_Intf.penable_i<=req.penable_i;
                        `uvm_info("DRV",$sformatf("IN DRIVER  %p ",req),UVM_LOW);

                        */
                                h_Ethernet_Intf.prstn_i<=1;
                                h_Ethernet_Intf.paddr_i<=req.paddr_i;
                                h_Ethernet_Intf.pwdata_i<=req.pwdata_i;
                                h_Ethernet_Intf.psel_i<=1;
                                h_Ethernet_Intf.pwrite_i<=req.pwrite_i;
                                h_Ethernet_Intf.penable_i<=0;

                                @(h_Ethernet_Intf.Slave_cb_driver)
                                h_Ethernet_Intf.penable_i<=1;

                                @(h_Ethernet_Intf.Slave_cb_driver)




                        req.print();
                seq_item_port.item_done();
        end

endtask






endclass


/*

output #0 prstn_i;
output #0 paddr_i;
output #0 pwdata_i;
output #0 psel_i;
output #0 pwrite_i;
output #0 penable_i;
input #0 pready_o;
input #0 prdata_o;
input #0 int_o;



*/
