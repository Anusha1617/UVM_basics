home = /home/chicago/tools/Questa_2022.4_3/questasim/linux_x86_64/../modelsim.ini

pkg = ../mcs_dv05_ethernet_project_test/mcs_dv05_ethernet_project_package.sv

top = ../mcs_dv05_ethernet_project_top/mcs_dv05_ethernet_project_top.sv



work:
	vlib work
map:
	vmap work work

comp:
	vlog -work work +cover +acc $(pkg)      $(top) 
	
	
	
	
	

sim:
	vsim  -coverage -debugdb -c -do "log -r /*; coverage save -onexit cover_file.ucdb -cvg -directive -codeAll;run -all;exit" -l	log_file.log work.top +UVM_TESTNAME=Test ##+UVM_CONFIG_DB_TRACE +uvm_set_action=uvm_test_top.*,_ALL_,UVM_INFO,UVM_NO_ACTION




all:
	vlog -work work +cover +acc $(pkg) $(top) $(interface) 
	vsim  -coverage -debugdb -c -do "log -r /*; coverage save -onexit coverage.ucdb -cvg -directive -codeAll;run -all;exit" -l	log_file.log work.top +UVM_TESTNAME=Test ##+UVM_CONFIG_DB_TRACE +uvm_set_action=uvm_test_top.*,_ALL_,UVM_INFO,UVM_NO_ACTION


clean:
	rm -rf *.ini transcript work regression_status_list *.log merge_list_file *.wlf


