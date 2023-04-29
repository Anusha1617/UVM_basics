class Tx_Op_Mon extends uvm_monitor;

    virtual Ethernet_APB_interface h_tx_vintf;
    uvm_analysis_port#(Tx_Seq_Item) h_tx_cov_port;
    int i=0,capture;

    bit [55:0] PREAMBLE='haaaa_aaaa_aaaa_aa;
    bit [7:0] SFD='h5d;
    bit [47:0] SA=48'h0000_0000_abcd,DA=48'h0c00_0000_0000;
    bit [15:0] PAD_LEN;

    typedef bit [3:0] new_data_type  [$] ;

    new_data_type MAC_CLIENT_DATA,COPIED_QUEUE;

    bit [47:0] PSA,DSA[];

    bit [3:0] FCS;

    uvm_analysis_port#(new_data_type) h_tx_op_aa_port;
    Tx_Seq_Item req;
    Config_class h_config;


    `uvm_component_utils_begin(Tx_Op_Mon)
    	`uvm_field_queue_int(MAC_CLIENT_DATA,UVM_ALL_ON)
    `uvm_component_utils_end




//----------- component constructor --------//
    function new(string name = "Tx_Seq_Item", uvm_component parent = null);
      super.new(name, parent);
    endfunction

//-------------build_phase -----------------//
    function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		h_tx_op_aa_port = new("h_tx_op_aa_port",this);
    		req=Tx_Seq_Item::type_id::create("req");
    		h_tx_cov_port = new("h_tx_cov_port",this);//coverage
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
                     req.MCrS=h_tx_vintf.Tx_cb_monitor.MCrS;
                     h_tx_cov_port.write(req);
    		       //  req.print;


                     task_enable_data;
                     i=(i==h_config.TX_BD_NUM)?0:i;
            end
//            i=0;
    endtask

task task_enable_data;
        if(req.MTxEn)
            begin//{
                MAC_CLIENT_DATA.push_back(req.MTxD);
               
             if( h_config.PAD==1 && (h_config.LEN[i] < 46 ) ) PAD_LEN=46;
               else PAD_LEN = h_config.LEN[i];
               
                if(MAC_CLIENT_DATA.size==(((!h_config.NOPRE)*7)+1+6+6+2+4+h_config.LEN[i])*2)
                    begin //{
                        task_except_payload_check;
                        i++;
                    end//}
                else begin  // size not equal donot use

                    end
            end//}
       else
           begin//{  // waiting for the MTxEn==1
                   // if(h_config)
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
                                if(4'b0101==MAC_CLIENT_DATA[0])
                                    begin//{
//              `uvm_info("IPMO TX PREamble pass ",$sformatf("MAC_CLIENT_DATA=%p",MAC_CLIENT_DATA),UVM_NONE)
                                        capture=MAC_CLIENT_DATA.pop_front();
                                    end//}
                                 else
                                    begin//{
                                           `uvm_error("MONITOR",$sformatf("PREAMBLE Mismatch MAC=%p",MAC_CLIENT_DATA))        
//                                              MAC_CLIENT_DATA.delete();
                                             h_config.RD[i]=0;
                                    end//}
                      end//}
                      end//}
        //       `uvm_info("IPMO PREamble VALUE ",$sformatf("PREamble =%0d",h_config.NOPRE),UVM_NONE)

                                    task_sfd_check();
endtask




task task_sfd_check();
        if(SFD=={MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[1]})
            begin
              `uvm_info("IPMO TX SFD pass ","",UVM_HIGH)            
                    repeat(2)  begin    MAC_CLIENT_DATA.pop_front();  end
                 //   $display("MAC_CLIENT_DATA=%p \n{MAC_CLIENT_DATA[0:11]}=%p",MAC_CLIENT_DATA,MAC_CLIENT_DATA[0:11]);
                 COPIED_QUEUE=MAC_CLIENT_DATA;
               //  $display("COPIED_QUEUE=%p",COPIED_QUEUE);
                    crc_check();
            end
        else
            begin  `uvm_error("MONITOR",$sformatf("\nSFD=%0d MISMATCH=%0d %0d",SFD,MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[1]))  
                                            //  MAC_CLIENT_DATA.delete();
                                              h_config.RD[i]=0;
            end
endtask


task task_write_to_scoreboard;
                        h_tx_op_aa_port.write(MAC_CLIENT_DATA);  // check fcs in scoreboard
                        MAC_CLIENT_DATA.delete();
                        h_config.RD[i]=0;
                        `uvm_info("OPMO Queue deleted","",UVM_HIGH)
endtask                        



task task_SA_DA_check;
    if(DA=={MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[1],MAC_CLIENT_DATA[2],MAC_CLIENT_DATA[3],MAC_CLIENT_DATA[4],MAC_CLIENT_DATA[5],MAC_CLIENT_DATA[6],MAC_CLIENT_DATA[7],MAC_CLIENT_DATA[8],MAC_CLIENT_DATA[9],MAC_CLIENT_DATA[10],MAC_CLIENT_DATA[11]})
        begin  //{  
                        	`uvm_info("IPMO DA match","",UVM_HIGH)
    repeat(12)  begin    
                    	MAC_CLIENT_DATA.pop_front();                  	
                    end
                if(SA=={MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[1],MAC_CLIENT_DATA[2],MAC_CLIENT_DATA[3],MAC_CLIENT_DATA[4],MAC_CLIENT_DATA[5],MAC_CLIENT_DATA[6],MAC_CLIENT_DATA[7],MAC_CLIENT_DATA[8],MAC_CLIENT_DATA[9],MAC_CLIENT_DATA[10],MAC_CLIENT_DATA[11]})
                    begin //{
                                            	`uvm_info("IPMO SA match","",UVM_HIGH)
                            repeat(12)  begin    MAC_CLIENT_DATA.pop_front();  end
                            task_len_check;
                    end//}
                else
                    begin//{
                            `uvm_error("MONITOR","\n SA Mismatch")
                             // MAC_CLIENT_DATA.delete();
                              h_config.RD[i]=0;
                    end//}
        end//}
        else
            begin//{
                            `uvm_error("MONITOR","\n DA Mismatch")
                            // MAC_CLIENT_DATA.delete();
                             h_config.RD[i]=0;
            end//}

endtask


task task_len_check;
//`uvm_info("LEN CHECK",$sformatf("====================================================h_config.LEN[i]=%h  MAC_CLIENT_DATA=%p size=%0d",h_config.LEN[i],MAC_CLIENT_DATA,MAC_CLIENT_DATA.size),UVM_HIGH)c
//MAC_CLIENT_DATA.delete();
//`uvm_info("LEN CHECK",$sformatf("====================================================h_config.LEN[i]=%h  MAC_CLIENT_DATA=%p",h_config.LEN[i],MAC_CLIENT_DATA),UVM_HIGH)
 if(h_config.LEN[i]=={MAC_CLIENT_DATA[1],MAC_CLIENT_DATA[0],MAC_CLIENT_DATA[3],MAC_CLIENT_DATA[2]})
        begin  //{  
                                    `uvm_info("OPMO LEN MATCH","",UVM_HIGH)
        
                    repeat(4)  begin    MAC_CLIENT_DATA.pop_front();  end
//                    $display("\nwritten into scoreboard\n");
		`uvm_info("SENT TO SCRB========",$sformatf("RD=%p",h_config.RD),UVM_HIGH)
                task_write_to_scoreboard;
        end//}
        else
            begin//{
                            `uvm_error("MONITOR",$sformatf("\n Length Mismatch=%0d",h_config.LEN[i]))
                           // MAC_CLIENT_DATA.delete();
                            h_config.RD[i]=0;
            end//}
endtask




task crc_check();
		bit [3:0] data;
		bit [31:0] crc_variable = 32'hffff_ffff; // initializing the variable
		bit [31:0] crc_next; 
		bit [31:0] calculated_magic_number,dut_crc;
		int nibble_size;

        
		
		nibble_size = COPIED_QUEUE.size;
	
			for(int i=0;i<nibble_size;i++) 
			begin
//			data = nibble_crc.pop_front;
            data=COPIED_QUEUE.pop_front();
			data = {<<{data}}; 

			crc_next[0] =    (data[0] ^ crc_variable[28]); 
			crc_next[1] =    (data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29]); 
			crc_next[2] =    (data[2] ^ data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29] ^ crc_variable[30]); 
			crc_next[3] =    (data[3] ^ data[2] ^ data[1] ^ crc_variable[29] ^ crc_variable[30] ^ crc_variable[31]); 
			crc_next[4] =    (data[3] ^ data[2] ^ data[0] ^ crc_variable[28] ^ crc_variable[30] ^ crc_variable[31]) ^ crc_variable[0]; 
			crc_next[5] =    (data[3] ^ data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29] ^ crc_variable[31]) ^ crc_variable[1]; 
			crc_next[6] =    (data[2] ^ data[1] ^ crc_variable[29] ^ crc_variable[30]) ^ crc_variable[2]; 
			crc_next[7] =    (data[3] ^ data[2] ^ data[0] ^ crc_variable[28] ^ crc_variable[30] ^ crc_variable[31]) ^ crc_variable[3]; 
			crc_next[8] =    (data[3] ^ data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29] ^ crc_variable[31]) ^ crc_variable[4]; 
			crc_next[9] =    (data[2] ^ data[1] ^ crc_variable[29] ^ crc_variable[30]) ^ crc_variable[5]; 
			crc_next[10] =    (data[3] ^ data[2] ^ data[0] ^ crc_variable[28] ^ crc_variable[30] ^ crc_variable[31]) ^ crc_variable[6]; 
			crc_next[11] =    (data[3] ^ data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29] ^ crc_variable[31]) ^ crc_variable[7]; 
			crc_next[12] =    (data[2] ^ data[1] ^ data[0] ^ crc_variable[28] ^ crc_variable[29] ^ crc_variable[30]) ^ crc_variable[8]; 
			crc_next[13] =    (data[3] ^ data[2] ^ data[1] ^ crc_variable[29] ^ crc_variable[30] ^ crc_variable[31]) ^ crc_variable[9]; 
			crc_next[14] =    (data[3] ^ data[2] ^ crc_variable[30] ^ crc_variable[31]) ^ crc_variable[10]; 
			crc_next[15] =    (data[3] ^ crc_variable[31]) ^ crc_variable[11]; 
			crc_next[16] =    (data[0] ^ crc_variable[28]) ^ crc_variable[12]; 
			crc_next[17] =    (data[1] ^ crc_variable[29]) ^ crc_variable[13]; 
			crc_next[18] =    (data[2] ^ crc_variable[30]) ^ crc_variable[14]; 
			crc_next[19] =    (data[3] ^ crc_variable[31]) ^ crc_variable[15]; 
			crc_next[20] = 	  crc_variable[16]; 
			crc_next[21] =    crc_variable[17]; 
			crc_next[22] =    (data[0] ^ crc_variable[28]) ^ crc_variable[18]; 
			crc_next[23] =    (data[1] ^ data[0] ^ crc_variable[29] ^ crc_variable[28]) ^ crc_variable[19]; 
			crc_next[24] =    (data[2] ^ data[1] ^ crc_variable[30] ^ crc_variable[29]) ^ crc_variable[20]; 
			crc_next[25] =    (data[3] ^ data[2] ^ crc_variable[31] ^ crc_variable[30]) ^ crc_variable[21]; 
			crc_next[26] =    (data[3] ^ data[0] ^ crc_variable[31] ^ crc_variable[28]) ^ crc_variable[22]; 
			crc_next[27] =    (data[1] ^ crc_variable[29]) ^ crc_variable[23]; 
			crc_next[28] =    (data[2] ^ crc_variable[30]) ^ crc_variable[24]; 
			crc_next[29] =    (data[3] ^ crc_variable[31]) ^ crc_variable[25]; 
			crc_next[30] =    crc_variable[26]; 
			crc_next[31] =    crc_variable[27]; 

			crc_variable = crc_next;

			end
		calculated_magic_number = crc_variable;


        if(crc_variable=='hc704dd7b)// same
            begin
                                    `uvm_info("CRC MATCH",get_name,UVM_HIGH)
                    task_SA_DA_check;
            end
            else
                begin
                        `uvm_error("CRC ERROR","")
                end

	endtask

endclass
