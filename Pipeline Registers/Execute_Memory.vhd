LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Execute_Memory IS
    PORT (
        clk : IN STD_LOGIC;
        Rst : IN STD_LOGIC;

        -- Inputs:
        Protect_IN : IN STD_LOGIC;
        Out_Enable_IN : IN STD_LOGIC;
        Swap_Enable_IN : IN STD_LOGIC;
        Memory_Add_Selec_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Write_Back_Selector_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Free_IN : IN STD_LOGIC;
        Write_Enable_IN : IN STD_LOGIC;
        Mem_READ_IN : IN STD_LOGIC;
        Mem_Write_IN : IN STD_LOGIC;
        Call_Enable_IN : IN STD_LOGIC;
        RET_Enable_IN : IN STD_LOGIC;

        Final_Result_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteAdd1_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteAdd2_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Imm_Data_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData2_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_Value_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SP_IN_Buffered : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

        -- Outputs:
        Protect_OUT : OUT STD_LOGIC;
        Out_Enable_OUT : OUT STD_LOGIC;
        Swap_Enable_OUT : OUT STD_LOGIC;
        Memory_Add_Selec_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Write_Back_Selector_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        Free_OUT : OUT STD_LOGIC;
        Write_Enable_OUT : OUT STD_LOGIC;
        Mem_READ_OUT : OUT STD_LOGIC;
        Mem_Write_OUT : OUT STD_LOGIC;
        Call_Enable_OUT : OUT STD_LOGIC;
        RET_Enable_OUT : OUT STD_LOGIC;

        Final_Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Port2_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteAdd1_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteAdd2_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Imm_Data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WriteData2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_Value_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        SP_OUT_Buffered : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)

    );
END ENTITY;

ARCHITECTURE Execute_Memory_Design OF Execute_Memory IS
BEGIN
    PROCESS (clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            -- Initialize outputs to default values
            Protect_OUT <= '0';
            Out_Enable_OUT <= '0';
            Swap_Enable_OUT <= '0';
            Memory_Add_Selec_OUT <= (OTHERS => '0');
            Write_Back_Selector_OUT <= (OTHERS => '0');
            Free_OUT <= '0';
            Write_Enable_OUT <= '0';
            Mem_READ_OUT <= '0';
            Mem_Write_OUT <= '0';
            Call_Enable_OUT <= '0';
            RET_Enable_OUT <= '0';
            Final_Result <= (OTHERS => '0');
            Read_Port2_Data_OUT <= (OTHERS => '0');
            WriteAdd1_OUT <= (OTHERS => '0');
            WriteAdd2_OUT <= (OTHERS => '0');
            Imm_Data_OUT <= (OTHERS => '0');
            WriteData2_OUT <= (OTHERS => '0');
            PC_Value_OUT <= (OTHERS => '0');
            SP_OUT_Buffered <= (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            -- Assign outputs with input values
            Protect_OUT <= Protect_IN;
            Out_Enable_OUT <= Out_Enable_IN;
            Swap_Enable_OUT <= Swap_Enable_IN;
            Memory_Add_Selec_OUT <= Memory_Add_Selec_IN;
            Write_Back_Selector_OUT <= Write_Back_Selector_IN;
            Free_OUT <= Free_IN;
            Write_Enable_OUT <= Write_Enable_IN;
            Mem_READ_OUT <= Mem_READ_IN;
            Mem_Write_OUT <= Mem_Write_IN;
            Call_Enable_OUT <= Call_Enable_IN;
            RET_Enable_OUT <= RET_Enable_IN;
            Final_Result <= Final_Result_IN;
            Read_Port2_Data_OUT <= Read_Port2_Data_IN;
            WriteAdd1_OUT <= WriteAdd1_IN;
            WriteAdd2_OUT <= WriteAdd2_IN;
            Imm_Data_OUT <= Imm_Data_IN;
            WriteData2_OUT <= WriteData2_IN;
            PC_Value_OUT <= PC_Value_IN;
            SP_OUT_Buffered <= SP_IN_Buffered;

        END IF;
    END PROCESS;
END ARCHITECTURE;