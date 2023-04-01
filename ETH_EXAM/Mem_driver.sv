class Mem_driver extends uvm_driver#(Mem_Seq_Item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_driver)

virtual Ethernet_Intf h_Ethernet_Intf;

bit [32] addr;

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

        forever @(h_Ethernet_Intf.Mem_cb_driver)
        begin
                seq_item_port.get_next_item(req);
                        if(h_Ethernet_Intf.m_psel_o==1 && h_Ethernet_Intf.penable_i==1 )
                            begin 
                                h_Ethernet_Intf.m_pready_i<=1;
                                addr=h_Ethernet_Intf.m_paddr_o;
                                h_Ethernet_Intf.m_prdata_i<={req.memory[addr]+req.memory[addr+1]+req.memory[addr+2],req.memory[addr+3]};
                            end             
                            else 
                                begin   
                                    h_Ethernet_Intf.m_pready_i<=0;
                                    h_Ethernet_Intf.m_prdata_i<=0;
                                end
                                //$display("INSIDE THE MEMORY DRIVER %0d %0d",h_Ethernet_Intf.m_prdata_i,h_Ethernet_Intf.m_pready_i);
                seq_item_port.item_done();
        end

endtask




endclass
