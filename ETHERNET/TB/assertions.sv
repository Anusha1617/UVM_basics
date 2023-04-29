module Eth_Assertions(
input   pclk_i,
input   prstn_i,
input  [31:0] pwdata_i,
input [31:0]  prdata_o,
input [31:0]  paddr_i,
input   psel_i,
input   pwrite_i,
input   penable_i,
input   pready_o,
input [31:0]  m_paddr_o,
input   m_psel_o,
input   m_pwrite_o,
input [31:0]  m_pwdata_o,
input [31:0]  m_prdata_i,
input   m_penable_o,
input   m_pready_i,
input   int_o,
input   MTxClk,
input [3:0]  MTxD,
input   MTxEn,
input   MTxErr,
input   MRxClk,
input [3:0]  MRxD,
input   MRxDV,
input   MRxErr,
input   MCrS);

real APB_Period=40;
real Tx_Period=400;


//----------------ASSERTIONS-----------------------------//


//------APB_clk_period_check-----------------//
property APB_clk_period_check;

realtime on_time,off_time;

@(posedge pclk_i)   (1,on_time=$realtime)  ##1 (1,off_time=$realtime) ##0 off_time-on_time==APB_Period;

endproperty

apb_clk_period_check_label : assert property(APB_clk_period_check)  else $error($time,"\n--------------------------------apb_clk_period_check Failed---------------------\n------------ %m------------------");

cover property(APB_clk_period_check);

// --Tx_clk_period_check----------------------//

property Tx_clk_period_check;

realtime on_time,off_time;

@(posedge MTxClk)   (1,on_time=$realtime)  ##1 (1,off_time=$realtime)  ##0 off_time-on_time==Tx_Period;

endproperty

Tx_clk_period_check_label : assert property(Tx_clk_period_check) else $error($time,"\n--------------------------------Tx_clk_period_check Failed---------------------\n------------ %m------------------");


cover property(Tx_clk_period_check);


//-----reset_check----------------------------------//
property reset_check;

@(posedge pclk_i) !prstn_i |=>  (prdata_o== 0 && pready_o==0 && m_paddr_o==0 && m_psel_o==0 && m_pwrite_o==0 && m_pwdata_o==0 && m_penable_o==0 && int_o==0 && MTxD==0 && MTxEn==0 && MTxErr==0) 
// check registers
endproperty

reset_check_label : assert property(reset_check) else $error($time,"\n--------------------------------------reset_check-------------------------\n-------------%m---------------------------");

cover property(reset_check);

//-----protocol_check-----------------------------//
property protocol_check;

bit l_pwrite_i;  //pwrite_i
bit [31:0]  l_pwdata_i,l_paddr_i;  //pwdata_i  paddr_i

@(posedge pclk_i) disable iff(!prstn_i) psel_i |-> (1,l_paddr_i=paddr_i) ##0 (1,l_pwdata_i=pwdata_i) ##0 (1,l_pwrite_i=pwrite_i) ##1 (penable_i  &&  l_paddr_i==paddr_i && l_pwdata_i==pwdata_i && l_pwrite_i==pwrite_i ) ##[0:1] pready_o==1 ;

endproperty

protocol_check_label : assert property(protocol_check) else $error($time,"\n ------------------------------------protocol_check-------------\n------------------%m----------------------");

cover property(protocol_check);











endmodule
