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
