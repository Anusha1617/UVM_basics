typedef bit[7:0] Payload [$];
typedef enum {BAD,GOOD} FRAME;
typedef class payload;
class Config_class extends uvm_object;

bit ready;
//  REGISTERS 
	bit [31:0] MODER,INT_MASK,INT_SOURCE;

	bit [31:0] MIIADDRESS, MAC_ADDR0, MAC_ADDR1;
	bit [31:0] TX_BD_NUM;

//FIELDS in REGISTERS
	bit PAD,HUGEN,FULLD,LOOPBACK,IFG,PRO,BRO,NOPRE,TXEN,RXEN; // moder

	bit RXE_M,RXB_M,TXE_M,TXB_M;  // int mask

	bit RXB,RXE,TXE,TXB;   // int source

// fields in TXBD's  and RXBD's






	bit [15:0]LEN[$:128];     //129 loc
	bit [15:0]RxLEN[$:128];
	bit RD[$:128];
	bit EMP[$:128];
	bit IRQ[$:128];
	bit [31:0] TXPNT[$:128];
	bit[7:0] BD_memory[int] ;
	bit[31:0] MEM [int];
	payload TX_payloads [$];//class
	payload RX_payloads [$];
	
	
		`uvm_object_utils_begin(Config_class)
    `uvm_field_int(MAC_ADDR0,UVM_ALL_ON)
    `uvm_field_int(MAC_ADDR1,UVM_ALL_ON)
    `uvm_field_int(MIIADDRESS,UVM_ALL_ON)
    `uvm_field_int(TX_BD_NUM,UVM_ALL_ON)
    `uvm_field_aa_int_int(BD_memory,UVM_ALL_ON)
    `uvm_field_queue_int(LEN,UVM_ALL_ON)
    `uvm_field_queue_int(RD,UVM_ALL_ON)
    `uvm_field_queue_int(IRQ,UVM_ALL_ON)
    `uvm_field_int(INT_MASK,UVM_ALL_ON)
    `uvm_object_utils_end
    
    // obj constructor
	function new(string name="");
		super.new(name);
	endfunction


function void default_values();  // when doing reset call this
		MODER='hA200;
		INT_MASK=0;
		INT_SOURCE=0;
		MIIADDRESS=0;
		MAC_ADDR0=0;
		MAC_ADDR1=0;
		TX_BD_NUM='h40;
        LEN.delete();     //129 loc
    	RxLEN.delete();
    	RD.delete();
    	EMP.delete();
    	IRQ.delete();
    	TXPNT.delete();
    	PAD=0;HUGEN=0;FULLD=0;LOOPBACK=0;IFG=0;PRO=0;BRO=0;NOPRE=0;TXEN=0;RXEN=0; // moder
	    RXE_M=0;RXB_M=0;TXE_M=0;TXB_M=0;  // int mask
    	RXB=0;RXE=0;TXE=0;TXB=0;   // int source
        TX_payloads.delete;
        RX_payloads.delete;
endfunction


	function int get_no_tx_ready ();// returns number of tx_BDs with ready.
	int i;
		foreach (RD[index])
			if(RD[index] == 1) i++;
		return i;
	endfunction

	function int get_no_rx_empty ();// returns number of rx_BDs with empty.
	int i;
		foreach (EMP[index])
			if(EMP[index] == 1) i++;
		return i;
	endfunction

	function int get_txlen ( bit[6:0] i);// returns length of payload for tx path.
		return LEN[i];
	endfunction

	function int get_rxlen (bit[6:0] i);// returns length of payload for tx path.
		return RxLEN[i];
	endfunction


	task set_tx_payload(input Payload pl);
    	payload p1;
		p1=new(pl,GOOD);
		TX_payloads.push_back(p1);
	endtask

	task set_rx_payload(input Payload pl);
	    payload p1;
		p1=new(pl,GOOD);
		RX_payloads.push_back(p1);
	endtask

	function void mem_disp();
	$display("	MEMORY	ALL");
	foreach(MEM[i])
	$display("\n");
	endfunction

	function void set_mem (int add,int data);
		MEM[add] = data;
	endfunction
endclass

class payload;
	Payload pl;
	FRAME f;

	function new(Payload pl,FRAME f);
		this.pl=pl;
		this.f=f;
	endfunction

endclass
