LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Write_Back IS
	PORT(
		
        OutPort_Enable,Swap_Enable_in,Write_Enable_in : IN std_logic;
        Read_port2_data,Immediate_data,Write_Data2_in: IN  std_logic_vector(31 DOWNTO 0);
        Result_Mem:IN  std_logic_vector(31 DOWNTO 0);
        Alu_result: IN  std_logic_vector(31 DOWNTO 0);
		Write_Add_1_in,Write_Add_2_in  :IN  std_logic_vector(2 DOWNTO 0);
        WB_Selector:IN  std_logic_vector(1 DOWNTO 0);
        Swap_Enable_out,Write_Enable_out  : OUT std_logic_vector(2 DOWNTO 0);
        Write_Data2_out:OUT  std_logic_vector(31 DOWNTO 0);
		Write_Add_1_out,Write_Add_2_out  : OUT std_logic;
        OUT_PORT:OUT std_logic_vector(31 DOWNTO 0)
		Wtite_Back_Data:OUT std_logic_vector(31 DOWNTO 0)



);

END ENTITY Write_Back;

ARCHITECTURE my_Write_Back OF Write_Back IS




COMPONENT Mux4x1 IS
GENERIC (n : INTEGER := 32);
PORT (
    in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
);
END COMPONENT;


BEGIN	
Mux4x1_Write_Data : Mux4x1 GENERIC MAP(32) PORT MAP(Alu_result, Result_Mem, Immediate_data, Read_port2_data,WB_Selector,Wtite_Back_Data); 

OUT_PORT<=Read_port2_data when OutPort_Enable='1' else
    x"00000000000000000000000000000000";
Swap_Enable_out<=Swap_Enable_in;
Write_Enable_out<=Write_Enable_in;
Write_Data2_out<=Write_Data2_in;
Write_Add_1_out<=Write_Add_1_in
Write_Add_2_out<=Write_Add_2_in;

        
END my_Write_Back;