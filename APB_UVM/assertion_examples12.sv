
module dpr_assertions(

   input [`BUS_WIDTH-1:0] dina,dinb,
   input [2:0] addra,addrb,
   input clk1,ena,wea,
   input clk2,enb,web,
   input  [`BUS_WIDTH-1:0] douta,doutb,
   input [`BUS_WIDTH]ram[7:0]);

real period1=100;
real period2=98;

//=================1===========clock_period_checks================================//

	property clock_period_check1;
		realtime on_time,off_time;
		@(posedge clk1) (1,on_time = $realtime) ##1 (1,off_time = $realtime) ##0 off_time-on_time == period1;
	endproperty


clock_check1_label : assert property(clock_period_check1) else $error($time,"-------------------------clock_period_check 1 FAILED---------\n-----------%m-----------");

	property clock_period_check2;
		real on_time2,off_time2;
		@(posedge clk2) (1,on_time2 = $realtime) ##1 (1,off_time2 = $realtime) ##0 off_time2-on_time2 == period2;
	endproperty


clock_check2_label : assert property(clock_period_check2) else $error($time,"-------------------------clock_period_check 2 FAILED---------\n-----------%m-----------");


cover property(clock_period_check1);
cover property(clock_period_check2);


    property write_check1;
        @(posedge clk1) 
        (ena && wea && !web ) |=> (ram[$past(addra)]==$past(dina));
    endproperty

write_check1_label : assert property(write_che$time,"\n--------------------------------apb_clk_period_check Failed---------------------\n------------ %m------------------"ck1) $display("a write pass"); else $error($time,"----------------WRITE CHECK ERROR  A---------------------");

write_check1_covered : cover property(write_check1);


    property write_check2;
        @(posedge clk2) 
        (enb && web && !wea ) |=> (ram[$past(addrb)]==$past(dinb));
    endproperty

write_check2_label : assert property(write_check2) $display("b write pass"); else $error($time,"----------------WRITE CHECK ERROR  B---------------------");

write_check2_covered : cover property(write_check2);

    
    property read_check1;
        @(posedge clk1) disable iff($isunknown(douta))
        (ena && !wea && !web ) |=> (ram[$past(addra)]==douta);
    endproperty

read_check1_p : assert property(read_check1) $display("a read pass"); else $error($time,"----------------READ CHECK ERROR  A---------------------");
We take the values of output signals of TX MAC dut to here via interface
forever
begin
    sequence_item_port.get_next_item(req)
  req.mtx_err<=h_vintf.mtx_err;
  req.mtx_en<=h_vintf.mtx_en;
  req.mtx_d<=h_vintf.mtx_d;
 analysis_port_handle.write(req);
    sequence_item_port.item_done(req)
end
read_check1_covered : cover property(read_check1);

    property read_check2;
        @(posedge clk2) disable iff($isunknown(doutb))
        (enb && !web && !wea ) |=> (ram[$past(addrb)]==doutb);
    endproperty

read_check2_p : assert property(read_check2) $display("b read pass"); else $error($realtime,"----------------READ CHECK ERROR  B---------------------");

read_check2_covered : cover property(read_check1);



    property write_1_read_2;
        bit [7:0]local_past_data;
        bit [2:0]local_past_addr;
           @(posedge clk1) (ena && wea /*&& !enb*/) |-> (1,local_past_addr=addra) |-> (1,local_past_data=dina) ##0 @(posedge clk2) (!ena && enb && !web)  |-> (addrb==local_past_addr) |=> (local_past_data==doutb);        
    endproperty
write_1_read_2_p : assert property(write_1_read_2) $display($time,"w1r2 pass doutb=%0d ",$past(doutb)); else $error("w1r2 fail");

write_1_read_2_c :cover property(write_1_read_2);

    property write_2_read_1;
        bit[7:0] local_past_data;
        bit [2:0]local_past_addr;
            @(posedge clk2) (enb && web) |-> (1,local_past_addr=addrb) |-> (1,local_past_data=dinb) ##0 @(posedge clk1 ) (!enb && ena && !wea) |-> (addra==local_past_addr) |=> (local_past_data==douta); 
    endproperty


write_2_read_1_p : assert property(write_2_read_1) $display($time," write_2_read_1 PASS "); else $error ("write_2_read_1 fail ");

write_2_read_1_cp : cover property(write_2_read_1);


endmodule
  
  
  module assertions(input [7:0] dina,dinb,douta,doutb,
					 input [2:0] addra,addrb,
					 input ena,enb,clka,clkb,wea,web);

	//==================================================================================//
	//----------------------------------- ASSERTIONS -----------------------------------//
	//==================================================================================//

	//--------------------------------Clock validations
	property clocka_check(period);
		real time1,time2;
		@(posedge clka) (1,time1=$realtime) ##1 (1,time2=$realtime) ##0 (time2-time1 == period);
	endproperty
	assert property(clocka_check(10000));//*/

	property clockb_check;
		real period = 9800;
		real time1,time2;
		@(posedge clkb) (1,time1=$realtime)
		  |=> (1,time2=$realtime)//,$display("T1-%t T2-%0t period = %t, %t",time1,time2,period,time2-time1))
		  |-> time2-time1 == period;
	endproperty
	assert property(clockb_check);//*/

	//---------------------------------
	property ena_disable;
		@(posedge clka) ena==0|-> !$isunknown(douta) |=> $past(douta)==douta;
	endproperty
	assert property (ena_disable) $display("PASS------------Port A enable signal data out check");
	else $display("FAIL------------Port A enable signal data out check",$stime);

	property enb_disable;
		@(posedge clkb) enb==0|-> !$isunknown(doutb) |=> $past(doutb)==doutb;
	endproperty
	assert property (enb_disable) $display("PASS------------Port B enable signal data out check");
	else $display("FAIL------------Port B enable signal data out check",$stime);

	property douta_stable_when_writing;
		@(posedge clka) ena |-> wea |-> !$isunknown(douta) |=> douta==$past(douta);
	endproperty
	assert property(douta_stable_when_writing) $display("PASS------------PORT A data out is stable when writing");
	else $display("FAIL------------PORT A data out is stable when writing",$stime);

	property doutb_stable_when_writing;
		@(posedge clkb) enb |-> web |-> !$isunknown(doutb) |=> doutb==$past(doutb);
	endproperty
	assert property(doutb_stable_when_writing) $display("PASS------------PORT B data out is stable when writing");
	else $display("\nFAIL------------PORT B data out is stable when writing",$stime);

	property write_read_porta_same_address;
		@(posedge clka) ena |-> wea
									|-> (!enb or (enb and !web) or (enb and web and addra!=addrb))
		  							|=> ena |-> !wea |-> addra==$past(addra)
		  							|=> douta==$past(dina,2);
	endproperty
	assert property(write_read_porta_same_address)  $display("PASS------------PORT A writing and reading independent of port B");
	else $display("\nFAIL------------PORT A writing and reading independent of port B",$stime);

	property write_read_portb_same_address;
		@(posedge clkb) enb |-> web
									|-> (!ena or (ena and !wea) or (ena and wea and addra!=addrb))
		  							|=> enb |-> !web |-> addrb==$past(addrb)
		  							|=> doutb==$past(dinb,2);
	endproperty
	assert property(write_read_porta_same_address)  $display("PASS------------PORT B writing and reading independent of port A");
	else $display("\nFAIL------------PORT B writing and reading independent of port A",$stime);

	property write_a_read_b;
		bit [2:0] prop_addra;
		bit [7:0] prop_dina;
		@(posedge clka) (ena and wea)|->(1,prop_addra=addra)|->(1,prop_dina=dina) ##0 @(posedge clkb) (enb and !web) |-> addrb==prop_addra |=> doutb==prop_dina;
	endproperty
	assert property(write_a_read_b) $display("PASS------------Writing A Reading B");
	else $display("\nFAIL------------Writing A Reading B",$stime);

	property write_b_read_a;
		bit [2:0] prop_addrb;
		bit [7:0] prop_dinb;
		@(posedge clkb) (enb and web)|->(1,prop_addrb=addrb)|->(1,prop_dinb=dinb) ##0 @(posedge clka) (ena and !wea) |-> addra==prop_addrb |=> douta==prop_dinb;
	endproperty
	assert property(write_b_read_a) $display("PASS------------Writing B Reading A");
	else $display("\nFAIL------------Writing B Reading A",$stime);

	property read_a_read_b;
		bit [2:0] prop_addra;
		@(posedge clka) (ena and !wea) |-> (1,prop_addra=addra) ##0 @(posedge clkb) (enb and !web) |-> addrb==prop_addra |=> $past(douta) == doutb;
	endproperty
	assert property(read_a_read_b) $display("PASS------------Reading A Reading B");
	else $display("\nFAIL------------Reading A Reading B",$stime);

	property read_b_read_a;
		bit [2:0] prop_addrb;
		@(posedge clkb) (enb and !web) |-> (1,prop_addrb=addrb) ##0 @(posedge clka) (ena and !wea) |-> addra==prop_addrb |=> $past(doutb) == douta;
	endproperty
	assert property(read_b_read_a) $display("PASS------------Reading B Reading A");
	else $display("\nFAIL------------Reading B Reading A",$stime);
endmodule
