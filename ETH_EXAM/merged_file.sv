interface Ethernet_Intf(input pclk_i,MTxClk);

logic prstn_i;
logic[31:0] paddr_i;
logic [31:0]pwdata_i;
logic [31:0]prdata_o;
logic psel_i;
logic pwrite_i;
logic penable_i;
logic pready_o;
logic int_o;


logic[31:0] m_paddr_o;
logic [31:0]m_pwdata_o;
logic m_psel_o;
logic m_pwrite_o;
logic m_penable_o;
logic [31:0]m_prdata_i;
logic m_pready_i;



logic [3:0]MTxD;
logic MTxEn;
logic MTxErr;
logic MCrS;






clocking Slave_cb_driver@(posedge pclk_i);

output #0 prstn_i;
output #0 paddr_i;
output #0 pwdata_i;
output #0 psel_i;
output #0 pwrite_i;
output #0 penable_i;
input #0 pready_o;
input #0 prdata_o;
input #0 int_o;



endclocking

clocking Slave_cb_monitor@(posedge pclk_i);

input #0 prstn_i;
input #0 paddr_i;
input #0 pwdata_i;
input #0 psel_i;
input #0 pwrite_i;
input #0 penable_i;
input #0 pready_o;
input #0 prdata_o;
input #0 int_o;



endclocking

clocking Mem_cb_driver@(posedge pclk_i);


input   m_paddr_o;
input  m_pwdata_o;
input  m_psel_o;
input  m_pwrite_o;
input  m_penable_o;

output m_prdata_i;
output m_pready_i;

endclocking

clocking Mem_cb_monitor@(posedge pclk_i);


input #0    m_paddr_o;
input #0   m_pwdata_o;
input #0   m_psel_o;
input #0   m_pwrite_o;
input #0   m_penable_o;
input #0  m_prdata_i;
input #0  m_pready_i;

endclocking

clocking Tx_cb_driver@(posedge MTxClk);
input MTxD;
input MTxEn;
input MTxErr;
input int_o;

output MCrS;

endclocking

clocking Tx_cb_monitor@(posedge MTxClk);
input #0  MTxD;
input #0 MTxEn;
input #0 MTxErr;
input #0 MCrS;
input #0 int_o;

endclocking


endinterface
class Mem_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_A_agent)

Mem_driver h_Mem_driver;

Mem_seqr h_Mem_seqr;

Mem_ip_mo h_Mem_ip_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Mem_driver=Mem_driver::type_id::create("h_Mem_driver",this); 
	 h_Mem_seqr=Mem_seqr::type_id::create("h_Mem_seqr",this);
	 h_Mem_ip_mo=Mem_ip_mo::type_id::create("h_Mem_ip_mo",this);
endfunction

function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Mem_driver.seq_item_port.connect(h_Mem_seqr.seq_item_export);
endfunction





endclass
class Mem_driver extends uvm_driver#(Mem_Seq_Item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_driver)

virtual Ethernet_Intf h_Ethernet_Intf;

bit [32] addr;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction


task  run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever @(h_Ethernet_Intf.Mem_cb_driver)
        begin
                seq_item_port.get_next_item(req);
                        if(h_Ethernet_Intf.m_psel_o==1 && h_Ethernet_Intf.penable_i==1 )
                            begin 
                                h_Ethernet_Intf.m_pready_i<=1;
                                addr=h_Ethernet_Intf.m_paddr_o;
                                h_Ethernet_Intf.m_prdata_i<={req.memory[addr]+req.memory[addr+1]+req.memory[addr+2],req.memory[addr+3]};
                            end             
                            else 
                                begin   
                                    h_Ethernet_Intf.m_pready_i<=0;
                                    h_Ethernet_Intf.m_prdata_i<=0;
                                end
                                //$display("INSIDE THE MEMORY DRIVER %0d %0d",h_Ethernet_Intf.m_prdata_i,h_Ethernet_Intf.m_pready_i);
                seq_item_port.item_done();
        end

endtask




endclass
class Mem_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_Env)

Mem_A_agent h_Mem_A_agent;
Mem_P_agent h_Mem_P_agent;

Mem_Seq h_Mem_Seq;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Mem_A_agent=Mem_A_agent::type_id::create("h_Mem_A_agent",this); 
	 h_Mem_P_agent=Mem_P_agent::type_id::create("h_Mem_P_agent",this); 
	 h_Mem_Seq=Mem_Seq::type_id::create("h_Mem_Seq"); 
endfunction

endclass
class Mem_ip_mo extends uvm_monitor;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_ip_mo)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Mem_op_mo extends uvm_monitor;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_op_mo)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Mem_P_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_P_agent)


Mem_op_mo h_Mem_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Mem_op_mo=Mem_op_mo::type_id::create("h_Mem_op_mo",this);
endfunction







endclass
class Mem_Seq_Item extends uvm_sequence_item;
`uvm_object_utils(Mem_Seq_Item)


bit[32] m_paddr_o;
bit [32]m_pwdata_o;
bit m_psel_o;
bit m_pwrite_o;
bit m_penable_o;
bit [32]m_prdata_i;
bit m_pready_i;


bit[7:0] memory[256000];




// component constructor 
function new(string name="");
		super.new(name);
endfunction


endclass
class Mem_seqr extends uvm_sequencer #(Mem_Seq_Item);


//------FACTORY Registration----------------//
	`uvm_component_utils(Mem_seqr)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Mem_Seq extends uvm_sequence#(Mem_Seq_Item);



//------FACTORY Registration----------------//
	`uvm_object_utils(Mem_Seq)


// object constructor 
function new(string name="");
		super.new(name);
endfunction


        task body();
        req=Mem_Seq_Item::type_id::create("req in mem_seq");

                         repeat(1000)
                            begin   
                                  start_item(req);
                                     finish_item(req);
                             end


        endtask


endclass


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
class Rx_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_A_agent)

Rx_driver h_Rx_driver;

Rx_seqr h_Rx_seqr;

Rx_ip_mo h_Rx_ip_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Rx_driver=Rx_driver::type_id::create("h_Rx_driver",this); 
	 h_Rx_seqr=Rx_seqr::type_id::create("h_Rx_seqr",this);
	 h_Rx_ip_mo=Rx_ip_mo::type_id::create("h_Rx_ip_mo",this);
endfunction







endclass
class Rx_driver extends uvm_driver#(Seq_item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction







endclass
class Rx_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_Env)

Rx_A_agent h_Rx_A_agent;
//Rx_P_agent h_Rx_P_agent;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Rx_A_agent=Rx_A_agent::type_id::create("h_Rx_A_agent",this); 
	// h_Rx_P_agent=Rx_P_agent::type_id::create("h_Rx_P_agent",this); 
endfunction

endclass
class Rx_ip_mo extends uvm_monitor;


//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_ip_mo)

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Rx_P_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_P_agent)


Rx_ip_mo h_Rx_ip_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Rx_ip_mo=Rx_ip_mo::type_id::create("h_Rx_ip_mo",this);
endfunction







endclass
class Rx_seqr extends uvm_sequencer;


//------FACTORY Registration----------------//
	`uvm_component_utils(Rx_seqr)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Seq_item extends uvm_sequence_item;
`uvm_object_utils(Seq_item)

rand bit  prstn_i;
rand bit [31:0] paddr_i;
rand bit  [31:0]pwdata_i;
rand bit  [31:0]prdata_o;

rand bit  psel_i;
rand bit  pwrite_i;
rand bit  penable_i;


rand enum int{MODER=0,INT_SOURCE='h04,INT_MASK='h08,TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44} reg_addr;

//rand bit[31:0] BD_ADDR;


bit  pready_o;
bit  int_o;

constraint c1{   solve reg_addr before paddr_i;
    
    soft  psel_i==1;
    soft pwrite_i==1;
    soft penable_i==0;
//    BD_ADDR iniside {['h400:'h7ff] with item%4==0; } ;

//  paddr_i inside {reg_addr};
    
    }



// component constructor 
function new(string name="");
		super.new(name);
endfunction



function void post_randomize();
        //if(paddr_i==TX_BD_NUM)
          //  pwdata_i=128;
         case(paddr_i)
         TX_BD_NUM:begin pwdata_i=128; end

         MIIADDRESS:begin pwdata_i=32'b11111; end
         MAC_ADDR0:begin pwdata_i=96; end
         MAC_ADDR1:begin pwdata_i=69; end

         INT_MASK:begin pwdata_i=0; end
         INT_SOURCE:begin pwdata_i=0; end
         MODER:begin pwdata_i=128; end


         endcase

endfunction





endclass
class Slave_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_A_agent)

Slave_driver h_Slave_driver;

Slave_seqr h_Slave_seqr;

Slave_op_mo h_Slave_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	 h_Slave_driver=Slave_driver::type_id::create("h_Slave_driver",this); 
	 h_Slave_seqr=Slave_seqr::type_id::create("h_Slave_seqr",this);
	 h_Slave_op_mo=Slave_op_mo::type_id::create("h_Slave_op_mo",this);
endfunction


function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Slave_driver.seq_item_port.connect(h_Slave_seqr.seq_item_export);
endfunction

endclass
class Slave_driver extends uvm_driver#(Seq_item);

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	        req=Seq_item::type_id::create("req in driver");
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction



task  run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever @(h_Ethernet_Intf.Slave_cb_driver)
        begin
                seq_item_port.get_next_item(req);
                      /*  h_Ethernet_Intf.prstn_i<=req.prstn_i;
                        h_Ethernet_Intf.paddr_i<=req.paddr_i;
                        h_Ethernet_Intf.pwdata_i<=req.pwdata_i;
                        h_Ethernet_Intf.psel_i<=req.psel_i;
                        h_Ethernet_Intf.pwrite_i<=req.pwrite_i;
                        h_Ethernet_Intf.penable_i<=req.penable_i;
                        `uvm_info("DRV",$sformatf("IN DRIVER  %p ",req),UVM_LOW);

                        */
                                h_Ethernet_Intf.prstn_i<=1;
                                h_Ethernet_Intf.paddr_i<=req.paddr_i;
                                h_Ethernet_Intf.pwdata_i<=req.pwdata_i;
                                h_Ethernet_Intf.psel_i<=1;
                                h_Ethernet_Intf.pwrite_i<=req.pwrite_i;
                                h_Ethernet_Intf.penable_i<=0;

                                @(h_Ethernet_Intf.Slave_cb_driver)
                                h_Ethernet_Intf.penable_i<=1;

                                @(h_Ethernet_Intf.Slave_cb_driver)




                        req.print();
                seq_item_port.item_done();
        end

endtask






endclass


/*

output #0 prstn_i;
output #0 paddr_i;
output #0 pwdata_i;
output #0 psel_i;
output #0 pwrite_i;
output #0 penable_i;
input #0 pready_o;
input #0 prdata_o;
input #0 int_o;



*/
class Slave_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_Env)

Slave_A_agent h_Slave_A_agent;
//Slave_P_agent h_Slave_P_agent;

Slave_Seq h_Slave_Seq;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Slave_A_agent=Slave_A_agent::type_id::create("h_Slave_A_agent",this); 
	 h_Slave_Seq=Slave_Seq::type_id::create("h_Slave_Seq"); 


	// h_Slave_P_agent=Slave_P_agent::type_id::create("h_Slave_PA_agent",this); 
endfunction

endclass
class Slave_op_mo extends uvm_monitor;


//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_op_mo)

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Slave_P_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_P_agent)


Slave_op_mo h_Slave_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Slave_op_mo=Slave_op_mo::type_id::create("h_Slave_op_mo",this);
endfunction







endclass
class Slave_seqr extends uvm_sequencer#(Seq_item);


//------FACTORY Registration----------------//
	`uvm_component_utils(Slave_seqr)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction







endclass
class Slave_Seq extends uvm_sequence#(Seq_item);



//------FACTORY Registration----------------//
	`uvm_object_utils(Slave_Seq)


enum int{MODER=0,INT_SOURCE='h04,INT_MASK='h08,TX_BD_NUM='h20,MIIADDRESS='h30,MAC_ADDR0='h40,MAC_ADDR1='h44} reg_addr;
// object constructor 
function new(string name="");
		super.new(name);
endfunction


        task body();
        req=Seq_item::type_id::create("req in seq");

                         repeat(10)
                            begin   
        start_item(req);
                                   assert(req.randomize() with { paddr_i==reg_addr.next;}  );   //   TX_BD_NUM configuration
         finish_item(req);
                             end


        endtask

/*task_
        start_item(req);
                         repeat(1)
                            begin   
                                   assert(req.randomize() with { paddr_i==TX_BD_NUM; pwdata_i==128;}  );   //   TX_BD_NUM configuration
                             end
         finish_item(req);
*/

endclass
class Test extends uvm_test;

//------FACTORY Registration----------------//
	`uvm_component_utils(Test)

Main_Env h_Main_Env;

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
 h_Main_Env=Main_Env::type_id::create("h_Main_Env",this);
// uvm_test_top.enable_print_topology();
 print;
endfunction



function void end_of_elaboration_phase(uvm_phase phase);
	super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction


task run_phase(uvm_phase phase);
    super.run_phase(phase);
        phase.raise_objection(this,"raised objection");    
        fork
            h_Main_Env.h_Slave_Env.h_Slave_Seq.start(h_Main_Env.h_Slave_Env.h_Slave_A_agent.h_Slave_seqr);
            h_Main_Env.h_Mem_Env.h_Mem_Seq.start(h_Main_Env.h_Mem_Env.h_Mem_A_agent.h_Mem_seqr);
            h_Main_Env.h_Tx_Env.h_Tx_Seq.start(h_Main_Env.h_Tx_Env.h_Tx_A_agent.h_Tx_seqr);
         join
        phase.drop_objection(this,"dropped_objection");

endtask






endclass
`include"Package.sv"

module top;

bit MTxClk;
import uvm_pkg::*;
import exam_pkg::*;


bit pclk_i;

always #400 pclk_i++;
always #40 MTxClk++;



Ethernet_Intf h_intf(pclk_i,MTxClk);

//dut insta

initial begin
		uvm_config_db #(virtual Ethernet_Intf ) :: set(null,"*","key",h_intf);  // set interface in configdb
			
		run_test("Test"); // calling run_test method

end

endmodule 
class Tx_A_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_A_agent)

Tx_driver h_Tx_driver;

Tx_seqr h_Tx_seqr;

Tx_op_mo h_Tx_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_driver=Tx_driver::type_id::create("h_Tx_driver",this); 
	 h_Tx_seqr=Tx_seqr::type_id::create("h_Tx_seqr",this);
	 h_Tx_op_mo=Tx_op_mo::type_id::create("h_Tx_op_mo",this);
endfunction


function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            h_Tx_driver.seq_item_port.connect(h_Tx_seqr.seq_item_export);
endfunction




endclass
class Tx_driver extends uvm_driver;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_driver)

virtual Ethernet_Intf h_Ethernet_Intf;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
		assert(uvm_config_db #(virtual Ethernet_Intf ) :: get(this,this.get_full_name(),"key",h_Ethernet_Intf));  // set interface in configdb
endfunction

task  run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever @(h_Ethernet_Intf.Tx_cb_driver)
        begin
                h_Ethernet_Intf.Tx_cb_driver.MCrS<=0;
                seq_item_port.get_next_item(req);
                if(h_Ethernet_Intf.Tx_cb_driver.int_o)
                    h_Ethernet_Intf.MCrS<=0;
                  else if(h_Ethernet_Intf.MTxEn==1)
                        h_Ethernet_Intf.Tx_cb_driver.MCrS<=1;
                seq_item_port.item_done();
        end

endtask





endclass
class Tx_Env extends uvm_env;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_Env)

Tx_A_agent h_Tx_A_agent;
//Tx_P_agent h_Tx_P_agent;

Tx_Seq  h_Tx_Seq ;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_A_agent=Tx_A_agent::type_id::create("h_Tx_A_agent",this); 
	// h_Tx_P_agent=Tx_P_agent::type_id::create("h_Tx_P_agent",this); ;

	 h_Tx_Seq=Tx_Seq::type_id::create("h_Tx_Seq");


endfunction

endclass
class Tx_op_mo extends uvm_monitor;


//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_op_mo)

// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction


endclass
class Tx_P_agent extends uvm_agent;

//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_P_agent)


Tx_op_mo h_Tx_op_mo;


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

//-----buildphase----------//
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	 h_Tx_op_mo=Tx_op_mo::type_id::create("h_Tx_op_mo",this);
endfunction







endclass
class Tx_Seq_Item extends uvm_sequence_item;
`uvm_object_utils(Tx_Seq_Item)

bit MTxClk;
bit MTxD;
bit MTxEn;
bit MTxErr;
bit MCrS;

bit int_o;

// component constructor 
function new(string name="");
		super.new(name);
endfunction


endclass
class Tx_seqr extends uvm_sequencer;


//------FACTORY Registration----------------//
	`uvm_component_utils(Tx_seqr)


// component constructor 
function new(string name,uvm_component parent);
		super.new(name,parent);
endfunction

endclass
class Tx_Seq extends uvm_sequence#(Tx_Seq_Item);



//------FACTORY Registration----------------//
	`uvm_object_utils(Tx_Seq)


// object constructor 
function new(string name="");
		super.new(name);
endfunction


        task body();
        req=Tx_Seq_Item::type_id::create("req in mem_seq");

                         repeat(1000)
                            begin   
                                  start_item(req);
                                     finish_item(req);
                             end


        endtask


endclass
