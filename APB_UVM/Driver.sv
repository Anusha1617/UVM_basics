class Driver extends uvm_driver #(Transaction);

`uvm_component_utils(Driver)  //1.factory registration

virtual APB_intf h_vintf;      // interface handle

Transaction h_trans;

//---------------COMPONENT CONSTRUCTOR-----------------------//
function new(string name="", uvm_component parent );   // component constructor

            super.new(name,parent);  // creating memory for parent class

endfunction


//----------------- CONNECT PHASE-------------------//
	function void connect_phase(uvm_phase phase);

        $display("hieraechy=%s",this.get_full_name());
		if(! uvm_config_db #(virtual APB_intf)::get(null,this.get_full_name(),"apb_intf_key",h_vintf))  // getting signals from the configdb
//		if(! uvm_config_db #(virtual APB_intf)::get(this,this.get_full_name(),"apb_intf_key",h_vintf))

			`uvm_fatal("config failure",$sformatf("=== Failing to establish config in driver"));
	endfunction


 //------------------build phase ----------------------------//
    virtual function void build_phase(uvm_phase phase);
      		super.build_phase(phase); 
     		h_trans = Transaction::type_id::create("h_trans");   // creating memory for transaction
    endfunction

//---------------------RUN PHASE -------------------------//

task run_phase(uvm_phase phase);
       // super.run_phase(phase);
       @(h_vintf.cb_driver)   h_vintf.cb_driver.reset_n <= 1 ;
       @(h_vintf.cb_driver)   h_vintf.cb_driver.reset_n <= 0 ;
       @(h_vintf.cb_driver)   h_vintf.cb_driver.reset_n <= 1 ;
       
//			      h_vintf.cb_driver.pselx<=0;
forever@(h_vintf.cb_driver)
        begin
               seq_item_port.get_next_item(h_trans);   // try with different name     waiting fo the next item  sequencer will give the data by collecting from the sequence item
// PROTOCOL DRIVER LOGIC               
           /* if(h_trans.pselx==0)
                begin 
// 			soft	reset_n=1
                        h_vintf.cb_driver.paddress <= 0;
                        h_vintf.cb_driver.pwdata <= 0;
                        h_vintf.cb_driver.pwrite <= 0;
                        h_vintf.cb_driver.penable <= 0;
                end
             else
                  begin
                        h_vintf.cb_driver.paddress <= h_trans.paddress;
                        h_vintf.cb_driver.pwrite <= h_trans.pwrite ;
                        h_vintf.cb_driver.pselx <= h_trans.pselx;
                        h_vintf.cb_driver.penable <=0;
                        h_vintf.cb_driver.pwdata <=h_trans.pwdata ;
                        @(h_vintf.cb_driver)   // after one posedge clk 
                        h_vintf.cb_driver.penable <=1;    // penable ==1 
                      //  wait(h_vintf.pready);   // waiting for pready
                        @(h_vintf.cb_driver);   // giving same values in next posedge clk

                  end
			`uvm_info("NEW_Driver_run_phase",$sformatf("\n\treq===> %p",req),UVM_NONE);
		*/
		// NORMAL LOGIC
                        h_vintf.cb_driver.reset_n <= h_trans.reset_n;		
                        h_vintf.cb_driver.paddress <= h_trans.paddress;
                        h_vintf.cb_driver.pwrite <= h_trans.pwrite ;
                        h_vintf.cb_driver.pselx <= h_trans.pselx;
                        h_vintf.cb_driver.penable <=h_trans.penable;
                        h_vintf.cb_driver.pwdata <=h_trans.pwdata ;
			
			               seq_item_port.item_done();   // item done   
        end
endtask

endclass
/*
     rand bit reset_n;
     rand bit [31:0]paddress;
     rand bit pwrite;
     rand bit pselx;
     rand bit penable;
     rand bit [31:0]pwdata;
*/
