

`include"Interface.sv"
//`include"dut.v"


package exam_pkg;

`include"uvm_macros.svh"
import uvm_pkg::*;

typedef Main_Env;
typedef Test;

typedef Seq_item;



// S AA = d+seqr+mon
typedef Slave_Env;

typedef Slave_A_agent;

            typedef Slave_seqr;
            typedef Slave_driver;
            typedef Slave_op_mo;
    
            typedef Slave_Seq;

typedef Mem_Env;

    typedef Mem_A_agent;

            typedef Mem_seqr;
            typedef Mem_driver;
            typedef Mem_ip_mo;

            typedef Mem_Seq_Item;

            typedef Mem_Seq;

    typedef Mem_P_agent;

            typedef Mem_op_mo;

typedef Tx_Env;
    
    typedef Tx_A_agent;
             typedef Tx_seqr;
             typedef Tx_driver;
             typedef Tx_op_mo;

            typedef Tx_Seq;
            typedef Tx_Seq_Item;



typedef Rx_Env;
    
    typedef Rx_A_agent;
             typedef Rx_driver;
             typedef Rx_seqr;
             typedef Rx_ip_mo;
`include"Tx_Seq.sv"
`include"Tx_Seq_Item.sv"


`include"Mem_Seq.sv"


`include"Slave_Seq.sv"

`include"Mem_Seq_Item.sv"

`include"Mem_Env.sv"
`include"Rx_A_agent.sv"
`include"Rx_seqr.sv"    
`include"Slave_A_agent.sv"   
`include"Tx_driver.sv"   
`include"Mem_A_agent.sv"   
`include"Mem_seqr.sv"     
`include"Rx_ip_mo.sv"  
`include"Slave_op_mo.sv"
`include"Slave_seqr.sv"    
`include"Tx_P_agent.sv"
`include"Main_Env.sv"   
`include"Mem_ip_mo.sv"  
`include"Mem_op_mo.sv"  
`include"Rx_driver.sv"  
`include"Slave_driver.sv"  
`include"TX_Env.sv"     
`include"Mem_driver.sv"  
`include"Rx_P_agent.sv"  
`include"Seq_item.sv"  
`include"Tx_A_agent.sv" 
`include"Tx_seqr.sv"
`include"Mem_P_agent.sv" 
`include"RX_Env.sv"  
`include"Slave_Env.sv"     
`include"Slave_P_agent.sv"   
`include"Test.sv"           
`include"Tx_op_mo.sv"   


endpackage
