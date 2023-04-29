//`include "Mem_seq_item.sv"

class Mem_Seq extends uvm_sequence#(Mem_seq_item);

  `uvm_object_utils(Mem_Seq)


	//temporary... config class has to come and build phase to be created to config class
	int BD_length;	//Get this value from config class from Buffer descriptor to randomize the payload.
	int TXBDs_ready,RXBDs_EMPTY;	//Get this value from config class. No. of Buffer descriptors with ready=1.
	Config_class h_db;
	bit hugen;

	function new (string name = "Mem_Seq");
		super.new("MEM SEQ 3");
		//BD_length=20;	TXBDs_ready=2;	RXBDs_EMPTY=2;
	endfunction

	task pre_body();
		//h_db = Config_class::type_id::create("h_db");
		if(!uvm_config_db #(Config_class) :: get(null,"","config_class",h_db))	`uvm_fatal("SEQUENCE","mem_config class instance fail");
	endtask


	task body;
		int i;//packet number
		req = Mem_seq_item :: type_id :: create("req");


		TXBDs_ready = h_db.get_no_tx_ready;
		RXBDs_EMPTY = h_db.get_no_rx_empty;
		hugen=h_db.HUGEN;

//					uvm_report_info(get_name(),$sformatf("paylength = %d",req.paylength),UVM_LOW);

		//--------- for TX Driving -----------//
		repeat(h_db.TX_BD_NUM)	begin//{

			if(h_db.RD[i])	begin//{
				BD_length = h_db.get_txlen(i);



					if(BD_length > 1500)	begin//{
						if(hugen)	begin//{
							start_item(req);

								if(req.randomize with {paylength == BD_length; mode == 0; HUGE == hugen;})
									begin//{
										uvm_report_info("No of Payload Generated",$sformatf(" payload =  -----size=%0d",req.Payload.size()),UVM_LOW);
									end//}
								else begin//{
									`uvm_error("MEM_RAND_FAIL","Randomizaion Failed from Memory Sequence during TX")
                                    end//}

								h_db.set_tx_payload(req.Payload);//updating packet in config class for scoreboard.

							finish_item(req);

						end//}
						else;
					end//}

					else	begin//{
						start_item(req);

								if(req.randomize with {paylength == BD_length; mode == 0; HUGE == hugen;})
									begin//{
										uvm_report_info("No of Payload Generated",$sformatf(" payload  -----size=%0d",req.Payload.size()),UVM_LOW);
									end//}
								else
									`uvm_error("MEM_RAND_FAIL","Randomizaion Failed from Memory Sequence during TX")
								h_db.set_tx_payload(req.Payload);//updating packet in config class for scoreboard.
							finish_item(req);

					end//}

					//h_db.mem_disp();
			end//}
			else  begin  `uvm_warning("TXBD RD=0 Came in Mem Seq ","TX RD=0") break; end


			i++;//nxt bd

		end//}



		//-------------- for RX Driving --------//
		repeat(RXBDs_EMPTY)	begin

		BD_length = h_db.get_rxlen(i);
		i++;
			start_item(req);
				assert(req.randomize with {paylength == BD_length; mode == 1;})
					uvm_report_info("SEQUENCE",$sformatf("paylength = %d",req.paylength),UVM_LOW);
				else
					`uvm_error("MEM_RAND_FAIL","Randomizaion Failed from Memory Sequence during RX")
			finish_item(req);
			//h_db.mem_disp();

		end


uvm_report_info("MEM SEQ ENDED", $sformatf ("TX SEQ ENDED "), UVM_LOW);

	endtask


endclass
