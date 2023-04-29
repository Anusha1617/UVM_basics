//----------APB SLAVE -------//
pclk_i
prstn_i
paddr_i
pwdata_i
psel_i
pwrite_i
penable_i

prdata_o
pready_o

//------COMMON SIGNALS ------//

int_o

//----- APB MASTER ----------//

m_paddr_o
m_pwdata_o
m_psel_o
m_pwrite_o
m_penable_o

m_pready_i
m_prdata_i


//------TX-------//
MTxClk
MTxD
MTxEn   
MTxErr

//------COMMON SIGNALS ------//
MCrS

//------RX-------//
MRxClk
MRxDV
MRxD
MRxErr


