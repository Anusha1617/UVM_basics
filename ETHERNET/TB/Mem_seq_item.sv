
class Mem_seq_item extends uvm_sequence_item;
	
	//----- APB MASTER ----------//

	bit [31:0]m_paddr_o;
	bit [31:0]m_pwdata_o;
	bit m_psel_o;
	bit m_pwrite_o;
	bit m_penable_o;

	bit m_pready_i;
	bit [31:0]m_prdata_i;
	
	//common signals
	bit int_o,prstn_i;
	
	//----------- control signals  ----------//
	rand bit HUGE,PAD;
	
	
	//--------- Payload Information ---------//
	rand bit[7:0] Payload [$];
	rand int paylength;
	
	typedef enum {READ,WRITE} MODE;
	rand MODE mode;
	
	typedef enum {BAD,GOOD} FRAME;
	rand FRAME frame;
	
	//------	Field registration ---------//
	`uvm_object_utils_begin(Mem_seq_item)
	
	`uvm_field_int(m_paddr_o,UVM_ALL_ON);
	`uvm_field_int(m_pwdata_o,UVM_ALL_ON);
	`uvm_field_int(m_psel_o,UVM_ALL_ON);
	`uvm_field_int(m_pwrite_o,UVM_ALL_ON);
	`uvm_field_int(m_penable_o,UVM_ALL_ON);
	`uvm_field_int(m_pready_i,UVM_ALL_ON);
	`uvm_field_int(m_prdata_i,UVM_ALL_ON);
	
	`uvm_field_int(int_o,UVM_ALL_ON);
	`uvm_field_int(prstn_i,UVM_ALL_ON);
	
	`uvm_field_queue_int(Payload,UVM_ALL_ON);
	`uvm_field_int(paylength,UVM_ALL_ON);
	`uvm_field_enum(MODE,mode,UVM_ALL_ON);
	`uvm_field_enum(FRAME,frame,UVM_ALL_ON);
	
	`uvm_object_utils_end
	
	//----------- Object constructor --------//
	  function new(string name = "Mem_seq_item");
		super.new(name);
	  endfunction
  
  	//----------  Constraints ----------------//
constraint Payload_constraint {

        solve paylength before Payload;		//solve length before

		if(!HUGE)	{//with out huge
			if(!PAD)	{//normal - no pad, no hugen
			
				if(mode == READ){
					paylength inside {[46:1500]};		//Min to Max payload length TXBD LENGTH
					Payload.size() inside {paylength};	//Setting length to payload
					// queue randomize
					foreach(Payload[i])
					Payload[i]==i%255;
				}
				else paylength inside {[64:1518]};  		//RXBD LENGTH				
				}
				
			else	{//pad with no hugen
			
				if(mode == READ){
					paylength inside {[4:1500]};		//Min to Max payload length TXBD LENGTH
					
					// queue randomize
					if(paylength < 46)	{	//if length is less than 46 randomizing queue with length,and padding zeros at end.
						Payload.size() inside {46};
						foreach(Payload[i])	{
							if(i > paylength - 1) Payload[i] == 0;
							else Payload[i]==i%255;									
						}
					}
					else	{				//randomizing queue with length value.
						Payload.size() inside {paylength};	
						foreach(Payload[i])
						Payload[i]==i%255;
					}		
				}
				else paylength inside {[64:1518]};  		//RXBD LENGTH				
				}
		}
		
		else	{	//with huge
			if(!PAD)	{//hugen with no pad
			
				if(mode == READ){
					paylength inside {[46:2000]};		//Min to Max payload length TXBD LENGTH
					Payload.size() inside {paylength};	//Setting length to payload
					// queue randomize
					foreach(Payload[i])
					Payload[i]==i%255;
				}
				else paylength inside {[64:2018]};  		//RXBD LENGTH				
				}
				
			else	{//pad with  hugen
				
				if(mode == READ){
					paylength inside {[4:2000]};		//Min to Max payload length TXBD LENGTH
					
					// queue randomize
					if(paylength < 46)	{	//if length is less than 46 randomizing queue with length,and padding zeros at end.
						Payload.size() inside {46};
						foreach(Payload[i])	{
							if(i > paylength - 1) Payload[i] == 0;
							else Payload[i]==i%255;									
						}
					}
					else	{				//randomizing queue with length value.
						Payload.size() inside {paylength};	
						foreach(Payload[i])
						Payload[i]==i%255;
					}		
				}
				else paylength inside {[64:2018]};  		//RXBD LENGTH				
				}
		}

}//constraint end
  									
  									
  	constraint Payload_Multiple4 {
  									soft paylength % 4 == 0;
  									}
endclass
