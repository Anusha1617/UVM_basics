
class  Output_Monitor extends Input_Monitor;

`uvm_component_utils(Output_Monitor)//1.factory registration
uvm_analysis_port #(Transaction) h_trans_opmo_sb_port;  //sending
virtual APB_intf h_vintf;

Transaction h_trans;

function new(string name="",uvm_component parent);
        super.new(name,parent);  // creating memory for parent class
endfunction

function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		h_trans_opmo_sb_port = new("h_trans_opmo_sb_port",this);
		h_trans=new("h_trans");
endfunction

function void connect_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual APB_intf)::get(this,"","apb_intf_key",h_vintf))
			`uvm_fatal("config failure",$sformatf("=== Failing to establish config in input monitor"));
endfunction

	task run_phase(uvm_phase phase);
		//super.run_phase(phase);
		forever@(h_vintf.cb_monitor) 
        begin  // collecting signals from the confidb
			h_trans.reset_n = h_vintf.cb_monitor.reset_n;
			h_trans.pselx = h_vintf.cb_monitor.pselx;
			h_trans.paddress = h_vintf.cb_monitor.paddress;
			h_trans.pwdata = h_vintf.cb_monitor.pwdata;
			h_trans.pwrite= h_vintf.cb_monitor.pwrite;
			h_trans.penable = h_vintf.cb_monitor.penable;
			h_trans.pready = h_vintf.cb_monitor.pready;
			h_trans.prdata = h_vintf.cb_monitor.prdata;
			h_trans.pslverr = h_vintf.cb_monitor.pslverr;

			h_trans_opmo_sb_port.write(h_trans);
		end
	endtask




endclass

