
class Tx_driver extends uvm_driver#(Tx_Seq_Item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_driver)

virtual Ethernet_APB_interface h_Ethernet_Intf;

int unsigned i=0;

Config_class h_db;



// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual Ethernet_APB_interface ) :: get(this,this.get_full_name(),"virtual_apb_intf",h_Ethernet_Intf))
	  // set interface in
	  `uvm_fatal("DRV","")
	  if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal("SEQUENCE","mem_config class instance fail");
endfunction

task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork 
        	drive;
        	drive_int_source;
        join_any


endtask

task drive_int_source;
forever begin
@(h_Ethernet_Intf.host_cb_driver) if(h_Ethernet_Intf.int_o) begin
$display("DRV i=%0d",i);
			i++;
			h_Ethernet_Intf.host_cb_driver.prstn_i<=1;
			h_Ethernet_Intf.host_cb_driver.psel_i<=1;		//Setup stae s=1 e=0
			h_Ethernet_Intf.host_cb_driver.penable_i<=0;			
			h_Ethernet_Intf.host_cb_driver.pwrite_i<=1;
			h_Ethernet_Intf.host_cb_driver.paddr_i<='h04;
			h_Ethernet_Intf.host_cb_driver.pwdata_i<='habcd;
			
			@(h_Ethernet_Intf.host_cb_driver);		//access state  s=1 e=1
			h_Ethernet_Intf.host_cb_driver.penable_i<=1;
			
				wait(h_Ethernet_Intf.pready_o);
				                            @(h_Ethernet_Intf.host_cb_driver);		//acess state  s=1 e=1						
			h_Ethernet_Intf.host_cb_driver.psel_i<=0;		//Setup stae s=1 e=0
			h_Ethernet_Intf.host_cb_driver.penable_i<=0;						
			$display("DRV TX i=%0d ,txbdnum=%0d",i,h_db.TX_BD_NUM);
			if(i==h_db.TX_BD_NUM) break;
			end
			end
endtask


task drive;

        h_Ethernet_Intf.Tx_cb_driver.MCrS<=0;        

        forever @(h_Ethernet_Intf.Tx_cb_driver)
        begin
               seq_item_port.get_next_item(req);
               wait(h_Ethernet_Intf.MTxEn /*|| h_Ethernet_Intf.int_o*/);
              if(h_Ethernet_Intf.MTxEn)  
                begin 
                	forever@(h_Ethernet_Intf.Tx_cb_driver)
                	begin
				h_Ethernet_Intf.Tx_cb_driver.MCrS<=1;
                   		if(h_Ethernet_Intf.MTxEn==0) begin
                						 h_Ethernet_Intf.Tx_cb_driver.MCrS<=0;
//                						 $display("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
                						 break; 
                						  end
                   	end
               	end
               	/*else  begin   
             	
           	                						 h_Ethernet_Intf.Tx_cb_driver.MCrS<=0;
           	                						 drive_int_source;
           	                						            	                						 $display(" before RD=%p",h_db.RD);
           	                						 h_db.RD[i]=0;
           	                						 $display("RD=%p",h_db.RD);
           	                						 i++;
           	                						 
           	                						 
               	
               	   end*/
                seq_item_port.item_done();
        end

endtask


endclass
