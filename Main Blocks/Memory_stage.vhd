LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory_stage IS
<<<<<<< HEAD
	PORT(
		CLK,RST  : IN std_logic;
        InPort_Enable_in,OutPort_Enable_in,Swap_Enable_in,Write_Enable_in,Mem_Write_enable  : IN std_logic;
        Read_port2_data_in,Immediate_data_in,Write_Data2_in: IN  std_logic_vector(31 DOWNTO 0);
        Alu_result_in,PC_value: IN  std_logic_vector(11 DOWNTO 0);
		Write_Add_1_in,Write_Add_2_in  : IN std_logic_vector(2 DOWNTO 0);
        WB_Selector_in,Call_enable,Mem_Add_selector:IN  std_logic_vector(1 DOWNTO 0);
        CCR:IN  std_logic_vector(3 DOWNTO 0); 
        InPort_Enable_out,OutPort_Enable_out,Swap_Enable_out,Write_Enable_out  : OUT std_logic;
        Read_port2_data_out,Immediate_data_out,Write_Data2_out:OUT  std_logic_vector(31 DOWNTO 0);
        Alu_result_out: OUT std_logic_vector(11 DOWNTO 0);
		Write_Add_1_out,Write_Add_2_out  : OUT std_logic_vector(2 DOWNTO 0);
        WB_Selector_out:OUT  std_logic_vector(1 DOWNTO 0);
		Result_Mem:OUT  std_logic_vector(31 DOWNTO 0)
=======
    PORT (
        CLK, RST : IN STD_LOGIC;
        InPort_Enable_in, OutPort_Enable_in, Swap_Enable_in, Write_Enable_in, Mem_Write_enable : IN STD_LOGIC;
        Read_port2_data_in, Immediate_data_in, Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_result_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        Write_Add_1_in, Write_Add_2_in : IN STD_LOGIC;
        WB_Selector_in, Mem_Add_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        InPort_Enable_out, OutPort_Enable_out, Swap_Enable_out, Write_Enable_out : OUT STD_LOGIC;
        Read_port2_data_out, Immediate_data_out, Write_Data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_result_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        Write_Add_1_out, Write_Add_2_out : OUT STD_LOGIC;
        WB_Selector_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Result_Mem : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
>>>>>>> d45c801a471b6c971e746e652fc7e299d151f581

    );

END ENTITY memory_stage;

ARCHITECTURE sync_Memory OF memory_stage IS

    COMPONENT Memory IS
        PORT (
            CLK, RST, write_enable : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    COMPONENT Mux4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Address : STD_LOGIC_VECTOR (11 DOWNTO 0);

BEGIN

    Mux4x1_Address : Mux4x1 GENERIC MAP(12) PORT MAP(Alu_result_in(11 DOWNTO 0), Read_port2_data_in(11 DOWNTO 0), x"00000000", x"00000000", Mem_Add_selector, Address);
    Memory_instance : Memory PORT MAP(CLK, RST, Mem_Write_enable, Address, Read_port2_data_in, Result_Mem);
    InPort_Enable_out <= InPort_Enable_in;
    OutPort_Enable_out <= OutPort_Enable_in;
    Swap_Enable_out <= Swap_Enable_in;
    Write_Enable_out <= Write_Enable_in;
    Read_port2_data_out <= Read_port2_data_in;
    Immediate_data_out <= Immediate_data_in;
    Write_Data2_out <= Write_Data2_in;
    Alu_result_out <= Alu_result_in;
    Write_Add_1_out <= Write_Add_1_in;
    Write_Add_2_out <= Write_Add_2_in;
    WB_Selector_out <= WB_Selector_in;

END sync_Memory;