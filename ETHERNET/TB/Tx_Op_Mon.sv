
class Tx_Op_Mon extends uvm_monitor;

`uvm_component_utils(Tx_Op_Mon)

virtual Ethernet_APB_interface h_tx_vintf;

int i=0;

bit [55:0] PREAMBLE='haaaa_aaaa_aaaa_aa;
bit [7:0] SFD='hab;
bit [41:0] SA,DA,BA=42'h3_ff_ffff_ffff;

bit [15:0] LEN,Packet_Count;

typedef bit [3:0] new_data_type  [$] ;

new_data_type MAC_CLIENT_DATA;

bit [3:0] FCS;

uvm_analysis_port#(new_data_type) h_tx_op_aa_port;
Tx_Seq_Item req;
Config_class h_config;

//----------- component constructor --------//
  function new(string name = "Tx_op_mon", uvm_component parent = null);
    super.new(name, parent);
  endfunction

//-------------build_phase -----------------//
function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_tx_op_aa_port = new("h_tx_op_aa_port",this);
		req=Tx_Seq_Item::type_id::create("req");
endfunction

//-------connect_phase--------------//
function void connect_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual Ethernet_APB_interface)::get(this,"","virtual_apb_intf",h_tx_vintf))
			`uvm_error("config failure",$sformatf("=== Failing to establish config in output monitor"));
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))

			`uvm_error("TX_OP_MON_connectphase",$sformatf("Getting interface is failed"));			
endfunction


task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever @(h_tx_vintf.Tx_cb_monitor)
        begin
                 req.MTxEn=h_tx_vintf.Tx_cb_monitor.MTxEn; 
                 req.MTxD=h_tx_vintf.Tx_cb_monitor.MTxD;
                 req.MTxErr=h_tx_vintf.Tx_cb_monitor.MTxErr;
                 req.int_o=h_tx_vintf.Tx_cb_monitor.int_o;
                 $display(MTxD);
//                 req.print;
//		         task_checker;
		h_tx_op_aa_port.write(req);		         
        end
endtask


task task_checker;
            if(h_config.RD[i])
                begin
                //	`uvm_info("IPMO",$sformatf("basava i =%0d",i),UVM_NONE)
                        task_enable_data;             
                end
            else
                begin
                        i++;
         //       $display(" IPMO 70 bbb i=%0d",i);
//                        task_checker;
                end
endtask
task task_enable_data;
        if(req.MTxEn)
            begin//{
                MAC_CLIENT_DATA.push_back(req.MTxD);
                `uvm_info("IPMO ",$sformatf("q=%p",MAC_CLIENT_DATA),UVM_NONE)
                if(MAC_CLIENT_DATA.size==(((!h_config.NOPRE)*7)+1+1+6+6+2+4+h_config.LEN[i]))
                    begin //{
                        task_except_payload_check;
                    end//}
                else begin  // size not equal donot use

                    end
            end//}
       else
           begin//{  // waiting for the MTxEn==1
           		
           end//}
endtask


task task_except_payload_check;
        task_preamble_check;
endtask

task task_preamble_check ;
        if(h_config.NOPRE==0)
                    begin//{
                            repeat(14)
                            begin//{
                                if(4'b1010==MAC_CLIENT_DATA[0])
                                    begin//{
                                        MAC_CLIENT_DATA.pop_front();
                                    end//}
                                 else
                                    begin//{
                                           `uvm_error("MONITOR","PREAMBLE Mismatch")        
                                              MAC_CLIENT_DATA.delete();
                                              h_config.RD[i]=0;
                                    end//}
                            end//}
                            end//}
                        else
                                begin//{
                                    task_sfd_check();
                                end//}           
endtask




task task_sfd_check();
        if(SFD=={MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[1]})
            begin
                    repeat(2)  begin    MAC_CLIENT_DATA.pop_front();  end
                    task_PRO_BRO_check;
            end
        else
            begin  `uvm_error("MONITOR","\nSFD MISMATCH")  
                                              MAC_CLIENT_DATA.delete();
                                              h_config.RD[i]=0;
            end
endtask


task task_write_to_scoreboard;
                        h_tx_op_aa_port.write(MAC_CLIENT_DATA);  // check fcs in scoreboard
                        MAC_CLIENT_DATA.delete();
                        h_config.RD[i]=0;
			Packet_Count++;                        
endtask                        



task task_PRO_BRO_check;
if(h_config.PRO==1) begin
                    repeat(12)  begin    MAC_CLIENT_DATA.pop_front();  end
                    task_len_check;
                     end
                    
else
begin 
	if(h_config.BRO)
		begin
			task_SA_DA_check;	
		end
	else
		begin 
		    if(DA=={MAC_CLIENT_DATA[0:11]}  || BA=={MAC_CLIENT_DATA[0:11] )
			task_len_check;
			else
			                            `uvm_error("MONITOR","\n DA Mismatch")
			 
		end

end                    
endtask               
                    
task task_SA_DA_check;
    if(DA=={MAC_CLIENT_DATA[0:11]})
        begin  //{  
                    repeat(12)  begin    MAC_CLIENT_DATA.pop_front();  end
                
                if(SA=={MAC_CLIENT_DATA[0:11]})
                    begin //{
                            repeat(12)  begin    MAC_CLIENT_DATA.pop_front();  end
                            task_len_check;
                            i++;
                    end//}
                else
                    begin//{
                            `uvm_error("MONITOR","\n SA Mismatch")
                              MAC_CLIENT_DATA.delete();
                              h_config.RD[i]=0;
                    end//}
        end//}
        else
            begin//{
                            `uvm_error("MONITOR","\n DA Mismatch")
                             MAC_CLIENT_DATA.delete();
                             h_config.RD[i]=0;
            end//}

endtask


task task_len_check;
    if(h_config.LEN[i]=={MAC_CLIENT_DATA[0:3]})
        begin  //{  
                    repeat(4)  begin    MAC_CLIENT_DATA.pop_front();  end
                task_write_to_scoreboard;
        end//}
        else
            begin//{
                            `uvm_error("MONITOR","\n Length Mismatch")
                            MAC_CLIENT_DATA.delete();
                            h_config.RD[i]=0;
            end//}

endtask


endclass
