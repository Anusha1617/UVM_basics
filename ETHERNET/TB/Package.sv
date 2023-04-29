

package pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

typedef Tx_Env;
    
    typedef Tx_A_agent;
             typedef Tx_seqr;
             typedef Tx_driver;
             typedef Tx_Op_Mon;

            typedef Tx_Seq;
            typedef Tx_Seq_Item;

typedef Mem_Env;
                typedef Mem_seqcr;
             typedef Mem_Driver;
             typedef Mem_input_monitor;
    typedef Mem_a_agent;    
typedef Mem_p_agent;



            typedef Mem_Seq;
            typedef Mem_seq_item;
typedef Mem_output_monitor;


typedef Tx_Coverage;

typedef Main_Environment;


typedef Config_class;

typedef Scoreboard;

//498
typedef Base_Seq;
typedef Host_Seq1;
typedef Host_Seq2;
typedef Host_Seq3;

typedef Base_Test;
typedef Test1;


typedef Host_Driver;
typedef Host_Ip_Monitor;
typedef Host_Sequencer;
typedef Host_Passive_agent;
typedef Host_Op_Monitor;
typedef Host_Seq_item;

//--------------------Sequences-----------------------//
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv_05_ethernet_project_SEQ_Libary/mcs_dv05_ethernet_project_host_Base_Sequence.sv" // Base Seq

`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv_05_ethernet_project_SEQ_Libary/mcs_dv05_ethernet_project_host_Sequence1.sv"   //Seq 1
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv_05_ethernet_project_SEQ_Libary/mcs_dv05_ethernet_project_host_Sequence2.sv"   //Seq 2
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv_05_ethernet_project_SEQ_Libary/mcs_dv05_ethernet_project_host_Sequence3.sv"   //Seq 3


//-------------------Tests--------------------------//
`include"../mcs_dv05_ethernet_project_test/mcs_dv05_ethernet_project_Test_Library/mcs_dv05_ethernet_project_Base_Test.sv"   // Base Test
`include"../mcs_dv05_ethernet_project_test/mcs_dv05_ethernet_project_Test_Library/mcs_dv05_ethernet_project_Test1.sv"       // Test 1




	`include "../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_scoreboard.sv"
`include"../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_coverage.sv"
	`include "../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence_item/mcs_dv05_ethernet_project_host_sequence_item.sv"

	`include "../mcs_dv05_ethernet_project_top/mcs_dv05_ethernet_project_top_config.sv"
//Host environmrnt
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_active_agent/mcs_dv05_ethernet_project_sequencer.sv"
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_active_agent/mcs_dv05_ethernet_project_driver.sv"
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_active_agent/mcs_dv05_ethernet_project_ip_monitor.sv"
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_active_agent/mcs_dv05_ethernet_project_active_agent.sv"
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_passive_agent/mcs_dv05_ethernet_project_monitor.sv"
	`include "../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_host_agent/mcs_dv05_ethernet_project_passive_agent/mcs_dv05_ethernet_project_agent.sv"

	`include "../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_host_env/mcs_dv05_ethernet_project_host_env.sv"

	`include "../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_main_env.sv"

// tx env

`include"../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_TX_MAC_env/mcs_dv05_ethernet_project_TX_MAC_env.sv"
//agent
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_TX_MAC/mcs_dv05_ethernet_project_agent.sv"
//drv

`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_TX_MAC/mcs_dv05_ethernet_project_driver.sv"

//mon
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_TX_MAC/mcs_dv05_ethernet_project_op_monitor.sv"
//seqr
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_TX_MAC/mcs_dv05_ethernet_project_sequencer.sv"

//seq
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_TX_MAC_sequence.sv"

// seq item
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence_item/mcs_dv05_ethernet_project_TX_MAC_sequence_item.sv"  // include 1


// MEM ENV

`include"../mcs_dv05_ethernet_project_main_env/mcs_dv05_ethernet_project_mem_env/mcs_dv05_ethernet_project_mem_env.sv"
// aa
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_active_agent/mcs_dv05_ethernet_project_agent.sv"
//drv
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_active_agent/mcs_dv05_ethernet_project_driver.sv"


// mon
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_active_agent/mcs_dv05_ethernet_project_monitor.sv"


//seqr
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_active_agent/mcs_dv05_ethernet_project_sequencer.sv"

//pa
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_passive_agent/mcs_dv05_ethernet_project_agent.sv"
// op mo
`include"../mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_mem_agent/mcs_dv05_ethernet_passive_agent/mcs_dv05_ethernet_project_monitor.sv"
// seq
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_mem_sequence.sv"

//seq item
`include"../mcs_dv05_ethernet_project_sequence/mcs_dv05_ethernet_project_sequence_item/mcs_dv05_ethernet_project_mem_sequence_item.sv"



endpackage



//mcs_dv05_ethernet_project_agents/mcs_dv05_ethernet_project_TX_MAC
