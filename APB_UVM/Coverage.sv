//class Coverage;
class Coverage extends uvm_subscriber #(Transaction);
      `uvm_component_utils(Coverage);

	Transaction h_trans;   

//--------------------Covergroup   1 -------------------------------//

covergroup  cover_group1;     // cg1

//option.goal=80; 


/*
                  logic reset_n;
                  logic [`ADDR_WIDTH-1:0]paddress;
                  logic pwrite;
                  logic pselx;
                  logic penable;
                  logic [`DATA_WIDTH-1:0]pwdata;
                  logic  pslverr;                
                  logic  pready;
                  logic  [`DATA_WIDTH-1:0]prdata;
*/  

option.goal=90;   // Target goal for coveregroup instance,coverpoint or a cross 

option.at_least=1;    // Minimum number of each bin is to be consider covered.

//option.weight=100;// Specifies the weight of coverpoint when computing coverage of the covergroup.

option.name="BASAVA";

option.comment= " commmenting_in_CG ";

	reset_n_valid		:  coverpoint h_trans.reset_n   // nss=0 
						{
							bins reset_0={0};                     // explicit bin with valuee 0
							bins reset_1={1};              // ignore  bin with value 1

						}

	pselx_valid	:	coverpoint h_trans.pselx  iff(h_trans.reset_n==1)  // nss=1
						{
							bins slave_not_selected = {0};   // explicit bin
					        bins slave_selected = {1};
						}

	reset_n_valid_transitions		:  coverpoint h_trans.reset_n  
						{
							bins reset_0_to_1=(0=>1);            // transition from 0 to 1
							bins reset_1_to_0=(1=>0);            // transition from 1 to 0

						}

	P_Enable_valid_transitions		:  coverpoint h_trans.penable   iff( h_trans.reset_n==1 &&  h_trans.pselx==1 && (h_trans.pwrite==1 || h_trans.pwrite==0))

						{
							bins enable_0_to_1=(0=>1);            // transition from 0 to 1
							bins enable_1_to_0=(1=>0);            // transition from 1 to 0


						}


	penable_valid		:	coverpoint h_trans.penable  iff( h_trans.reset_n==1 &&  h_trans.pselx==1 && (h_trans.pwrite==1 || h_trans.pwrite==0))
						{
								bins enable_0 = {0};
								bins enable_1 = {1};
						}


pwrite_valid : coverpoint h_trans.pwrite iff(h_trans.reset_n==1 && h_trans.pselx==1 && ( h_trans.penable==0 || h_trans.penable==1))
					 {
								bins write_0={0};
								bins write_1={1};
		  			 }


slave_illegal : cross  pselx_valid,penable_valid,pwrite_valid iff(h_trans.reset_n==1)
					{
							illegal_bins illegal_slave=binsof(pselx_valid.slave_not_selected) ;
					}

address_label : coverpoint h_trans.paddress iff(h_trans.pselx && h_trans.reset_n && h_trans.penable && (h_trans.pwrite || h_trans.pwrite==0) );
data_label : coverpoint h_trans.pwdata iff(h_trans.pselx && h_trans.reset_n && h_trans.penable && h_trans.pwrite );           // implicitt bin or auto bin


		STATE_CHECK: cross pselx_valid,penable_valid {
						 	bins IDLE_state = binsof(pselx_valid) intersect {0} && binsof(penable_valid) intersect {0};
						 	bins SETUP_state = binsof(pselx_valid) intersect {1} && binsof(penable_valid) intersect {0};
						 	bins ACCESS_state = binsof(pselx_valid) intersect {1} && binsof(penable_valid) intersect {1};
							illegal_bins NO_STATE = binsof(pselx_valid) intersect {0} && binsof(penable_valid) intersect {1};
						 }


/*ADDR_WILD : coverpoint h_trans.P_ADDR iff(h_trans.pselx && h_trans.reset_n && h_trans.penable && (h_trans.pwrite && h_trans.pwrite==0) )
{
			wildcard bins addr1[]={32'b1???_????_????_????_????_????_????_????}; //covers all   cobnations
			wildcard bins addr2[]={32'b0???_????_????_????_????_????_????_????}; //covers all   cobnations
}
*/

// r s e w  cross  
// conditional cross and ncond cross

	endgroup
	
	        function new(string name= "Coverage",uvm_component parent);
                     super.new(name,parent);
                      cover_group1=new();
              endfunction

                   function void write(T t);
                          h_trans=Transaction::type_id::create("IN THE COVERAGE WRITE",this);
                           h_trans=t;
                               cover_group1.sample();
                   endfunction
	

endclass

