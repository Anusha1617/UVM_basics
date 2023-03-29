class Scoreboard extends uvm_scoreboard;

`uvm_component_utils(Scoreboard) //1.factory register  


uvm_line_printer line;
uvm_table_printer my_table;
uvm_tree_printer tree;


	uvm_tlm_analysis_fifo #(Transaction) dut_fifo,tb_fifo;
	
	local	Transaction DUT_trans, TB_trans;
	
	

function new(string name="SCOREBOARD", uvm_component parent );  // component constructor
        super.new(name,parent);  // creating memory for parent class
endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		dut_fifo=new("dut_fifo",this);
		tb_fifo=new("tb_fifo",this);
 line=new();
 my_table=new();
tree=new();
		
		
		
	endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);

forever 
	begin
	
		dut_fifo.get(DUT_trans);
		tb_fifo.get(TB_trans);
		begin
			if(TB_trans.pslverr==DUT_trans.pslverr &&  DUT_trans.pready==TB_trans.pready && DUT_trans.prdata==TB_trans.prdata)
			begin
				$display("--------------------------------PASS IN SCOREBOARD---------------------------- \n ");
				$write("-------------%0t-----------DUT DATA\t",$time);
				DUT_trans.print(line);
				$write("--------%0t------INPUT MONITOR DATA\t",$time);
				TB_trans.print(line);
				
			end
			else
			begin
				$display("--------------------------------FAIL IN SCOREBOARD---------------------------- \n ");
								//DUT_trans.print(tree);
								//DUT_trans.print;
								//DUT_trans.print(my_table);
				$write("-------%0t-----------------DUT DATA\t",$time);
								DUT_trans.print(line);
				$write("--------%0t------INPUT MONITOR DATA\t",$time);
								TB_trans.print(line);
								
			end
			
		end		


	end
endtask	

endclass




