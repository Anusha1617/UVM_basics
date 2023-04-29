class Scoreboard extends uvm_scoreboard;

    `uvm_component_utils(Scoreboard) //1.factory register

    typedef bit [3:0] new_data_type  [$] ;
    new_data_type DUT_PAYLOAD;
    typedef bit[7:0] Payload [$];
    Payload TB_payload;//q of bytes get values from config db

   /* uvm_line_printer line;
    uvm_table_printer my_table;
    uvm_tree_printer tree; */

	uvm_tlm_analysis_fifo #(new_data_type) dut_fifo;

    Config_class h_config;

    function new(string name="SCOREBOARD", uvm_component parent );  // component constructor
            super.new(name,parent);  // creating memory for parent class
    endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		 dut_fifo=new("dut_fifo",this);
//		 line=new();
	//	 my_table=new();
	//	 tree=new();
		if(!(uvm_config_db #(Config_class) :: get(this,"","config_class",h_config)))
			`uvm_fatal("driver_buildphase",$sformatf("Getting interface is failed"));
	endfunction

        int i,error;

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		 	forever	begin//{
				error=0;
				dut_fifo.get(DUT_PAYLOAD);//getting from tx - monitor.
				TB_payload = h_config.TX_payloads[i].pl; //getting from config class which is generated in sequence.
                i++;
//				`uvm_info("SCORE DUT-PAYLOAD",$sformatf("\nDUT_PAYLOAD size = %0d ,\n DUT_PAYLOAD = %p",DUT_PAYLOAD.size(),DUT_PAYLOAD),UVM_MEDIUM)
//				`uvm_info("SCORE TB-PAYLOAD",$sformatf("\nTB_payload size = %0d ,\n TB_payload = %p",TB_payload.size(),TB_payload),UVM_MEDIUM)

				if(DUT_PAYLOAD.size() == (2 * TB_payload.size() + 8) )	begin// 8 Is for fcs
					for(int j=0; j<TB_payload.size() ; j++)	begin

						if(TB_payload[j] == {DUT_PAYLOAD[1],DUT_PAYLOAD[0]} )
							`uvm_info("SCORE MATCH",$sformatf("Payload values match \n TB_payload[%0d] = %h \n equal to \n DUT_payload = %h",j,TB_payload[j],{DUT_PAYLOAD[1],DUT_PAYLOAD[0]}),UVM_HIGH)

						else	begin
							`uvm_error("SCORE MISMATCH",$sformatf("Payload values mismatch \n TB_payload[%0d] = %h \n not equal to \nDUT_payload = %h",j,TB_payload[j],{DUT_PAYLOAD[1],DUT_PAYLOAD[0]}))
							error=1;
							break;
						end

						repeat(2) DUT_PAYLOAD.pop_front();  // removing the data after comparing
					end

					if(error)	`uvm_error("***************************SCORE PAYLOAD FAIL***************************","ERROR IN PAYLOAD")
					else	uvm_report_info("----------SCORE BOARD PAYLOAD PASS---------","PAYLOADS ARE MATCHING",UVM_NONE);

                       // `uvm_info("----------SCORE BOARD PAYLOAD PASS---------","PAYLOADS ARE MATCHING",UVM_NONE)

				end

				else
					`uvm_error("SCORE LEN-MIS",$sformatf("size mismatch between gen payload = %d and dut payload =%d",TB_payload.size,DUT_PAYLOAD.size))

                if(i==h_config.TX_BD_NUM) i=0;
			end//}
	endtask


endclass
