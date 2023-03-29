interface APB_intf(input pclk);

                  //logic pclk;
                  logic reset_n;
                  logic [`ADDR_WIDTH-1:0]paddress;
                  logic pwrite;
                  logic pselx;
                  logic penable;
                  logic [`DATA_WIDTH-1:0]pwdata;
                  logic  pslverr;                
                  logic  pready;
                  logic  [`DATA_WIDTH-1:0]prdata;


	clocking cb_driver@(posedge pclk);
		input pready,pslverr,prdata;
		output reset_n,pselx,paddress,pwdata,pwrite,penable;
	endclocking

	clocking cb_monitor@(posedge pclk);
		input #0 pready,pslverr,prdata;
		input  #0 reset_n,pselx,paddress,pwdata,pwrite,penable;
	endclocking

/*	property clock_period_check;
		real on_time,off_time;
		@(posedge pclk) (1,on_time = $realtime) ##1 (1,off_time = $realtime) ##0 off_time-on_time == period;
	endproperty
	assert property(clock_period_check);
*/
	property reset;
		@(posedge pclk) $fell(reset_n) |=> (pready==0) |-> (prdata==0) |-> (pslverr==0);
	endproperty
	assert property(reset) $display("PASS-------------RESET");
	else $display("FAIL-------------RESET\n");

	property write_access;
		@(posedge pclk) (pselx==0)|=>(pselx==1) |-> (pwrite==1) |->(penable==0) |=> (penable==1);
	endproperty
	assert property(write_access) $display("PASS-------------WRITE ACCESS");
	else $display("FAIL-------------WRITE ACCESS\n");

	property read_access;
		@(posedge pclk) (pselx==0)|=>(pselx==1) |-> (pwrite==0) |->(penable==0) |=> (penable==1);
	endproperty
	assert property(read_access) $display("PASS-------------READ ACCESS");
	else $display("FAIL-------------READ ACCESS\n");

	property write_access_conti;
		@(posedge pclk) (pselx==1) |-> (pwrite==1) |->(penable==0) |=> (penable==1)|->ready_seq|=>(pselx==1)|->(penable == 0);
	endproperty
	assert property(write_access_conti) $display("PASS-------------WRITE ACCESS CONTINUOUS");
	else $display("FAIL-------------WRITE ACCESS CONTINUOUS\n");

	property read_access_conti;
		@(posedge pclk) (pselx==1) |-> (pwrite==0) |->(penable==0) |=> (penable==1)|->ready_seq|=>(pselx==1)|->(penable == 0);
	endproperty
	assert property(read_access_conti) $display("PASS-------------READ ACCESS CONTINUOUS");
	else $display("FAIL-------------READ ACCESS CONTINUOUS\n");

	property state_status;
		@(posedge pclk) (pselx==0) |=> (pselx==1) |-> (penable==0) |=> (pselx==1) |-> (penable==1);
	endproperty
	assert property(state_status) $display("PASS-------------STATE");
	else $display("FAIL-------------STATE\n");

	sequence ready_seq;
		(pready==1)[->1];
	endsequence
	property ready;
		@(posedge pclk) (pselx==1) |-> (penable==0) |=> (pselx==1) |-> (penable==1)|->ready_seq;
	endproperty
	assert property(ready) $display("PASS-------------READY");
	else $display("FAIL-------------READY\n");

	sequence Error_seq;
		(pready==1 && pslverr==1)[->1];
	endsequence
	property error;
		@(posedge pclk) (pselx==1) |-> (penable==0) |=> (pselx==1) |-> (penable==1)|->Error_seq;
	endproperty
	assert property(error) $display("PASS-------------ERROR");
	else $display("FAIL-------------ERROR\n");


endinterface
