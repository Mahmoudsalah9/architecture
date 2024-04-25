LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory_stage IS
	PORT(
		CLK,RST  : IN std_logic;
        InPort_Enable_in,OutPort_Enable_in,Swap_Enable_in,Write_Enable_in,Mem_Write_enable  : IN std_logic;
        Read_port2_data_in,Immediate_data_in,Write_Data2_in: IN  std_logic_vector(31 DOWNTO 0);
        Alu_result_in,PC_value: IN  std_logic_vector(11 DOWNTO 0);
		Write_Add_1_in,Write_Add_2_in  : IN std_logic;
        WB_Selector_in,Call_enable,Mem_Add_selector:IN  std_logic_vector(1 DOWNTO 0);
        CCR:IN  std_logic_vector(3 DOWNTO 0); 
        InPort_Enable_out,OutPort_Enable_out,Swap_Enable_out,Write_Enable_out  : OUT std_logic;
        Read_port2_data_out,Immediate_data_out,Write_Data2_out:OUT  std_logic_vector(31 DOWNTO 0);
        Alu_result_out: OUT std_logic_vector(11 DOWNTO 0);
		Write_Add_1_out,Write_Add_2_out  : OUT std_logic;
        WB_Selector_out:OUT  std_logic_vector(1 DOWNTO 0);
		Result_Mem:OUT  std_logic_vector(31 DOWNTO 0)



);

END ENTITY memory_stage;

ARCHITECTURE sync_Memory OF memory_stage IS

COMPONENT Memory IS
	PORT(
		CLK,RST,write_enable  : IN std_logic;
		address : IN  std_logic_vector(11 DOWNTO 0);
		datain : IN std_logic_vector(31 DOWNTO 0); 
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END COMPONENT;


COMPONENT Mux4x1 IS
GENERIC (n : INTEGER := 32);
PORT (
    in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
);
END COMPONENT;
Signal Wtite_Data:STD_LOGIC_VECTOR (31 DOWNTO 0);
Signal Address:STD_LOGIC_VECTOR (11 DOWNTO 0);
BEGIN	
Mux4x1_Write_Data : Mux4x1 GENERIC MAP(32) PORT MAP(Read_port2_data_in, CCR, PC_value, x"00000000000000000000000000000000",Call_enable,Wtite_Data); 
Mux4x1_Address : Mux4x1 GENERIC MAP(12) PORT MAP(Alu_result_in( 11 downto 0), Read_port2_data_in( 11 downto 0), x"000000000000", x"000000000000",Mem_Add_selector,Address); 
Memory:  Memory PORT MAP(CLK,RST,Mem_Write_enable,Wtite_Data,Result_Mem); 
InPort_Enable_out<=InPort_Enable_in;
OutPort_Enable_out<=OutPort_Enable_in;
Swap_Enable_out<=Swap_Enable_in;
Write_Enable_out<=Write_Enable_in;
Read_port2_data_out<=Read_port2_data_outin;
Immediate_data_out<=Immediate_data_in;
Write_Data2_out<=Write_Data2_in;
Alu_result_out<=Alu_result_in;
Write_Add_1_out<=Write_Add_1_in
Write_Add_2_out<=Write_Add_2_in;
WB_Selector_out<=WB_Selector_in;
        
END sync_Memory;