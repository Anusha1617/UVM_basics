class Sequencer extends uvm_sequencer #(Transaction);   // passing transaction as parameter

// doing nothing in sequencer  collect from the seqquence item and send it to the Driver

/*   if we not give Transaction as parameter
# ** Error: (vsim-8754) Actual input arg. of type 'class mtiUvm.uvm_pkg::uvm_seq_item_pull_imp #(class mtiUvm.uvm_pkg::uvm_sequence_item, class mtiUvm.uvm_pkg::uvm_sequence_item, class mtiUvm.uvm_pkg::uvm_sequencer #(class mtiUvm.uvm_pkg::uvm_sequence_item, class mtiUvm.uvm_pkg::uvm_sequence_item))' for formal 'provider' of 'connect' is not compatible with the formal's type 'class mtiUvm.uvm_pkg::uvm_port_base #(class mtiUvm.uvm_pkg::uvm_sqr_if_base #(class work.Pkg::Transaction, class work.Pkg::Transaction))'.
*/



`uvm_component_utils(Sequencer)   //1.factory register  
//
function new(string name="SEQUENCER",uvm_component parent);   // component constructor
        super.new(name,parent);  // creating memory for parent class
endfunction

endclass 
