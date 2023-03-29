
//--------------------TIMESCALE----------------------------//

`define timescale 1ns/1ps    //    precision = 3


//`define CLK_PERIOD 2
`define DUT_MODULE_NAME  apb_logi
`define DATA_WIDTH 32
`define ADDR_WIDTH 32
`define LOCATIONS  256

`define WAIT_PULSES 0



`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_INTF/MCS_DV05_APB_Interface.sv"
`include"../../MCS_DV05_APB_RTL/MCS_DV05_APB_DUT.v"

`include "../MCS_DV05_APB_TOP/MCS_DV05_APB_Top.sv"    // first it will be executed

package Pkg; 


`include"uvm_macros.svh"  // including all the uvm macros  like uvm_object_utils


import uvm_pkg :: * ;   // including the all the pkg components


//`include"uvm_pkg.sv"

        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV05_APB_Sequence_item.sv"
        
                `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_direct_access_phase.sv"        
        
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_pselect.sv"        
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_reset.sv"                                
                        
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_write_read.sv"                                        
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_write_read_data_address_change.sv"                                
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_write_read_same_address.sv"                                
                                               // `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_write_read_same_address.sv"                                
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_Sequence_write_read_slave_not_selected.sv"                                                                                        
                        `include "../MCS_DV05_APB_SEQUENCE/MCS_DV_05_APB_nested_Sequence.sv"
                    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_MASTER_AGENT/MCS_DV05_APB_Sequencer.sv"                        
               //        `include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_INTF/MCS_DV05_APB_Sequence.sv"
                    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_MASTER_AGENT/MCS_DV05_APB_Driver.sv"



        // new driver
    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_MASTER_AGENT/MCS_DV05_APB_Input_Monitor.sv"
    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_SLAVE_AGENT/MCS_DV05_APB_Output_Monitor.sv"
    
    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_MASTER_AGENT/MCS_DV05_APB_Master_Agent.sv"
    	`include "../MCS_DV05_APB_AGENT/MCS_DV05_APB_SLAVE_AGENT/MCS_DV05_APB_Slave_Agent.sv"
       	`include "../MCS_DV05_APB_ENV/MCS_DV05_APB_Coverage.sv"
    	`include "../MCS_DV05_APB_ENV/MCS_DV05_APB_Scoreboard.sv"
    	`include "../MCS_DV05_APB_ENV/MCS_DV05_APB_Environment.sv"

    
    	`include "MCS_DV05_APB_Test.sv"   // same location

endpackage

