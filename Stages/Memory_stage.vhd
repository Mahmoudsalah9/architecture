LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory_Stage IS
    PORT (
        CLK, RST, Protect, OutPort_Enable_in, Swap_Enable_in : IN STD_LOGIC;
        Mem_Add_selector : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        WB_Selector_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Free : IN STD_LOGIC;
        Write_Enable_in, Mem_Write_enable, Mem_Write_INT_FSM : IN STD_LOGIC;
        Ret_Enable_In : IN STD_LOGIC;
        Write_Data_Selector, Mux_Select_INT_FSM : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        CCR_Out : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        PC_Address_INT_OUT, Read_port2_data_in, PC_Value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_result_in, SP : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        Write_Add_1_in, Write_Add_2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Immediate_data_in, Write_Data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM_Add_MUX_RTI_Select, MEM_Add_MUX_INT_Select : IN STD_LOGIC;

        Ret_Enable_Out : OUT STD_LOGIC;
        OutPort_Enable_out, Swap_Enable_out : OUT STD_LOGIC;
        WB_Selector_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Write_Enable_out : OUT STD_LOGIC;
        Result_Mem : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Protected_To_Exception : OUT STD_LOGIC;
        Read_port2_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Alu_result_out : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        Write_Add_1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Immediate_data_out, Write_Data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_Add_2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Memory_Stage_Deisgn OF Memory_Stage IS

    COMPONENT Memory IS
        PORT (
            CLK, RST, Memory_Write_Enable, Free, Protect : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            Write_Data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Protected_Data : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT Mux4x1 IS
        GENERIC (n : INTEGER := 32);
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT Mux2x1 IS
        GENERIC (n : INTEGER := 12);
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            MUX_Out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Address : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL Result_Mux4x1_level_1_Data : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL Result_Mux4x1_level_1_Address : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL CCR_Write_Data : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL Result_Mux4x1_level_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL OR_OUT : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL Result_Mux2x1 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL Write_Mem_enable : STD_LOGIC;

BEGIN
CCR_Write_Data(3 downto 0)<=CCR_Out;
CCR_Write_Data(31 downto 4)<=x"0000000"

    Mux4x1__level_1_Data : Mux4x1 GENERIC MAP(32) PORT MAP(Read_port2_data_in, PC_Value, x"00000000", x"00000000", Write_Data_Selector, Result_Mux4x1_level_1_Data);
    Mux4x1__level_2 : Mux4x1 GENERIC MAP(32) PORT MAP(Result_Mux4x1_level_1_Data, PC_Address_INT_OUT, CCR_Write_Data, x"00000000", Mux_Select_INT_FSM, Result_Mux4x1_level_2);
    Mux4x1__level_1_Address : Mux4x1 GENERIC MAP(12) PORT MAP(Alu_result_in, Read_port2_data_in(11 DOWNTO 0), SP, x"00000000", Mem_Add_selector, Result_Mux4x1_level_1_Address);
    OR_OUT <= MEM_Add_MUX_RTI_Select OR MEM_Add_MUX_INT_Select;
    Mux2x1 : Mux2x1 GENERIC MAP(12) PORT MAP(Result_Mux4x1_level_1_Address, SP, OR_OUT, Result_Mux2x1);
    Write_Mem_enable <= Mem_Write_enable OR Mem_Write_INT_FSM;
    Memory_instance : Memory PORT MAP(CLK, RST, Write_Mem_enable, Free, Protect, Result_Mux2x1, Result_Mux4x1_level_2, Result_Mem, Protected_To_Exception);
    Ret_Enable_Out <= Ret_Enable_In;
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

END ARCHITECTURE;