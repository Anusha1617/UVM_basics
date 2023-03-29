class nested_sequence   extends uvm_sequence;

`uvm_object_utils(nested_sequence)

Sequence_reset h_Sequence_reset;

Sequence_write_read h_Sequence_write_read;

Sequence_write_read_same_address h_Sequence_write_read_same_address;

Sequence_pselect   h_Sequence_pselect;

Sequence_direct_access_phase h_Sequence_direct_access_phase;

Sequence_write_read_data_address_change h_Sequence_write_read_data_address_change;

Sequence_write_read_slave_not_selected h_Sequence_write_read_slave_not_selected;

             function new(string name="seq");
                           super.new(name);
              endfunction



                task body();
                
                        h_Sequence_reset = Sequence_reset::type_id::create("h_Sequence_reset");
                
                        h_Sequence_write_read = Sequence_write_read::type_id::create("h_Sequence_write_read");
                        h_Sequence_write_read_same_address = Sequence_write_read_same_address::type_id::create("h_Sequence_write_read_same_address");
                        
                        h_Sequence_direct_access_phase = Sequence_direct_access_phase::type_id::create("h_Sequence_direct_access_phase");
                        h_Sequence_pselect = Sequence_pselect::type_id::create("h_Sequence_pselect");
                        h_Sequence_write_read_data_address_change = Sequence_write_read_data_address_change::type_id::create("h_Sequence_write_read_data_address_change");                        
                        h_Sequence_write_read_slave_not_selected = Sequence_write_read_slave_not_selected::type_id::create("h_Sequence_write_read_slave_not_selected");                        
                                                                                                
                     
                	      repeat(2) begin
                    	    h_Sequence_write_read.start(m_sequencer);   // done
                    	    #10
                    	    h_Sequence_write_read_same_address.start(m_sequencer);
                    	    #10
                      	    h_Sequence_direct_access_phase.start(m_sequencer);
                      	    #10
                      	  h_Sequence_pselect.start(m_sequencer);    
                      	       #10                                       
                      	  h_Sequence_write_read_data_address_change.start(m_sequencer);
                      	  
#10;
                       	  h_Sequence_write_read_slave_not_selected.start(m_sequencer);
                       	  #10;
                       	  
                        end
                   endtask



endclass
